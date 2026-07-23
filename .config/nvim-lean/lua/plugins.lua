vim.pack.add({
	"https://github.com/ellisonleao/gruvbox.nvim",
	"https://github.com/nvim-pack/nvim-spectre",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-telescope/telescope-file-browser.nvim",
	"https://github.com/folke/which-key.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-lualine/lualine.nvim",
	"https://github.com/folke/ts-comments.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/kdheepak/lazygit.nvim",
	"https://github.com/romgrk/barbar.nvim",
	"https://github.com/lewis6991/gitsigns.nvim",
	"https://github.com/jiaoshijie/undotree",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/stevearc/conform.nvim",
})

vim.g.nvim_tree_respect_buf_cwd = 1
require("nvim-tree").setup({
	update_cwd = true,
	renderer = {
		root_folder_label = false,
		highlight_git = true,
		indent_markers = { enable = true },
		icons = {
			glyphs = {
				default = "",
				folder = {
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
				},
				git = {
					unmerged = "",
				},
			},
		},
	},
})

vim.g.barbar_auto_setup = false
require("barbar").setup({
	animation = true,
	auto_hide = false,
	tabpages = true,
	closable = true,
	clickable = true,
	sidebar_filetypes = {
		NvimTree = { text = "File Explorer" },
		undotree = { text = "Undo Tree" },
	},
})

require("lualine").setup({
	options = {
		icons_enabled = false,
		component_separators = "",
		section_separators = { left = "", right = "" },
		globalstatus = true,
	},
	sections = {
		lualine_a = {
			{
				"mode",
			},
		},
		lualine_b = {
			"branch",
		},
		lualine_c = {
			"filename",
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				sections = { "error", "warn" },
				symbols = { error = "󰅙 ", warn = " " },
			},
		},
		lualine_y = { "location" },
		lualine_z = { "filetype" },
	},
	tabline = {},
	extensions = {},
	winbar = nil,
})

require("telescope").load_extension("file_browser")
require("ts-comments").setup({})

require("which-key").setup({
	delay = 300,
})

require("spectre").setup({})
