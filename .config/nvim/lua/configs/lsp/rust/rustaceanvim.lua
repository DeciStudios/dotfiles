local on_attach = require("configs.lsp").on_attach
local capabilities = require("configs.lsp").capabilities

vim.g.rustaceanvim = {
    server = {
        on_attach = on_attach,
        capabilities = capabilities,
    }
}
