#!/bin/bash

# Usage: ./change_theme.sh <theme_name>
# Example: ./change_theme.sh catppuccin

if [ -z "$1" ]; then
    echo "Usage: $0 <theme_name>"
    exit 1
fi

THEME=$1
CONFIG_DIR="$HOME/.config/i3"
POLYBAR_CONFIG="$HOME/.config/polybar/config.ini"
NVIM_CONFIG="$HOME/.config/nvim/lua/custom/chadrc.lua"
WEZTERM_CONFIG="$HOME/.config/wezterm/wezterm.lua"
WEZTERM_COLOR_SCHEMES="$HOME/.config/wezterm/colors.lua"

# Ensure the color theme file exists
if [ ! -f "${CONFIG_DIR}/colors/${THEME}.conf" ]; then
    echo "Color theme ${THEME} does not exist in ${CONFIG_DIR}/colors/"
    exit 1
fi

# Update Polybar config
sed -i "s|include-file = \"colors/.*.ini\"|include-file = \"colors/${THEME}.ini\"|" "$POLYBAR_CONFIG"
echo "Updated Polybar config to use ${THEME}"

# Update Neovim config
sed -i "s/theme = '.*'/theme = '${THEME}'/" "$NVIM_CONFIG"
echo "Updated Neovim config to use ${THEME}"

# Get the colors from the theme file
THEME_COLORS=$(grep -E 'client\.focused|client\.unfocused|client\.focused_inactive|client\.urgent' "${CONFIG_DIR}/colors/${THEME}.conf")

# Update i3 config
sed -i "s/set \$colorscheme .*/set \$colorscheme ${THEME}/" "$CONFIG_DIR/config"

# Remove existing color lines and append the new ones
for COLOR_TYPE in focused unfocused focused_inactive urgent; do
    sed -i "/client.${COLOR_TYPE}/d" "$CONFIG_DIR/config"
done

echo "$THEME_COLORS" >> "$CONFIG_DIR/config"
echo "Updated i3 config with colors from ${THEME}"

# Ensure WezTerm color schemes file is sourced correctly
if ! grep -q "local color_schemes = require 'color_schemes'" "$WEZTERM_CONFIG"; then
    sed -i "/local wezterm = require 'wezterm'/a local color_schemes = require 'color_schemes'" "$WEZTERM_CONFIG"
fi

# Update WezTerm config
if grep -q "config.color_scheme = color_schemes\[\".*\"\]" "$WEZTERM_CONFIG"; then
    sed -i "s/config.color_scheme = color_schemes\[\".*\"\]/config.color_scheme = color_schemes[\"${THEME}\"]/" "$WEZTERM_CONFIG"
else
    sed -i "/local config = wezterm.config_builder()/a config.color_scheme = color_schemes[\"${THEME}\"]" "$WEZTERM_CONFIG"
fi

echo "Updated WezTerm config to use ${THEME}"

# Reload and restart i3 to apply changes
i3-msg reload
i3-msg restart

echo "Theme changed to ${THEME}, i3 has been restarted, and WezTerm color scheme has been updated"
