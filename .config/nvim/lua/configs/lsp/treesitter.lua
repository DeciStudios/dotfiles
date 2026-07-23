local M = {
    highlight = {
        enable = true,
        use_languagetree = true,
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    -- Enable better text objects
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
            },
        },
    },
    -- Enable auto-folding
    fold = {
        enable = true,
    },
    -- Enable better incremental selection
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            node_decremental = "<BS>",
            scope_incremental = "<TAB>",
        },
    },
}

return M
