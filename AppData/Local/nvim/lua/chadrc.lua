---@type ChadrcConfig 
local M = {}


M.base46 = {
  theme="catppuccin"
}

M.ui = {
  
  transparency = false,
  statusline = {
    theme = "minimal",
    separator_style = "round",
  },

}
M.nvdash = { 
  load_on_startup = true,
  header={

  "     ▄▄▄       ▄▄    ▄ ▄▄   ▄▄ ",
  "  ▄▀▀   ▀▀▄   █  █  █ █  █ █  █",
  " █       ▄▄█  █   █▄█ █  █▄█  █",
  "█    ▄▄▀▀     █       █       █",
  "▀▄     ▀▀▄▄▄  █  ▄    █       █",
  " ▀▄       ▄▀  █ █ █   ██     █ ",
  "   ▀▀▄▄▄▀▀    █▄█  █▄▄█ █▄▄▄█  ",
  "                               ",
  " Powered By  eovim",
  ""
    
  },
  buttons = {
    { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
    { txt = "  Open Directory", keys = "cd", cmd = "Telescope file_browser" },
    { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
    { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
    { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },

    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  },
}


if vim.g.neovide then
  --print("YEAH")
  vim.o.guifont= "FiraCode Nerd Font:h13:b"
  --vim.g.neovide_font_size = 12
  --vim.g.neovide
  -- vim.g.neovide_transparency = 0.8
  -- vim.g.neovide_window_blurred = true
  M.ui.transparency  = false
end


return M
