#!/bin/bash

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"
TRACKER_FILE="$SCRIPT_DIR/.tracker"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# List of files and directories to ignore
IGNORE_LIST=(".gitignore" "setup.sh" ".git" "README.md" ".gitattributes" ".tracker" "backup")

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
    unlink_dotfiles_recursive "$HOME"
}

# Recursive function to handle files and directories for unlinking
unlink_dotfiles_recursive() {
    local dest="$1"

    while IFS= read -r item; do
        if [ -d "$item" ] && [ -L "$item" ]; then
            if [ -d "$item" ]; then
                # Handle directories
                while IFS= read -r sub_item; do
                    unlink_dotfiles_recursive "$sub_item"
                done < <(find "$item" -mindepth 1 -maxdepth 1)
            fi
            echo "Removing symlink directory: $item"
            trash "$item"
        elif [ -L "$item" ]; then
            echo "Removing symlink: $item"
            trash "$item"
        else
            # Restore backup if available
            local backup_file="$BACKUP_DIR$(dirname "${item#$HOME}")/$(basename "$item")"
            if [ -e "$backup_file" ]; then
                echo "Restoring backup: $backup_file -> $item"
                mkdir -p "$(dirname "$item")"
                mv "$backup_file" "$item"
            fi
        fi
    done < "$TRACKER_FILE"

    # Remove entries from tracker that don't exist anymore
    local new_tracker_file="$TRACKER_FILE.new"
    touch "$new_tracker_file"

    while IFS= read -r item; do
        if [ -e "$item" ] || [ -L "$item" ]; then
            echo "$item" >> "$new_tracker_file"
        fi
    done < "$TRACKER_FILE"

    mv "$new_tracker_file" "$TRACKER_FILE"
}

# Function to handle symlinked items specifically
handle_symlinked_items() {
    if [ -f "$TRACKER_FILE" ]; then
        while IFS= read -r item; do
            if [ -d "$item" ] && [ -L "$item" ]; then
                continue  # Skip directories, they are handled separately
            fi

            if [ -L "$item" ] && [ ! -e "$item" ]; then
                echo "Removing broken symlink: $item"
                trash "$item"
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
            if [ -L "$item" ]; then
                local dotfile_path="$SCRIPT_DIR${item#$HOME}"
                if [ ! -e "$dotfile_path" ]; then
                    echo "Removing orphaned symlink: $item"
                    trash "$item"
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
        handle_symlinked_items  # Remove broken symlinks before adding new ones
        link_dotfiles
        ;;
    disable)
        unlink_dotfiles
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
