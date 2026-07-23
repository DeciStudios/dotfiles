local M = {}

M.help = {
    n = {
        ["<leader>?h"] = {
            "<cmd>:help<CR>",
            "Help"
        },
        ["<leader>?k"] = {
            function()
                require("which-key").show()
            end,
            "Open Which Key"
        },

    }
}

return M
