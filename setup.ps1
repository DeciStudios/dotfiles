# Directory where this script is located
$SCRIPT_DIR = (Get-Location).Path
$BACKUP_DIR = "$SCRIPT_DIR\backup"
$TRACKER_FILE = "$SCRIPT_DIR\.tracker"
$ENABLED_FILE = "$SCRIPT_DIR\.enabled"

# Ensure backup directory exists
if (-not (Test-Path -Path $BACKUP_DIR)) { New-Item -Path $BACKUP_DIR -ItemType Directory }

# Ensure main user directories exist
$HOME = [System.Environment]::GetFolderPath('MyDocuments')
$requiredDirs = @(
    "$HOME\.config",
    "$HOME\.local",
    "$HOME\.local\bin",
    "$HOME\.local\share"
)
$requiredDirs | ForEach-Object { if (-not (Test-Path $_)) { New-Item -Path $_ -ItemType Directory } }

# List of files and directories to ignore
$IGNORE_LIST = @(".gitignore", "setup.ps1", ".git", "README.md", ".gitattributes", ".tracker", "backup", ".enabled", "config")

# Function to check if a file or directory should be ignored
function Should-Ignore {
    param([string]$file)
    return $IGNORE_LIST -contains $file
}

# Function to link dotfiles using a config file
function Link-DotfilesFromConfig {
    param([string]$config_file)
    Write-Host "Linking dotfiles from config file: $config_file..."

    Get-Content -Path $config_file | ForEach-Object {
        $line = $_.Trim()
        if ($line -eq "" -or $line.StartsWith("#")) { return }

        $src = Join-Path $SCRIPT_DIR $line
        $dest = Join-Path $HOME $line

        if (-not (Test-Path -Path $src)) {
            Write-Warning "$src does not exist, skipping."
            return
        }

        if ((Test-Path -Path $dest) -and (-not (Test-Path -Path $dest -IsSymbolicLink))) {
            Write-Host "Backing up existing file: $dest"
            Backup-File $dest
        }

        # Ensure destination directory exists
        $destDir = [System.IO.Path]::GetDirectoryName($dest)
        if (-not (Test-Path -Path $destDir)) {
            New-Item -Path $destDir -ItemType Directory
        }

        Write-Host "Creating symlink for $src -> $dest"
        New-Item -ItemType SymbolicLink -Path $dest -Target $src -Force
        Add-Content -Path $TRACKER_FILE -Value $dest
    }
}

# Function to create symlinks for dotfiles
function Link-Dotfiles {
    Write-Host "Linking dotfiles..."
    if (-not (Test-Path -Path $TRACKER_FILE)) {
        New-Item -Path $TRACKER_FILE -ItemType File
    }

    # Link dotfiles recursively from SCRIPT_DIR to HOME
    Link-DotfilesRecursive $SCRIPT_DIR $HOME

    # Ensure all previously tracked items are still symlinked
    Handle-SymlinkedItems
}

# Recursive function to handle files and directories
function Link-DotfilesRecursive {
    param([string]$src, [string]$dest)

    Get-ChildItem -Path $src -Recurse -Depth 1 | ForEach-Object {
        $baseitem = $_.Name
        $target = Join-Path $dest $baseitem

        if (Should-Ignore $baseitem) {
            return
        }

        if ($_ -is [System.IO.DirectoryInfo]) {
            if (-not (Test-Path -Path $target)) {
                Write-Host "Creating symlink for directory $($_.FullName) -> $target"
                New-Item -ItemType SymbolicLink -Path $target -Target $_.FullName
                Add-Content -Path $TRACKER_FILE -Value "$target\"
            } elseif ((Test-Path -Path $target -IsSymbolicLink) -and (-not (Test-Path -Path $target -IsDirectory))) {
                Write-Host "Removing invalid symlink for directory $target"
                Remove-Item -Path $target
                Write-Host "Creating symlink for directory $($_.FullName) -> $target"
                New-Item -ItemType SymbolicLink -Path $target -Target $_.FullName
                Add-Content -Path $TRACKER_FILE -Value "$target\"
            } else {
                Link-DotfilesRecursive $_.FullName $target
            }
        } else {
            if ((Test-Path -Path $target) -and (-not (Test-Path -Path $target -IsSymbolicLink))) {
                Write-Host "Backing up existing file: $target"
                Backup-File $target
            }
            if (-not (Test-Path -Path $target -IsSymbolicLink)) {
                Write-Host "Creating symlink for file $($_.FullName) -> $target"
                New-Item -ItemType SymbolicLink -Path $target -Target $_.FullName
                Add-Content -Path $TRACKER_FILE -Value $target
            }
        }
    }
}

# Function to backup files while preserving directory structure
function Backup-File {
    param([string]$file)
    $backupTarget = Join-Path $BACKUP_DIR ((Resolve-Path $file).Path -replace [System.IO.Path]::GetPathRoot($file), "")
    $backupDir = [System.IO.Path]::GetDirectoryName($backupTarget)
    if (-not (Test-Path -Path $backupDir)) {
        New-Item -Path $backupDir -ItemType Directory
    }
    Move-Item -Path $file -Destination $backupTarget
}

# Function to remove symlinks and restore backup files
function Unlink-Dotfiles {
    Write-Host "Unlinking dotfiles..."
    $newTrackerFile = "$TRACKER_FILE.new"
    New-Item -Path $newTrackerFile -ItemType File

    Get-Content -Path $TRACKER_FILE | ForEach-Object {
        $actualItem = $_.TrimEnd("\")
        if ((Test-Path -Path $actualItem) -and (Test-Path -Path $actualItem -IsSymbolicLink)) {
            Write-Host "Removing symlink: $actualItem"
            Remove-Item -Path $actualItem
        } else {
            $backupFile = Join-Path $BACKUP_DIR ((Resolve-Path $actualItem).Path -replace [System.IO.Path]::GetPathRoot($actualItem), "")
            if (Test-Path -Path $backupFile) {
                Write-Host "Restoring backup: $backupFile -> $actualItem"
                Move-Item -Path $backupFile -Destination $actualItem
            }
        }
    }

    # Remove entries from tracker that don't exist anymore
    Get-Content -Path $TRACKER_FILE | ForEach-Object {
        $actualItem = $_.TrimEnd("\")
        if (Test-Path -Path $actualItem -or (Test-Path -Path $actualItem -IsSymbolicLink)) {
            Add-Content -Path $newTrackerFile -Value $_
        }
    }

    Move-Item -Path $newTrackerFile -Destination $TRACKER_FILE
}

# Function to clean untracked symlinks
function Clean-Symlinks {
    Write-Host "Cleaning untracked symlinks..."
    if (Test-Path -Path $TRACKER_FILE) {
        $newTrackerFile = "$TRACKER_FILE.new"
        New-Item -Path $newTrackerFile -ItemType File

        Get-Content -Path $TRACKER_FILE | ForEach-Object {
            $actualItem = $_.TrimEnd("\")
            if (Test-Path -Path $actualItem -IsSymbolicLink) {
                $dotfilePath = Join-Path $SCRIPT_DIR ($actualItem.Substring($HOME.Length))
                if (-not (Test-Path -Path $dotfilePath)) {
                    Write-Host "Removing orphaned symlink: $actualItem"
                    Remove-Item -Path $actualItem
                } else {
                    Add-Content -Path $newTrackerFile -Value $_
                }
            } else {
                Add-Content -Path $newTrackerFile -Value $_
            }
        }

        Move-Item -Path $newTrackerFile -Destination $TRACKER_FILE
    }
}

# Main script execution
param (
    [string]$action
)

switch ($action) {
    'enable' {
        if (Test-Path -Path $ENABLED_FILE) {
            Write-Host "Dotfiles are already enabled. Run 'reinstall' if new files have been added."
        } else {
            Link-Dotfiles
            New-Item -Path $ENABLED_FILE -ItemType File
        }
    }
    'disable' {
        if (Test-Path -Path $ENABLED_FILE) {
            Unlink-Dotfiles
            Remove-Item -Path $ENABLED_FILE
        } else {
            Write-Host "Dotfiles are not enabled."
        }
    }
    'reinstall' {
        if (Test-Path -Path $ENABLED_FILE) {
            Unlink-Dotfiles
            Link-Dotfiles
        } else {
            Write-Host "Dotfiles are not enabled."
        }
    }
    'clean' {
        if (Test-Path -Path $ENABLED_FILE) {
            Clean-Symlinks
        } else {
            Write-Host "Dotfiles are not enabled."
        }
    }
    default {
        Write-Host "Usage: .\script.ps1 {enable|disable|reinstall|clean}"
    }
}
