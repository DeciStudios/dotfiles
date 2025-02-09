---@type ChadrcConfig 
local M = {}




M.ui = {
  theme = 'onedark',
  transparency = false,
  statusline = {
    theme = "minimal",
    separator_style = "round",
  },

}
M.nvdash = {
  load_on_startup=true
}
M.plugins = "custom.plugins"
require "custom.mappings"


if vim.g.neovide then
  --print("YEAH")
  vim.o.guifont= "FiraCode Nerd Font:h13:b"
  --vim.g.neovide_font_size = 12
  --vim.g.neovide
  M.ui.transparency  = false
end
vim.g.nvchad_theme = M.ui.theme

return M
