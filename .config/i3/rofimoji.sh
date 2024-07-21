#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <theme>"
  exit 1
fi

# Define the path to the theme file
THEME_PATH="$HOME/.config/rofi/themes/$1.rasi"

# Check if the theme file exists
if [ ! -f "$THEME_PATH" ]; then
  echo "Theme file '$THEME_PATH' does not exist."
  exit 1
fi

# Run rofimoji with the specified theme
rofimoji --selector-args="-theme $THEME_PATH"

