local lsp = vim.lsp

local on_attach = require("configs.lsp").on_attach
local capabilities = require("configs.lsp").capabilities

lsp.config("clangd", {
	on_attach = on_attach,
	capabilities = capabilities,

	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--query-driver=**",
		"--header-insertion=never",
		"--completion-style=detailed",
	},

	root_markers = { "platformio.ini", "compile_commands.json", ".git" },
})

vim.lsp.enable("clangd")
