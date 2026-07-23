local seperatorTypes = {
	default = {
		section = { left = "", right = "" },
		component = { left = "", right = "" },
	},
	slant = {
		section = { left = "", right = "" },
		component = { left = "", right = "" },
	},
	arrow = {
		section = { left = "", right = "" },
		component = { left = "", right = "" },
	},
	curve = {
		section = { left = "", right = "" },
		component = { left = "", right = "" },
	},
	none = {
		section = { left = "", right = "" },
		component = { left = "", right = "" },
	},
	space = {
		section = { left = " ", right = " " },
		component = { left = " ", right = " " },
	},
}

local M = {
	options = {
		icons_enabled = false,
		component_separators = seperatorTypes.none.component,
		section_separators = seperatorTypes.slant.section,
		globalstatus = true, -- Add this line
	},
	sections = {
		lualine_a = {
			{
				"mode",
				-- fmt = function(str)
				--     if str == "NORMAL" then
				--         return ' ' .. str
				--     elseif str == "INSERT" then
				--         return ' ' .. str
				--     elseif str == "VISUAL" then
				--         return '󰈈 ' .. str
				--     elseif str == "V-LINE" then
				--         return ' ' .. str
				--     end
				-- end
			}, -- Add icon before the mode text
		},
		lualine_b = {
			"branch",
		},
		lualine_c = {
			"filename",
			{
				"diagnostics",
				sources = { "nvim_diagnostic" }, -- Use nvim_lsp to get diagnostics from LSP
				sections = { "error", "warn" }, -- Show only errors and warnings
				symbols = { error = "󰅙 ", warn = " " }, -- Customize symbols
			},
			--function()
			--    return vim.fn['nvim_treesitter#statusline'](180)
			--end
		},
		lualine_x = {
			"copilot",
		},
		lualine_y = { "location" },
		lualine_z = { "filetype" },
	},
	tabline = {},
	extensions = {},
	winbar = nil,
}

return M
