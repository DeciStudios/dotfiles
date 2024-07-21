#!/bin/bash

# Define the script directory (adjust this if needed)
script_dir="$(dirname "$(realpath "$0")")"

# Define available menu types and their corresponding scripts
declare -A menu_scripts=(
    ["powermenu"]="$script_dir/powermenu/powermenu.sh"
    ["drun"]="$script_dir/drun/launch.sh"
)

# Function to check if the color scheme is different
is_color_scheme_changed() {
    local colorscheme=$1
    local using_dir="$script_dir/styling/.using"
    
    # Ensure the using directory exists
    mkdir -p "$using_dir"

    # Check if the color scheme directory exists
    if [ ! -d "$script_dir/styling/$colorscheme" ]; then
        echo "Color scheme '$colorscheme' does not exist."
        exit 1
    fi

    # Compare current symlinks with the desired color scheme
    for file in "$script_dir/styling/$colorscheme"/*; do
        local filename=$(basename "$file")
        local current_target
        local new_target=$(realpath "$file")

        if [ -L "$using_dir/$filename" ]; then
            current_target=$(realpath "$(readlink "$using_dir/$filename")")
        else
            current_target=""
        fi

        if [ "$current_target" != "$new_target" ]; then
            return 0
        fi
    done

    return 1
}

# Function to update the color scheme
update_color_scheme() {
    local colorscheme=$1
    local using_dir="$script_dir/styling/.using"
    
    # Ensure the using directory exists
    mkdir -p "$using_dir"

    # Check if the color scheme directory exists
    if [ ! -d "$script_dir/styling/$colorscheme" ]; then
        echo "Color scheme '$colorscheme' does not exist."
        exit 1
    fi

    # Remove old symlinks
    rm -f "$using_dir"/*

    # Create new symlinks
    for file in "$script_dir/styling/$colorscheme"/*; do
        ln -s "$file" "$using_dir/$(basename "$file")"
    done
}

# Function to display usage
usage() {
    echo "Usage: $0 <menu_type> <menu_option> <colorscheme>"
    echo "  menu_type    Type of menu (e.g., 'powermenu' or 'drun')"
    echo "  menu_option  Menu option (e.g., '1', '2', '3', etc.)"
    echo "  colorscheme  Color scheme directory (must be a subdirectory of 'styling')"
    exit 1
}

# Check if sufficient arguments are provided
if [ "$#" -ne 3 ]; then
    usage
fi

# Parse arguments
menu_type=$1
menu_option=$2
colorscheme=$3

# Validate menu_type
if [[ -z "${menu_scripts[$menu_type]}" ]]; then
    echo "Invalid menu type: $menu_type"
    echo "Available menu types: ${!menu_scripts[@]}"
    exit 1
fi

# Update color scheme only if needed
if is_color_scheme_changed "$colorscheme"; then
    echo "Color scheme has changed. Updating..."
    update_color_scheme "$colorscheme"
else
    echo "Color scheme is already up-to-date."
fi

# Invoke the menu script with the given option
"${menu_scripts[$menu_type]}" "$menu_option"
