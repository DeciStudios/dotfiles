local lsp = vim.lsp

local on_attach = require("configs.lsp").on_attach
local capabilities = require("configs.lsp").capabilities

lsp.config("ols", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "odin" }, -- adjust this to the filetypes that OLS should handle
})

lsp.enable("ols")
