---@type ChadrcConfig 
local M = {}




M.ui = {
  theme = 'catppuccin',
  transparency = true,
  statusline = {
    theme = "minimal",
    separator_style = "round",
  },
  nvdash = {
    load_on_startup = true,
  },
}
M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

if vim.g.neovide then
  --print("YEAH")
  vim.g.neovide_font_size = 12
  M.ui.transparency  = false
end


return M
