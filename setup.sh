#!/bin/bash

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
SYMLINK_FILE="$SCRIPT_DIR/.foldertracker"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# List of files and directories to ignore
IGNORE_LIST=(".gitignore" "setup.sh" ".git" "README.md" ".gitattributes" ".foldertracker" "backup")

# Function to check if a file or directory should be ignored
should_ignore() {
    local file="$1"
    for ignore in "${IGNORE_LIST[@]}"; do
        if [[ "$file" == "$ignore" ]]; then
            return 0
        fi
    done
    return 1
}

# Function to create symlinks for dotfiles
link_dotfiles() {
    echo "Linking dotfiles..."
    > "$SYMLINK_FILE"  # Clear previous symlink list

    # Link dotfiles recursively from SCRIPT_DIR to HOME
    link_dotfiles_recursive "$SCRIPT_DIR" "$HOME"

    # Ensure all previously tracked directories are still symlinked
    if [ -f "$SYMLINK_FILE" ]; then
        while IFS= read -r dir; do
            if [ -d "$dir" ] && [ ! -L "$dir" ]; then
                echo "Re-creating missing symlink for directory $dir"
                ln -sf "$SCRIPT_DIR${dir#$HOME}" "$dir"
            fi
        done < "$SYMLINK_FILE"
    fi
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
            if [ ! -e "$target" ]; then
                echo "Creating symlink for directory $item -> $target"
                ln -sf "$item" "$target"
                echo "$target" >> "$SYMLINK_FILE"
            elif [ -L "$target" ]; then
                continue
            else
                link_dotfiles_recursive "$item" "$target"
            fi
        else {
            if [ -e "$target" ] && [ ! -L "$target" ]; then
                echo "Backing up existing file: $target"
                backup_file "$target"
            fi
            echo "Creating symlink for file $item -> $target"
            ln -sf "$item" "$target"
        }
        fi
    done
}

# Function to backup files while preserving directory structure
backup_file() {
    local file="$1"
    local backup_target="$BACKUP_DIR$(dirname "${file#$HOME}")"

    mkdir -p "$backup_target"
    mv "$file" "$backup_target/"
}

# Function to remove symlinks and restore backup files
unlink_dotfiles() {
    echo "Unlinking dotfiles..."
    handle_symlinked_directories
    unlink_dotfiles_recursive "$SCRIPT_DIR" "$HOME"
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

            local backup_file="$BACKUP_DIR$(dirname "${target#$HOME}")/$baseitem"
            if [ -e "$backup_file" ]; then
                echo "Restoring backup: $backup_file -> $target"
                mkdir -p "$(dirname "$target")"
                mv "$backup_file" "$target"
            fi
        fi
    done
}

# Function to handle symlinked directories specifically
handle_symlinked_directories() {
    if [ -f "$SYMLINK_FILE" ]; then
        while IFS= read -r dir; do
            if [ -d "$dir" ] && [ -L "$dir" ]; then
                echo "Removing symlinked directory: $dir"
                trash "$dir"
            fi
        done < "$SYMLINK_FILE"
    fi
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
