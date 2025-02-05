param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("enable","disable","reinstall","clean")]
    [string]$action,

    [string]$configFile
)

# Directory where this script is located
$SCRIPT_DIR = Split-Path -Path $MyInvocation.MyCommand.Definition
$BACKUP_DIR = Join-Path $SCRIPT_DIR "backup"
$TRACKER_FILE = Join-Path $SCRIPT_DIR ".tracker"
$ENABLED_FILE = Join-Path $SCRIPT_DIR ".enabled"

# Ensure backup directory exists
if (-not (Test-Path -Path $BACKUP_DIR)) {
    New-Item -Path $BACKUP_DIR -ItemType Directory | Out-Null
}

# Set user home directory (you might want to change this if you prefer a different location)
$userHome = [Environment]::GetFolderPath("MyDocuments")

# Ensure main user directories exist
$dirsToEnsure = @(
    Join-Path $userHome ".config",
    Join-Path $userHome ".local",
    Join-Path $userHome ".local\bin",
    Join-Path $userHome ".local\share"
)
foreach ($dir in $dirsToEnsure) {
    if (-not (Test-Path -Path $dir)) {
        New-Item -Path $dir -ItemType Directory | Out-Null
    }
}

# List of files and directories to ignore
$IGNORE_LIST = @(".gitignore", "setup.ps1", ".git", "README.md", ".gitattributes", ".tracker", "backup", ".enabled", "config")

function Should-Ignore {
    param([string]$file)
    return ($IGNORE_LIST -contains $file)
}

# Function to link dotfiles from a config file
function Link-DotfilesFromConfig {
    param([string]$configFile)
    Write-Host "Linking dotfiles from config file: $configFile..."

    Get-Content $configFile | ForEach-Object {
        $line = $_.Trim()
        if (-not $line -or $line -match '^\s*#') { return }

        $src = Join-Path $SCRIPT_DIR $line
        Write-Host "line: $line"
        Write-Host "src: $src"
        Write-Host "SCRIPT_DIR: $SCRIPT_DIR"
        $dest = Join-Path $userHome $line

        if (-not (Test-Path -Path $src)) {
            Write-Warning "Warning: $src does not exist, skipping."
            return
        }

        if (Test-Path -Path $dest -and -not (Test-Path -Path $dest -PathType SymbolicLink)) {
            Write-Host "Backing up existing file: $dest"
            Backup-File -file $dest
        }

        $destDir = Split-Path -Path $dest -Parent
        if (-not (Test-Path -Path $destDir)) {
            New-Item -Path $destDir -ItemType Directory | Out-Null
        }

        Write-Host "Creating symlink for $src -> $dest"
        New-Item -Path $dest -ItemType SymbolicLink -Target $src -Force | Out-Null
        Add-Content -Path $TRACKER_FILE -Value $dest
    }
}

# Function to create symlinks for dotfiles recursively
function Link-DotfilesRecursive {
    param(
        [string]$src,
        [string]$dest
    )
    Get-ChildItem -Path $src -Force -Directory -Exclude $IGNORE_LIST | ForEach-Object {
        $item = $_
        $baseitem = $item.Name
        $target = Join-Path $dest $baseitem

        if (Should-Ignore -file $baseitem) {
            return
        }

        if ($item.PSIsContainer) {
            if (-not (Test-Path -Path $target)) {
                Write-Host "Creating symlink for directory $($item.FullName) -> $target"
                New-Item -Path $target -ItemType SymbolicLink -Target $item.FullName -Force | Out-Null
                Add-Content -Path $TRACKER_FILE -Value "$target\"
            } elseif ((Test-Path -Path $target -PathType SymbolicLink) -and -not (Test-Path -Path $target -PathType Container)) {
                Write-Host "Removing invalid symlink for directory $target"
                Remove-Item -Path $target -Force
                Write-Host "Creating symlink for directory $($item.FullName) -> $target"
                New-Item -Path $target -ItemType SymbolicLink -Target $item.FullName -Force | Out-Null
                Add-Content -Path $TRACKER_FILE -Value "$target\"
            } else {
                Link-DotfilesRecursive -src $item.FullName -dest $target
            }
        }
    }

    # Now process files in the current directory
    Get-ChildItem -Path $src -Force -File -Exclude $IGNORE_LIST | ForEach-Object {
        $item = $_
        $target = Join-Path $dest $item.Name

        if (Test-Path -Path $target -and -not (Test-Path -Path $target -PathType SymbolicLink)) {
            Write-Host "Backing up existing file: $target"
            Backup-File -file $target
        }
        if (-not (Test-Path -Path $target -PathType SymbolicLink)) {
            Write-Host "Creating symlink for file $($item.FullName) -> $target"
            New-Item -Path $target -ItemType SymbolicLink -Target $item.FullName -Force | Out-Null
            Add-Content -Path $TRACKER_FILE -Value $target
        }
    }
}

# Function to link all dotfiles
function Link-Dotfiles {
    Write-Host "Linking dotfiles..."
    # Ensure tracker file exists
    if (-not (Test-Path -Path $TRACKER_FILE)) {
        New-Item -Path $TRACKER_FILE -ItemType File | Out-Null
    }

    # Recursively link files from SCRIPT_DIR to user home
    Link-DotfilesRecursive -src $SCRIPT_DIR -dest $userHome

    # Optionally: call Handle-SymlinkedItems if desired (not implemented here)
}

# Function to backup files while preserving directory structure
function Backup-File {
    param([string]$file)
    $relativePath = (Split-Path -Path $file -Parent).Substring($userHome.Length)
    $backupTarget = Join-Path $BACKUP_DIR $relativePath

    if (-not (Test-Path -Path $backupTarget)) {
        New-Item -Path $backupTarget -ItemType Directory -Force | Out-Null
    }
    Move-Item -Path $file -Destination $backupTarget -Force
}

# Function to remove symlinks and restore backup files
function Unlink-Dotfiles {
    Write-Host "Unlinking dotfiles..."
    $newTrackerFile = "$TRACKER_FILE.new"
    New-Item -Path $newTrackerFile -ItemType File -Force | Out-Null

    Get-Content $TRACKER_FILE | ForEach-Object {
        $item = $_.Trim()
        if (Test-Path -Path $item -PathType SymbolicLink) {
            Write-Host "Removing symlink: $item"
            Remove-Item -Path $item -Force
        } else {
            $backupFile = Join-Path $BACKUP_DIR ((Split-Path -Path $item -Parent).Substring($userHome.Length)) (Split-Path -Path $item -Leaf)
            if (Test-Path -Path $backupFile) {
                Write-Host "Restoring backup: $backupFile -> $item"
                $destDir = Split-Path -Path $item -Parent
                if (-not (Test-Path -Path $destDir)) {
                    New-Item -Path $destDir -ItemType Directory -Force | Out-Null
                }
                Move-Item -Path $backupFile -Destination $item -Force
            }
        }
    }

    Get-Content $TRACKER_FILE | ForEach-Object {
        $item = $_.Trim()
        if (Test-Path -Path $item) {
            Add-Content -Path $newTrackerFile -Value $item
        }
    }
    Move-Item -Path $newTrackerFile -Destination $TRACKER_FILE -Force
}

# Function to clean untracked symlinks
function Clean-Symlinks {
    Write-Host "Cleaning untracked symlinks..."
    $newTrackerFile = "$TRACKER_FILE.new"
    New-Item -Path $newTrackerFile -ItemType File -Force | Out-Null

    Get-Content $TRACKER_FILE | ForEach-Object {
        $item = $_.Trim()
        if (Test-Path -Path $item -PathType SymbolicLink) {
            $dotfilePath = Join-Path $SCRIPT_DIR $item.Substring($userHome.Length)
            if (-not (Test-Path -Path $dotfilePath)) {
                Write-Host "Removing orphaned symlink: $item"
                Remove-Item -Path $item -Force
            } else {
                Add-Content -Path $newTrackerFile -Value $item
            }
        } else {
            Add-Content -Path $newTrackerFile -Value $item
        }
    }
    Move-Item -Path $newTrackerFile -Destination $TRACKER_FILE -Force
}

# Function to reinstall dotfiles
function Reinstall-Dotfiles {
    Write-Host "Reinstalling dotfiles..."
    Unlink-Dotfiles
    Link-Dotfiles
}

# Main execution
switch ($action) {
    'enable' {
        if (Test-Path -Path $ENABLED_FILE) {
            Write-Host "Dotfiles are already enabled. Run 'reinstall' if new files have been added."
            exit 1
        } else {
            if ($configFile) {
                Link-DotfilesFromConfig -configFile $configFile
            } else {
                Link-Dotfiles
            }
            New-Item -Path $ENABLED_FILE -ItemType File -Force | Out-Null
        }
    }
    'disable' {
        if (Test-Path -Path $ENABLED_FILE) {
            Unlink-Dotfiles
            Remove-Item -Path $ENABLED_FILE -Force
        } else {
            Write-Host "Dotfiles are already disabled. Run 'enable' to install."
            exit 1
        }
    }
    'reinstall' {
        if (Test-Path -Path $ENABLED_FILE) {
            Reinstall-Dotfiles
        } else {
            Write-Host "Dotfiles are not installed. Run 'enable' to install."
            exit 1
        }
    }
    'clean' {
        if (Test-Path -Path $ENABLED_FILE) {
            Clean-Symlinks
        } else {
            Write-Host "Dotfiles are not installed. Run 'enable' to install."
            exit 1
        }
    }
    default {
        Write-Host "Usage: setup.ps1 {enable|disable|reinstall|clean} [config_file]"
        exit 1
    }
}

Write-Host "Dotfiles $action completed."
