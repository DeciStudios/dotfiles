#!/usr/bin/env bash

# Exit if not running in tmux
[ -z "$TMUX" ] && exit 0

# Get the current script directory
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default settings
default_theme="catppuccin"
default_left_sep=""
default_right_sep=""
default_session_icon=""
default_weather_location="Swindon"

# Fetch user-defined options or use defaults
theme=$(tmux show-option -gqv "@custom-bar-theme" || echo "$default_theme")
left_sep=$(tmux show-option -gqv "@custom-bar-left-sep" || echo "$default_left_sep")
right_sep=$(tmux show-option -gqv "@custom-bar-right-sep" || echo "$default_right_sep")
session_icon=$(tmux show-option -gqv "@custom-bar-session-icon" || echo "$default_session_icon")
weather_location=$(tmux show-option -gqv "@custom-bar-weather-location" || echo "$default_weather_location")

# Apply Catppuccin Mocha colors
if [ "$theme" = "catppuccin" ]; then
    base_bg="#1E1E2E"
    base_fg="#CDD6F4"
    highlight_bg="#F5E0DC"
    highlight_fg="#1E1E2E"
else
    # Fallback theme
    base_bg="#000000"
    base_fg="#FFFFFF"
    highlight_bg="#FF5555"
    highlight_fg="#000000"
fi

# Enable status bar and set refresh interval
tmux set -g status on
tmux set -g status-interval 5
tmux set -g status-justify centre

# Set global status style
tmux set -g status-style "bg=${base_bg},fg=${base_fg}"

# Left status: Session with icon and separator
tmux set -g status-left-length 40
tmux set -g status-left "#[bg=${highlight_bg},fg=${highlight_fg},bold] ${session_icon} #S #[bg=${base_bg},fg=${highlight_bg}]${left_sep} "

# Right status: Weather and time with separators
tmux set -g status-right-length 60
tmux set -g status-right "#[bg=${base_bg},fg=${highlight_bg}]${right_sep}#[bg=${highlight_bg},fg=${highlight_fg}] #(curl -s wttr.in/${weather_location}?format='%c+%t') #[bg=${base_bg},fg=${highlight_bg}]${right_sep}#[bg=${highlight_bg},fg=${highlight_fg}] %H:%M %d-%b-%y "

# Window list styling
tmux set -g window-status-format "#[fg=${base_fg},bg=${base_bg}] #I #W "
tmux set -g window-status-current-format "#[fg=${highlight_fg},bg=${highlight_bg},bold] #I #W #[fg=${highlight_bg},bg=${base_bg}]${left_sep}"

# Ensure UTF-8 support
tmux set -g status-utf8 on
