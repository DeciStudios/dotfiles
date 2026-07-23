local Terminal = require('toggleterm.terminal').Terminal

local M = {}

-- Create persistent terminal instances
M.horizontal = Terminal:new({
    direction = "horizontal",
    hidden = true,
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<C-\\><C-n>", { noremap = true, silent = true })
    end,
})

M.vertical = Terminal:new({
    direction = "vertical",
    hidden = true,
    on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<C-\\><C-n>", { noremap = true, silent = true })
    end,
})

-- Function to create new terminals
function M.new_horizontal()
    Terminal:new({
        direction = "horizontal",
        on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<C-\\><C-n>", { noremap = true, silent = true })
        end,
    }):open()
end

function M.new_vertical()
    Terminal:new({
        direction = "vertical",
        on_open = function(term)
            vim.cmd("startinsert!")
            vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<esc>", "<C-\\><C-n>", { noremap = true, silent = true })
        end,
    }):open()
end

return M
