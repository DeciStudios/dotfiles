#!/bin/bash

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# List of files and directories to ignore
IGNORE_LIST=(".gitignore" "setup.sh" ".git" "README.md" ".gitattributes")

# List of directories to treat specially (symlink directories only)
SPECIAL_DIRS=("nvim")  # Add directories here that should be treated as directories

# Function to check if a file or directory should be ignored
should_ignore() {
    local item="$1"
    for ignore in "${IGNORE_LIST[@]}"; do
        if [[ "$item" == *"$ignore"* ]]; then
            return 0
        fi
    done
    return 1
}

# Function to check if a path is a special directory
is_special_dir() {
    local dir="$1"
    for special in "${SPECIAL_DIRS[@]}"; do
        if [[ "$dir" == *"$special"* ]]; then
            return 0
        fi
    done
    return 1
}

# Function to create symlinks for dotfiles
link_dotfiles() {
    echo "Linking dotfiles..."
    find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 | while read -r item; do
        local baseitem=$(basename "$item")
        local target="$HOME/$baseitem"

        if should_ignore "$baseitem"; then
            continue
        fi

        if [ -d "$item" ]; then
            # If it's a directory and should be treated as such, symlink the directory
            if is_special_dir "$baseitem"; then
                mkdir -p "$target"
                link_dotfiles_recursive "$item" "$target"
            else
                # Handle normal directories
                mkdir -p "$target"
                # Recurse into the directory
                link_dotfiles_recursive "$item" "$target"
            fi
        else
            # Handle files
            if [ -e "$target" ] && [ ! -L "$target" ]; then
                # Backup existing file
                echo "Backing up existing file: $target"
                mv "$target" "$BACKUP_DIR/"
            fi
            # Create symlink
            echo "Creating symlink for $item -> $target"
            ln -sf "$item" "$target"
        fi
    done
}

# Recursive function to handle files and directories
link_dotfiles_recursive() {
    local src="$1"
    local dest="$2"

    find "$src" -mindepth 1 -maxdepth 1 | while read -r item; do
        local baseitem=$(basename "$item")
        local target="$dest/$baseitem"

        if should_ignore "$baseitem"; then
            continue
        fi

        if [ -d "$item" ]; then
            mkdir -p "$target"
            link_dotfiles_recursive "$item" "$target"
        else
            if [ -e "$target" ] && [ ! -L "$target" ]; then
                echo "Backing up existing file: $target"
                mv "$target" "$BACKUP_DIR/"
            fi
            echo "Creating symlink for $item -> $target"
            ln -sf "$item" "$target"
        fi
    done
}

# Function to remove symlinks and restore backup files
unlink_dotfiles() {
    echo "Unlinking dotfiles..."
    find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 | while read -r item; do
        local baseitem=$(basename "$item")
        local target="$HOME/$baseitem"

        if should_ignore "$baseitem"; then
            continue
        fi

        if [ -d "$item" ]; then
            if [ -d "$target" ]; then
                unlink_dotfiles_recursive "$item" "$target"
            fi
        else
            if [ -L "$target" ]; then
                echo "Removing symlink: $target"
                trash "$target"
            fi

            if [ -e "$BACKUP_DIR/$baseitem" ]; then
                echo "Restoring backup: $BACKUP_DIR/$baseitem -> $target"
                mv "$BACKUP_DIR/$baseitem" "$target"
            fi
        fi
    done
}

# Recursive function to handle files and directories for unlinking
unlink_dotfiles_recursive() {
    local src="$1"
    local dest="$2"

    find "$src" -mindepth 1 -maxdepth 1 | while read -r item; do
        local baseitem=$(basename "$item")
        local target="$dest/$baseitem"

        if should_ignore "$baseitem"; then
            continue
        fi

        if [ -d "$item" ]; then
            if [ -d "$target" ]; then
                unlink_dotfiles_recursive "$item" "$target"
            fi
        else
            if [ -L "$target" ]; then
                echo "Removing symlink: $target"
                trash "$target"
            fi

            if [ -e "$BACKUP_DIR/$baseitem" ]; then
                echo "Restoring backup: $BACKUP_DIR/$baseitem -> $target"
                mv "$BACKUP_DIR/$baseitem" "$target"
            fi
        fi
    done
}

# Function to reinstall dotfiles
reinstall_dotfiles() {
    echo "Reinstalling dotfiles..."
    unlink_dotfiles
    link_dotfiles
}

# Function to display usage
usage() {
    echo "Usage: $0 {enable|disable|reinstall}"
    exit 1
}

# Main script execution
case "$1" in
    enable)
        link_dotfiles
        ;;
    disable)
        unlink_dotfiles
        ;;
    reinstall)
        reinstall_dotfiles
        ;;
    *)
        usage
        ;;
esac

echo "Dotfiles $1 completed."

