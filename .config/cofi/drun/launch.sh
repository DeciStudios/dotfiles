#!/usr/bin/env bash

# Get the directory of the script
script_dir=$(dirname "$(readlink -f "$0")")
launcher_type="$1"
rofi \
	-show drun \
	-modi run,drun,ssh \
	-scroll-method 0 \
	-drun-match-fields all \
	-drun-display-format "{name}" \
	-no-drun-show-actions \
	-terminal wezterm \
	-kb-cancel Escape \
	-theme "$script_dir/type-$launcher_type/launcher.rasi"
