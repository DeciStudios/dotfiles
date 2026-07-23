local lsp = vim.lsp

local on_attach = require("configs.lsp").on_attach
local capabilities = require("configs.lsp").capabilities

-- define config for pyright
lsp.config("pyright", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "python" },
})

-- define config for ruff
lsp.config("ruff", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "python" },
})

-- enable the servers
lsp.enable("pyright")
lsp.enable("ruff")
