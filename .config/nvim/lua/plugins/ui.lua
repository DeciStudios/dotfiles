local M = {
	{
		"nvim-tree/nvim-web-devicons",
		opts = {},
	},
	{
		"nvim-tree/nvim-tree.lua",
		cmd = { "NvimTreeToggle", "NvimTreeFocus" },
		opts = function()
			return require("configs.ui.nvimtree")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		init = function()
			require("lualine").setup(require("configs.ui.lualine"))
		end,
	},
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = function()
			return require("configs.ui.barbar")
		end,
		-- version = "^1.0.0",
		branch = "master",
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
	},
	{
		"rcarriga/nvim-notify",
		init = function()
			vim.notify = require("notify")
		end,
		config = function()
			require("notify").setup({
				background_colour = "#000000",
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
		opts = require("configs.ui.telescope"),
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		init = function()
			require("telescope").load_extension("file_browser")
		end,
		config = function()
			require("configs.ui.telescope.file_browser")
		end,
	},

	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("dashboard").setup({
				theme = "doom",
				config = require("configs.ui.dashboard"),
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			-- options
		},
	},
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup(require("configs.ui.terminal.opts"))
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("configs.ui.todo-comments")
		end,
	},
	{
		"nvim-neorg/neorg",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		cmd = "Neorg",
		ft = "norg",
		config = function()
			require("configs.ui.neorg")
		end,
	},
	{
		"cshuaimin/ssr.nvim", -- Calling setup is optional.
		config = function()
			require("ssr").setup({
				border = "rounded",
				min_width = 50,
				min_height = 5,
				max_width = 120,
				max_height = 25,
				adjust_window = true,
				keymaps = {
					close = "q",
					next_match = "n",
					prev_match = "N",
					replace_confirm = "<cr>",
					replace_all = "<leader><cr>",
				},
			})
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
	},
}
return M
