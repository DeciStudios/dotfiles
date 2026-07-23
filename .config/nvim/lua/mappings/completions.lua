local M = {}

M.completion = {
    n = {
        ["<leader>cc"] = {
            function()
                if cmp.visible() then
                    cmp.close()
                else
                    cmp.complete()
                end
            end,
            "Toggle completion menu"
        },
    },
    i = {
        ["<Tab>"] = {
            function()
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
                end
            end,
            "Next completion or indent"
        },
        ["<S-Tab>"] = {
            function()
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true), "n", true)
                end
            end,
            "Previous completion or dedent"
        },
        ["<C-x>"] = {
            function()
                if cmp.visible() then
                    cmp.close()
                else
                    cmp.complete()
                end
            end,
            "Toggle completion menu"
        },
        -- Disable arrow keys in insert mode
        ["<Up>"] = { "<Up>", "Up arrow" },
        ["<Down>"] = { "<Down>", "Down arrow" },
    }
}

return M
