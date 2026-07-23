local M = {
    {
        "mrcjkb/rustaceanvim",
        ft = { "rust" },
        dependencies = "neovim/nvim-lspconfig",
        config = function()
            require "configs.lsp.rust.rustaceanvim"
        end
    },
    {
        'saecki/crates.nvim',
        ft = { "toml" },
        config = function(_, opts)
            local crates = require('crates')
            crates.setup(opts)
            require('cmp').setup.buffer({
                sources = { { name = "crates" } }
            })
            crates.show()
        end,
    },
}

return M
