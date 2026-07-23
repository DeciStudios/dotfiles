local M = {

	{ "folke/tokyonight.nvim", lazy = true },
	{
		"sainnhe/sonokai",
		lazy = true,
		config = function()
			vim.g.sonokai_style = "andromeda"
			vim.g.sonokai_enable_italic = 1
		end,
	},
	{ "catppuccin/nvim", lazy = true },
	{ "ellisonleao/gruvbox.nvim", lazy = true },
	{ "olimorris/onedarkpro.nvim", lazy = true },
	{ "xiantang/darcula-dark.nvim", lazy = true },
}


return M
