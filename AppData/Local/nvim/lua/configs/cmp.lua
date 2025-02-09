local M = require("nvchad.configs.cmp")
local cmp = require "cmp"
M.completion.completeopt = "menu,menuone,noselect"
M.mapping["<CR>"] = cmp.mapping.confirm {
  behavior = cmp.ConfirmBehavior.Insert,
  select = false,
}
M.sources = {
  {name="crates",group_index = 2},
  { name = "nvim_lsp", group_index = 2 },
  { name = "copilot",  group_index = 2 },
  { name = "luasnip",  group_index = 2 },
  { name = "buffer",   group_index = 2 },
  { name = "nvim_lua", group_index = 2 },
  { name = "path",     group_index = 2 },
}
return M