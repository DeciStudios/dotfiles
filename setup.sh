#!/bin/bash

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
TRACKER_FILE="$SCRIPT_DIR/.tracker"
ENABLED_FILE="$SCRIPT_DIR/.enabled"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# List of files and directories to ignore
IGNORE_LIST=(".gitignore" "setup.sh" ".git" "README.md" ".gitattributes" ".tracker" "backup" ".enabled")

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
    touch "$TRACKER_FILE"  # Ensure tracker file exists

    # Link dotfiles recursively from SCRIPT_DIR to HOME
    link_dotfiles_recursive "$SCRIPT_DIR" "$HOME"

    # Ensure all previously tracked items are still symlinked
    handle_symlinked_items
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
                echo "$target/" >> "$TRACKER_FILE"  # Track as directory
            elif [ -L "$target" ] && [ ! -d "$target" ]; then
                echo "Removing invalid symlink for directory $target"
                trash "$target"
                echo "Creating symlink for directory $item -> $target"
                ln -sf "$item" "$target"
                echo "$target/" >> "$TRACKER_FILE"  # Track as directory
            else
                link_dotfiles_recursive "$item" "$target"
            fi
        else
            if [ -e "$target" ] && [ ! -L "$target" ]; then
                echo "Backing up existing file: $target"
                backup_file "$target"
            fi
            if [ ! -L "$target" ]; then
                echo "Creating symlink for file $item -> $target"
                ln -sf "$item" "$target"
                echo "$target" >> "$TRACKER_FILE"
            fi
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
    local new_tracker_file="$TRACKER_FILE.new"
    touch "$new_tracker_file"

    # Process tracker file and remove symlinks
    while IFS= read -r item; do
        local actual_item="${item%/}"  # Remove trailing '/' if present

        if [ -d "$actual_item" ] && [ -L "$actual_item" ]; then
            if [ "$(basename "$actual_item")" == "/" ]; then
                # Handle directories
                echo "Removing symlink directory: $actual_item"
                trash "$actual_item"
            else
                # Recursive cleanup for directories
                unlink_dotfiles_recursive "$actual_item"
                echo "Removing symlink directory: $actual_item"
                trash "$actual_item"
            fi
        elif [ -L "$actual_item" ]; then
            echo "Removing symlink: $actual_item"
            trash "$actual_item"
        else
            # Restore backup if available
            local backup_file="$BACKUP_DIR$(dirname "${actual_item#$HOME}")/$(basename "$actual_item")"
            if [ -e "$backup_file" ]; then
                echo "Restoring backup: $backup_file -> $actual_item"
                mkdir -p "$(dirname "$actual_item")"
                mv "$backup_file" "$actual_item"
            fi
        fi
    done < "$TRACKER_FILE"

    # Remove entries from tracker that don't exist anymore
    while IFS= read -r item; do
        local actual_item="${item%/}"  # Remove trailing '/' if present

        if [ -e "$actual_item" ] || [ -L "$actual_item" ]; then
            echo "$item" >> "$new_tracker_file"
        fi
    done < "$TRACKER_FILE"

    mv "$new_tracker_file" "$TRACKER_FILE"
}

# Recursive function to handle files and directories for unlinking
unlink_dotfiles_recursive() {
    local dest="$1"

    find "$dest" -mindepth 1 -maxdepth 1 | while IFS= read -r item; do
        local actual_item="${item%/}"  # Remove trailing '/' if present

        if [ -L "$actual_item" ] && [ -d "$actual_item" ]; then
            # Check if item is a symlink to a directory
            if [ "$(basename "$actual_item")" == "/" ]; then
                echo "Removing symlink directory: $actual_item"
                trash "$actual_item"
            else
                unlink_dotfiles_recursive "$actual_item"
                echo "Removing symlink directory: $actual_item"
                trash "$actual_item"
            fi
        elif [ -L "$actual_item" ]; then
            echo "Removing symlink: $actual_item"
            trash "$actual_item"
        fi
    done
}

# Function to handle symlinked items specifically
handle_symlinked_items() {
    if [ -f "$TRACKER_FILE" ]; then
        while IFS= read -r item; do
            local actual_item="${item%/}"  # Remove trailing '/' if present

            if [ -d "$actual_item" ] && [ -L "$actual_item" ]; then
                continue  # Skip directories, they are handled separately
            fi

            if [ -L "$actual_item" ] && [ ! -e "$actual_item" ]; then
                echo "Removing broken symlink: $actual_item"
                trash "$actual_item"
            fi
        done < "$TRACKER_FILE"
    fi
}

# Function to clean untracked symlinks
clean_symlinks() {
    echo "Cleaning untracked symlinks..."
    if [ -f "$TRACKER_FILE" ]; then
        local new_tracker_file="$TRACKER_FILE.new"
        touch "$new_tracker_file"

        while IFS= read -r item; do
            local actual_item="${item%/}"  # Remove trailing '/' if present

            if [ -L "$actual_item" ]; then
                local dotfile_path="$SCRIPT_DIR${actual_item#$HOME}"
                if [ ! -e "$dotfile_path" ]; then
                    echo "Removing orphaned symlink: $actual_item"
                    trash "$actual_item"
                else
                    echo "$item" >> "$new_tracker_file"
                fi
            else
                echo "$item" >> "$new_tracker_file"
            fi
        done < "$TRACKER_FILE"

        mv "$new_tracker_file" "$TRACKER_FILE"
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
    echo "Usage: $0 {enable|disable|reinstall|clean}"
    exit 1
}

# Main script execution
case "$1" in
    enable)
        if [ -f "$ENABLED_FILE" ]; then
            echo "Dotfiles are already enabled. Run 'reinstall' if new files have been added."
            exit 1
        else
            link_dotfiles
            touch "$ENABLED_FILE"
        fi
        ;;
    disable)
        if [ -f "$ENABLED_FILE" ]; then
            unlink_dotfiles
            rm -f "$ENABLED_FILE"
        else
            echo "Dotfiles are already disabled. Run 'reinstall' if you need to reset."
            exit 1
        fi
        ;;
    reinstall)
        reinstall_dotfiles
        ;;
    clean)
        clean_symlinks
        ;;
    *)
        usage
        ;;
esac

echo "Dotfiles $1 completed."

