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

# Ensure the color theme file exists
if [ ! -f "${CONFIG_DIR}/colors/${THEME}.conf" ]; then
    echo "Color theme ${THEME} does not exist in ${CONFIG_DIR}/colors/"
    exit 1
fi

# Update Polybar config
sed -i "s|include-file = \"colors/.*.ini\"|include-file = \"colors/${THEME}.ini\"|" "$POLYBAR_CONFIG"

# Update Neovim config
sed -i "s/theme = '.*'/theme = '${THEME}'/" "$NVIM_CONFIG"

# Get the colors from the theme file
THEME_COLORS=$(grep -E 'client\.focused|client\.unfocused|client\.focused_inactive|client\.urgent' "${CONFIG_DIR}/colors/${THEME}.conf")

# Update i3 config
sed -i "s/set \$colorscheme .*/set \$colorscheme ${THEME}/" "$CONFIG_DIR/config"

# Backup and update color lines in i3 config
for COLOR_TYPE in focused unfocused focused_inactive urgent; do
    sed -i "/client.${COLOR_TYPE}/d" "$CONFIG_DIR/config"
done

echo "$THEME_COLORS" >> "$CONFIG_DIR/config"

# Update WezTerm config
sed -i "s/config.color_scheme = color_schemes\[\".*\"\]/config.color_scheme = color_schemes[\"${THEME}\"]/" "$WEZTERM_CONFIG"

# Reload and restart i3 to apply changes
i3-msg reload
i3-msg restart

echo "Theme changed to ${THEME}, i3 has been restarted, and WezTerm color scheme has been updated"
