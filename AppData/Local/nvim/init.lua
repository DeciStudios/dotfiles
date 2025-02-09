vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)






vim.g.dap_virtual_text = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel=99
vim.api.nvim_create_autocmd("TermClose", {
    callback = function()
       vim.cmd("close")
    end
})

-- Define a key mapping for :CopilotChat


-- if vim.g.neovide then
--   -- Helper function for transparency formatting
--   local alpha = function()
--     return string.format("%x", math.floor(255))
--   end
--   -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
--   --vim.g.neovide_transparency = 1.0
--   --vim.g.transparency = 0.8
--   vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
--   vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
--   vim.keymap.set({ "n" , "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
-- end

vim.o.completeopt = "menuone,noselect"
-- Map Enter to accept completion
vim.api.nvim_set_keymap('i', '<CR>', 'pumvisible() ? "\\<C-y>" : "\\<CR>"', { expr = true, noremap = true })







-------OLD

-- Map Ctrl+Shift+C to copy in normal mode
vim.api.nvim_set_keymap('n', '<C-S-C>', '"+y', { noremap = true, silent = true })

-- Map Ctrl+Shift+V to paste in normal mode
vim.api.nvim_set_keymap('n', '<C-S-V>', '"+p', { noremap = true, silent = true })

-- Map Ctrl+Shift+C to copy in visual mode
vim.api.nvim_set_keymap('x', '<C-S-C>', '"+y', { noremap = true, silent = true })

-- Map Ctrl+Shift+V to paste in insert mode
vim.api.nvim_set_keymap('i', '<C-S-V>', '<C-R>+', { noremap = true, silent = true })

-- require "plugins"
