#!/bin/bash

THEMES_DIR="$(dirname "$0")/themes"
STARSHIP_CONFIG="starship.toml"

# List available themes
echo "Available themes:"
themes=("$THEMES_DIR"/*.toml)
for i in "${!themes[@]}"; do
    theme_name=$(basename "${themes[$i]}")
    echo "$((i + 1))) $theme_name"
done

# Get user selection
read -p "Select a theme by number: " choice

# Validate input
if [[ "$choice" -ge 1 && "$choice" -le "${#themes[@]}" ]]; then
    selected_theme="${themes[$((choice - 1))]}"
    ln -sf "$selected_theme" "$STARSHIP_CONFIG"
    echo "Switched to theme: $(basename "$selected_theme")"
    exec zsh
else
    echo "Invalid selection."
    exit 1
fi
