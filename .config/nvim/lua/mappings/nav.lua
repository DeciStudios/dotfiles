local M = {}

M.navigation = {
    i = {
        ["<C-b>"] = {
            "<ESC>^i",
            "Move to the beginning of the line"
        },
        ["<C-e>"] = {
            "<End>",
            "Move to the end of the line",
        },
        ["<C-h>"] = {
            "<Left>",
            "Move left",
        },
        ["<C-l>"] = {
            "<Right>",
            "Move right",
        },
        ["<C-j>"] = {
            "<Down>",
            "Move down",
        },
        ["<C-k>"] = {
            "<Up>",
            "Move up",
        },
    },

    n = {
        ["<C-h>"] = { "<C-w>h", "Move to left split" },
        ["<C-j>"] = { "<C-w>j", "Move to bottom split" },
        ["<C-k>"] = { "<C-w>k", "Move to top split" },
        ["<C-l>"] = { "<C-w>l", "Move to right split" },
        ["<leader>v"] = { ":vsplit<CR>", "Vertical split" },
        ["<leader>h"] = { ":split<CR>", "Horizontal split" },
        ["<leader>Hw"] = { "<cmd>HopWord<CR>", "Hop to word" },
        ["<leader>Hl"] = { "<cmd>HopLine<CR>", "Hop to line" },
        ["<leader>Hc"] = { "<cmd>HopChar1<CR>", "Hop to character" },

        -- Harpoon
        -- ["<leader>Ha"] = {
        --     function() require("harpoon.mark").add_file() end,
        --     "Add file to harpoon"
        -- },
        -- ["<leader>Hm"] = {
        --     function() require("harpoon.ui").toggle_quick_menu() end,
        --     "Harpoon menu"
        -- },
        -- ["<C-n>"] = {
        --     function() require("harpoon.ui").nav_next() end,
        --     "Next harpoon mark"
        -- },
        -- ["<C-p>"] = {
        --     function() require("harpoon.ui").nav_prev() end,
        --     "Previous harpoon mark"
        -- },
        ["<leader>z"] = {
            function()
                local winid = vim.api.nvim_get_current_win()
                local curr_line = vim.api.nvim_win_get_cursor(winid)[1]
                if vim.fn.foldlevel(curr_line) > 0 then -- Check if the line is foldable
                    if vim.fn.foldclosed(curr_line) == -1 then
                        vim.cmd('normal! zc')           -- Close fold
                    else
                        vim.cmd('normal! zo')           -- Open fold
                    end
                end
            end,
            "Toggle current fold"
        },

        ["<leader>Z"] = {
            function()
                -- If any folds are closed, open all. Otherwise, close all.
                local has_closed_folds = false
                local buf = vim.api.nvim_get_current_buf()
                local lines = vim.api.nvim_buf_line_count(buf)

                -- Check first few lines for closed folds (checking all lines could be slow)
                for i = 1, math.min(1000, lines) do
                    if vim.fn.foldclosed(i) ~= -1 then
                        has_closed_folds = true
                        break
                    end
                end

                if has_closed_folds then
                    require('ufo').openAllFolds()
                else
                    require('ufo').closeAllFolds()
                end
            end,
            "Toggle all folds"
        },
        -- UFO folding

    }
}


M.buffers = {
    n = {
        ["<leader>x"] = {
            "<cmd>BufferClose<CR>",
            "Close current buffer"
        },
        ["<Tab>"] = {
            "<cmd>BufferNext<CR>",
            "Next buffer"
        },
        ["<S-Tab>"] = {
            "<cmd>BufferPrevious<CR>",
            "Previous buffer"
        }

    }
}
return M
