local M = {
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			filetypes = { "*" },
			user_default_options = {
				RGB = true,
				RGBA = true,
				RRGGBB = true,
				names = true,
				names_opts = {
					uppercase = true,
				},
				RRGGBBAA = true,
				rgb_fn = true,
				hsl_fn = true,
				css = true,
				css_fn = true,
				mode = "background",
				tailwind = true,
				sass = { enable = true, parsers = { "css" } },
				virtualtext = "■",
			},
			buftypes = {},
		},
	},
	-- TypeScript/React
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	{
		"windwp/nvim-ts-autotag",
		ft = {
			"html",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
			"svelte",
			"vue",
			"tsx",
			"jsx",
			"rescript",
			"xml",
			"php",
			"markdown",
			"astro",
			"glimmer",
			"handlebars",
			"hbs",
		},
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable = true,
					enable_rename = true,
					enable_close = true,
					enable_close_on_slash = true,
				},
			})
		end,
	},
	-- Tailwind
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})
		end,
	},
}

return M
