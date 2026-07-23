local M = {}

M.notes = {
    n = {
        ["<leader>nt"] = { "<cmd>Neorg workspace notes<cr>", "Open notes workspace" },
        ["<leader>nw"] = { "<cmd>Neorg workspace work<cr>", "Open work notes" },
        ["<leader>np"] = { "<cmd>Neorg workspace personal<cr>", "Open personal notes" },

        -- Todo comments
        ["<leader>ft"] = { "<cmd>TodoTelescope<cr>", "Find TODOs" },
        ["]t"] = {
            function() require("todo-comments").jump_next() end,
            "Next todo comment"
        },
        ["[t"] = {
            function() require("todo-comments").jump_prev() end,
            "Previous todo comment"
        },
    }
}

return M
