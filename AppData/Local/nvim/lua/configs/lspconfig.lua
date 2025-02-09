local nvlsp = require "nvchad.configs.lspconfig"
local on_attach = nvlsp.on_attach
local capabilities = nvlsp.capabilities

local lspconfig = require("lspconfig")
local util = require "lspconfig/util"


local servers = {
  "pyright",
  "ruff",
  "glsl_analyzer", -- Add this line
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {"python"},
  })
end

lspconfig.ols.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "odin" },  -- adjust this to the filetypes that OLS should handle
})

lspconfig.glsl_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "glsl", "frag", "vert" },  -- adjust this to the filetypes that glsl-analyzer should handle
})