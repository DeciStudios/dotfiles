-- Pull il n the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()
local color_schemes = require("colors")
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.font = wezterm.font 'MesloLGS Nerd Font'
--config.font = wezterm.font 'NotoSans Nerd Font'
--config.color_scheme = 'Catppuccin Mocha (Gogh)'
--config.color_scheme = 'Everforest Dark (Gogh)'
config.color_scheme = 'Nord (Gogh)'
config.window_decorations = "TITLE | RESIZE"

-- and finally, return the configuration to wezterm
return config
