local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

local M = {}

M.setup = function()
    require("harpoon").setup({
        menu = {
            width = vim.api.nvim_win_get_width(0) - 4,
        }
    })
end

M.setup()
