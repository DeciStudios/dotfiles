local lsp = vim.lsp
local on_attach = require("configs.lsp").on_attach
local capabilities = require("configs.lsp").capabilities
local on_init = require("configs.lsp").on_init
local playdate_sdk_path = os.getenv("PLAYDATE_SDK_PATH")
local playdate_luacats_path = os.getenv("PLAYDATE_LUACATS_PATH")
lsp.config("lua_ls", {
	on_attach = on_attach,
	capabilities = capabilities,
	on_init = on_init,

	settings = {
		Lua = {
			runtime = {
				nonstandardSymbol = { "+=", "-=", "*=", "/=", "//=", "%=", "<<=", ">>=", "&=", "|=", "^=" },
			},
			diagnostics = {
				globals = { "vim", "import" },
			},
			workspace = {
				library = {
					vim.fn.expand("$VIMRUNTIME/lua"),
					vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
					vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
					"${3rd}/luv/library",
					"${3rd}/love2d/library",
					-- (playdate_sdk_path and (playdate_sdk_path .. "/CoreLibs")) or nil,
					(playdate_luacats_path and playdate_luacats_path) or nil,
				},
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
		},
	},
})

lsp.enable("lua_ls")
