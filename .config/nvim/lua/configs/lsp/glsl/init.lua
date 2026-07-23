local lsp = vim.lsp
local on_attach = require("configs.lsp").on_attach
local capabilities = require("configs.lsp").capabilities
lsp.config("glsl_analyzer", {
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "glsl", "frag", "vert" },
})

-- enable the server
lsp.enable("glsl_analyzer")
