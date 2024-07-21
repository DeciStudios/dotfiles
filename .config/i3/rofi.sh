#!/bin/bash

# Check if the correct number of arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <launcher> <type>"
    exit 1
fi

# Assign arguments to variables
launcher="$1"
type="$2"

# Determine the script file name based on the launcher type
case "$launcher" in
    launcher)
        script_file="launcher.sh"
        ;;
    powermenu)
        script_file="powermenu.sh"
        ;;
    *)
        echo "Invalid launcher: $launcher"
        exit 1
        ;;
esac

# Determine the directory path based on arguments
case "$launcher" in
    launcher)
        script_path="$HOME/.config/rofi/launchers/$type/$script_file"
        ;;
    powermenu)
        script_path="$HOME/.config/rofi/powermenu/$type/$script_file"
        ;;
    *)
        echo "Invalid launcher: $launcher"
        exit 1
        ;;
esac

# Check if the script file exists
if [ ! -f "$script_path" ]; then
    echo "Script not found: $script_path"
    exit 1
fi

# Run the script
cd "$(dirname "$script_path")" && ./"$script_file"
