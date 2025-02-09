-- Pull il n the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action
local color_schemes = require 'colors'


-- This will hold the configuration.
local config = wezterm.config_builder()
config.color_scheme = "OneDark (base16)"
-- config.win32_system_backdrop = 'Acrylic'
-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.font = wezterm.font "DroidSansM Nerd Font Mono"
config.font = wezterm.font("FiraCode Nerd Font", {weight="Bold"})
config.font_size = 13.0
config.default_prog = { "powershell.exe" }
config.front_end = "OpenGL"
-- config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_decorations = "NONE | RESIZE"
config.automatically_reload_config = true
config.max_fps = 144
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.cell_width = 0.9
-- config.window_background_opacity = 0.9
config.prefer_egl = true
-- config.font_size = 18.0
config.term = "xterm-256color" -- Set the terminal type

config.window_padding = {
	left = 6,
	right = 6,
	top = 4,
	bottom = 4,
}

config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
-- config.tab_bar_at_bottom = true

-- config.inactive_pane_hsb = {
-- 	saturation = 0.0,
-- 	brightness = 1.0,
-- }

-- This is where you actually apply your config choices
--

-- color scheme toggling
-- wezterm.on("toggle-colorscheme", function(window, pane)
-- 	local overrides = window:get_config_overrides() or {}
-- 	if overrides.color_scheme == color_schemes["everforest"] then
-- 		overrides.color_scheme = color_schemes["catpuccin"]
-- 	else
-- 		overrides.color_scheme = color_schemes["everforest"]
-- 	end
-- 	window:set_config_overrides(overrides)
-- end)

-- keymaps
config.keys = {
	{
		key = "RightArrow",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	{
		key = "DownArrow",
		mods = "CTRL|SHIFT|ALT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	{
		key = "U",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "I",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "O",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "P",
		mods = "CTRL|SHIFT",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{ key = "9", mods = "CTRL", action = act.PaneSelect },
	{ key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
	{
		key = "O",
		mods = "CTRL|ALT",
		-- toggling opacity
		action = wezterm.action_callback(function(window, _)
			local overrides = window:get_config_overrides() or {}
			if overrides.window_background_opacity == 1.0 then
				overrides.window_background_opacity = 0.9
			else
				overrides.window_background_opacity = 1.0
			end
			window:set_config_overrides(overrides)
		end),
	},
}

-- For example, changing the color scheme:
config.window_close_confirmation = "NeverPrompt"
config.colors = {
	-- background = '#3b224c',
	-- background = "#181616", -- vague.nvim bg
	-- background = "#080808", -- almost black
	background = "#0c0b0f", -- dark purple
	-- background = "#020202", -- dark purple
	-- background = "#17151c", -- brighter purple
	-- background = "#16141a",
	-- background = "#0e0e12", -- bright washed lavendar
	-- background = 'rgba(59, 34, 76, 100%)',
	cursor_border = "#bea3c7",
	-- cursor_fg = "#281733",
	cursor_bg = "#bea3c7",
	-- selection_fg = '#281733',

	tab_bar = {
		background = "#0c0b0f",
		-- background = "rgba(0, 0, 0, 0%)",
		active_tab = {
			bg_color = "#0c0b0f",
			fg_color = "#bea3c7",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},
		inactive_tab = {
			bg_color = "#0c0b0f",
			fg_color = "#f8f2f5",
			intensity = "Normal",
			underline = "None",
			italic = false,
			strikethrough = false,
		},

		new_tab = {
			-- bg_color = "rgba(59, 34, 76, 50%)",
			bg_color = "#0c0b0f",
			fg_color = "white",
		},
	},
}

config.window_frame = {
	font = wezterm.font({ family = "Iosevka Custom", weight = "Regular" }),
	active_titlebar_bg = "#0c0b0f",
	-- active_titlebar_bg = "#181616",
}

config.initial_cols = 80
-- and finally, return the configuration to wezterm
return config
