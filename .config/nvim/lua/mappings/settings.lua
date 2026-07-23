local M = {}

M.settings = {
    n = {
        ["<leader>sc"] = {
            "<cmd>cd ~/.config/nvim<CR>",
            "Open config directory"
        },
        ["<leader>st"] = {
            "<cmd>Themer<CR>",
            "Open Theme Selector"
        }
    }
}

return M
