#!/bin/bash

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/backup"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

# Function to link dotfiles
link_dotfiles() {
    for file in "$SCRIPT_DIR"/.*; do
        # Skip . and .. directories
        [[ $file == "$SCRIPT_DIR/." || $file == "$SCRIPT_DIR/.." ]] && continue
        
        # Get the basename of the file
        basefile=$(basename "$file")
        
        # Target file in the home directory
        target="$HOME/$basefile"
        
        # If it's a directory, recurse into it
        if [ -d "$file" ]; then
            mkdir -p "$target"
            link_dotfiles "$file"
        else
            # Backup existing file if exists
            if [ -e "$target" ] && [ ! -L "$target" ]; then
                mv "$target" "$BACKUP_DIR/"
            fi
            # Create symlink
            ln -sf "$file" "$target"
        fi
    done
}

# Function to unlink dotfiles
unlink_dotfiles() {
    for file in "$SCRIPT_DIR"/.*; do
        # Skip . and .. directories
        [[ $file == "$SCRIPT_DIR/." || $file == "$SCRIPT_DIR/.." ]] && continue

        # Get the basename of the file
        basefile=$(basename "$file")
        
        # Target file in the home directory
        target="$HOME/$basefile"

        if [ -L "$target" ]; then
            rm "$target"
        fi
        
        # Restore backup if exists
        if [ -e "$BACKUP_DIR/$basefile" ]; then
            mv "$BACKUP_DIR/$basefile" "$target"
        fi
    done
}

# Function to reinstall dotfiles
reinstall_dotfiles() {
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
