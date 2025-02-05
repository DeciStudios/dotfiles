# setup.ps1
# Run with PowerShell 5.1. Ensure you have proper privileges for creating symbolic links.
$ErrorActionPreference = "Stop"

# -----------------------------
# Global Variables
# -----------------------------
# Directory where this script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$backupDir  = Join-Path $scriptDir "backup"
$trackerFile = Join-Path $scriptDir ".tracker"
$enabledFile = Join-Path $scriptDir ".enabled"

# Ensure backup directory exists
if (-not (Test-Path $backupDir)) { New-Item -ItemType Directory -Path $backupDir | Out-Null }

# Ensure main user directories exist
$dirsToEnsure = @(
    "$HOME\.config",
    "$HOME\.local",
    "$HOME\.local\bin",
    "$HOME\.local\share"
)
foreach ($dir in $dirsToEnsure) {
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
}

# List of files and directories to ignore
$ignoreList = @(
    ".gitignore", "setup.sh", ".git", "README.md",
    ".gitattributes", ".tracker", "backup", ".enabled", "config"
)

# -----------------------------
# Helper Functions
# -----------------------------

function Should-Ignore {
    param([string]$file)
    return $ignoreList -contains $file
}

function Is-Symlink {
    param([string]$path)
    if (Test-Path $path) {
        $item = Get-Item $path -Force
        return ( $item.Attributes -band [System.IO.FileAttributes]::ReparsePoint ) -ne 0
    }
    return $false
}

function Trash-Item {
    param([string]$path)
    # "Trash" the item by forcefully removing it.
    if (Test-Path $path) {
        Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function Backup-File {
    param([string]$file)
    $relativePath = $file.Substring($HOME.Length)
    $backupTargetDir = Join-Path $backupDir (Split-Path $relativePath -Parent)
    if (-not (Test-Path $backupTargetDir)) {
        New-Item -ItemType Directory -Path $backupTargetDir | Out-Null
    }
    Write-Output "Backing up existing file: $file"
    Move-Item $file -Destination $backupTargetDir -Force
}

# -----------------------------
# Dotfiles Linking Functions
# -----------------------------

function Link-DotfilesFromConfig {
    param([string]$configName)
    $configFilePath = Join-Path (Join-Path $scriptDir "config") $configName
    Write-Output "Linking dotfiles from config file: $configFilePath..."
    if (-not (Test-Path $configFilePath)) {
        Write-Output "Config file $configFilePath not found."
        return
    }
    Get-Content $configFilePath | ForEach-Object {
        $line = $_.Trim()
        if ([string]::IsNullOrEmpty($line) -or $line -match "^\s*#") { return }
        $src  = Join-Path $scriptDir $line
        Write-Output "line: $line"
        Write-Output "src: $src"
        Write-Output "scriptDir: $scriptDir"
        $dest = Join-Path $HOME $line

        if (-not (Test-Path $src)) {
            Write-Output "Warning: $src does not exist, skipping."
            return
        }

        if ((Test-Path $dest -PathType Any) -and (-not (Is-Symlink $dest))) {
            Backup-File $dest
        }

        $destDir = Split-Path $dest -Parent
        if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }

        Write-Output "Creating symlink for $src -> $dest"
        if (Test-Path $dest) { Remove-Item $dest -Force }
        New-Item -ItemType SymbolicLink -Path $dest -Target $src -Force | Out-Null
        Add-Content -Path $trackerFile -Value $dest
    }
}

function Link-DotfilesRecursive {
    param(
        [string]$src,
        [string]$dest
    )
    Get-ChildItem -LiteralPath $src -Force | ForEach-Object {
        $baseitem = $_.Name
        $target = Join-Path $dest $baseitem

        if (Should-Ignore $baseitem) { return }

        if ($_.PSIsContainer) {
            if (-not (Test-Path $target)) {
                Write-Output "Creating symlink for directory $($_.FullName) -> $target"
                New-Item -ItemType SymbolicLink -Path $target -Target $_.FullName -Force | Out-Null
                Add-Content -Path $trackerFile -Value ($target + "\")
            } elseif (Is-Symlink $target -and -not (Test-Path $target -PathType Container)) {
                Write-Output "Removing invalid symlink for directory: $target"
                Trash-Item $target
                Write-Output "Creating symlink for directory $($_.FullName) -> $target"
                New-Item -ItemType SymbolicLink -Path $target -Target $_.FullName -Force | Out-Null
                Add-Content -Path $trackerFile -Value ($target + "\")
            } else {
                Link-DotfilesRecursive -src $_.FullName -dest $target
            }
        }
        else {
            if (Test-Path $target -PathType Leaf -and -not (Is-Symlink $target)) {
                Write-Output "Backing up existing file: $target"
                Backup-File $target
            }
            if (-not (Is-Symlink $target)) {
                Write-Output "Creating symlink for file $($_.FullName) -> $target"
                if (Test-Path $target) { Remove-Item $target -Force }
                New-Item -ItemType SymbolicLink -Path $target -Target $_.FullName -Force | Out-Null
                Add-Content -Path $trackerFile -Value $target
            }
        }
    }
}

function Handle-SymlinkedItems {
    if (Test-Path $trackerFile) {
        Get-Content $trackerFile | ForEach-Object {
            $item = $_.Trim()
            $actualItem = $item.TrimEnd("\")
            if ((Test-Path $actualItem -PathType Container) -and (Is-Symlink $actualItem)) { return }
            if (Is-Symlink $actualItem -and -not (Test-Path $actualItem)) {
                Write-Output "Removing broken symlink: $actualItem"
                Trash-Item $actualItem
            }
        }
    }
}

function Link-Dotfiles {
    Write-Output "Linking dotfiles..."
    if (-not (Test-Path $trackerFile)) { New-Item -ItemType File -Path $trackerFile -Force | Out-Null }
    Link-DotfilesRecursive -src $scriptDir -dest $HOME
    Handle-SymlinkedItems
}

# -----------------------------
# Dotfiles Unlinking Functions
# -----------------------------

function Unlink-Dotfiles {
    Write-Output "Unlinking dotfiles..."
    $newTrackerFile = "$trackerFile.new"
    New-Item -ItemType File -Path $newTrackerFile -Force | Out-Null

    Get-Content $trackerFile | ForEach-Object {
        $item = $_.Trim()
        $actualItem = $item.TrimEnd("\")
        if ((Test-Path $actualItem -PathType Container) -and (Is-Symlink $actualItem)) {
            Write-Output "Removing symlink directory: $actualItem"
            Trash-Item $actualItem
        }
        elseif (Is-Symlink $actualItem) {
            Write-Output "Removing symlink: $actualItem"
            Trash-Item $actualItem
        }
        else {
            $relativePath = $actualItem.Substring($HOME.Length)
            $backupFilePath = Join-Path $backupDir (Join-Path (Split-Path $relativePath -Parent) (Split-Path $actualItem -Leaf))
            if (Test-Path $backupFilePath) {
                Write-Output "Restoring backup: $backupFilePath -> $actualItem"
                $destDir = Split-Path $actualItem -Parent
                if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir -Force | Out-Null }
                Move-Item $backupFilePath -Destination $actualItem -Force
            }
        }
    }

    $newContent = @()
    Get-Content $trackerFile | ForEach-Object {
        $item = $_.Trim()
        $actualItem = $item.TrimEnd("\")
        if (Test-Path $actualItem -or (Is-Symlink $actualItem)) {
            $newContent += $item
        }
    }
    $newContent | Set-Content $trackerFile
}

function Unlink-DotfilesRecursive {
    param([string]$dest)
    Get-ChildItem -LiteralPath $dest -Force | ForEach-Object {
        $actualItem = $_.FullName.TrimEnd("\")
        if (Is-Symlink $actualItem -and $_.PSIsContainer) {
            Write-Output "Removing symlink directory: $actualItem"
            Trash-Item $actualItem
        }
        elseif (Is-Symlink $actualItem) {
            Write-Output "Removing symlink: $actualItem"
            Trash-Item $actualItem
        }
    }
}

function Clean-Symlinks {
    Write-Output "Cleaning untracked symlinks..."
    if (Test-Path $trackerFile) {
        $newTrackerFile = "$trackerFile.new"
        New-Item -ItemType File -Path $newTrackerFile -Force | Out-Null
        Get-Content $trackerFile | ForEach-Object {
            $item = $_.Trim()
            $actualItem = $item.TrimEnd("\")
            if (Is-Symlink $actualItem) {
                $dotfilePath = Join-Path $scriptDir ($actualItem.Substring($HOME.Length))
                if (-not (Test-Path $dotfilePath)) {
                    Write-Output "Removing orphaned symlink: $actualItem"
                    Trash-Item $actualItem
                }
                else {
                    Add-Content -Path $newTrackerFile -Value $item
                }
            }
            else {
                Add-Content -Path $newTrackerFile -Value $item
            }
        }
        Move-Item -Path $newTrackerFile -Destination $trackerFile -Force
    }
}

function Reinstall-Dotfiles {
    Write-Output "Reinstalling dotfiles..."
    Unlink-Dotfiles
    Link-Dotfiles
}

# -----------------------------
# Usage Function
# -----------------------------
function Show-Usage {
    Write-Output "Usage: setup.ps1 {enable|disable|reinstall|clean} [config_file]"
    exit 1
}

# -----------------------------
# Main Script Execution
# -----------------------------
if ($args.Count -lt 1) {
    Show-Usage
}

switch ($args[0].ToLower()) {
    "enable" {
        if (Test-Path $enabledFile) {
            Write-Output "Dotfiles are already enabled. Run 'reinstall' if new files have been added."
            exit 1
        }
        else {
            if ($args.Count -ge 2) {
                Link-DotfilesFromConfig $args[1]
            }
            else {
                Link-Dotfiles
            }
            New-Item -ItemType File -Path $enabledFile -Force | Out-Null
        }
    }
    "disable" {
        if (Test-Path $enabledFile) {
            Unlink-Dotfiles
            Remove-Item $enabledFile -Force
        }
        else {
            Write-Output "Dotfiles are already disabled. Run 'enable' to install."
            exit 1
        }
    }
    "reinstall" {
        if (Test-Path $enabledFile) {
            Reinstall-Dotfiles
        }
        else {
            Write-Output "Dotfiles are not installed. Run 'enable' to install."
            exit 1
        }
    }
    "clean" {
        if (Test-Path $enabledFile) {
            Clean-Symlinks
        }
        else {
            Write-Output "Dotfiles are not installed. Run 'enable' to install."
            exit 1
        }
    }
    Default {
        Show-Usage
    }
}

Write-Output "Dotfiles $($args[0]) completed."
