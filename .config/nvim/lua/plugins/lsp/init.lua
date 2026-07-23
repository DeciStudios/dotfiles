local M = {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = { "Mason", "MasonInstall", "MasonUpdate" },
		event = "BufReadPre",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = require("configs.lsp.mason").ensure_installed,
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("configs.lsp")
			require("configs.lsp.languages")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
		opts = function()
			return require("configs.lsp.treesitter")
		end,
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	{
		"henriklovhaug/Preview.nvim",
		cmd = { "Preview" },
		config = function()
			require("preview").setup()
		end,
	},
}

local merge = require("utils.merge")
local lua = require("plugins.lsp.lua")
local python = require("plugins.lsp.python")
local rust = require("plugins.lsp.rust")
local odin = require("plugins.lsp.odin")
return merge(M, lua, python, rust, odin)
