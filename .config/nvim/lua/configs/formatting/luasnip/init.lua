local opts = require("configs.formatting.luasnip.opts")
require("luasnip").setup(opts)
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_snipmate").lazy_load()
