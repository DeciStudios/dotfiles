local M = {}
local capabilities = require('cmp_nvim_lsp').default_capabilities()

M.on_attach = function(client, bufnr)
    local function opts(desc)
        return { buffer = bufnr, desc = "LSP " .. desc }
    end

    local keys = {
        n = {
            ["gD"] = { vim.lsp.buf.declaration, "Go to declaration" },
            ["gd"] = { vim.lsp.buf.definition, "Go to definition" },
            ["gi"] = { vim.lsp.buf.implementation, "Go to implementation" },
            ["<leader>sh"] = { vim.lsp.buf.signature_help, "Show signature help" },
            ["<leader>wa"] = { vim.lsp.buf.add_workspace_folder, "Add workspace folder" },
            ["<leader>wr"] = { vim.lsp.buf.remove_workspace_folder, "Remove workspace folder" },
            ["<leader>wl"] = {
                function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end,
                "List workspace folders"
            },
            ["<leader>D"] = { vim.lsp.buf.type_definition, "Go to type definition" },
            ["gr"] = { vim.lsp.buf.references, "Show references" },
        },
        v = {
            ["<leader>ca"] = { vim.lsp.buf.code_action, "Code action" },
        },
    }
    local set_mappings = require("utils.mapper")
    set_mappings({ lsp = keys })
    if client:supports_method("textDocument/formatting") then
        vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
            vim.lsp.buf.format({ async = true })
        end, { desc = "Format current buffer" })
    end
end

M.on_init = function(client, _)
    if client:supports_method("textDocument/semanticTokens") then
        client.server_capabilities.semanticTokensProvider = nil
    end
end

-- Configure LSP handlers
require("configs.lsp.handlers").setup()

M.capabilities = vim.tbl_deep_extend("force", capabilities, {
    textDocument = {
        formatting = {
            dynamicRegistration = true
        }
    }
})
M.capabilities.textDocument.completion.completionItem = {
    documentationFormat = { "markdown", "plaintext" },
    snippetSupport = true,
    preselectSupport = true,
    insertReplaceSupport = true,
    labelDetailsSupport = true,
    deprecatedSupport = true,
    commitCharactersSupport = true,
    tagSupport = { valueSet = { 1 } },
    resolveSupport = {
        properties = {
            "documentation",
            "detail",
            "additionalTextEdits",
        },
    },
}

return M
