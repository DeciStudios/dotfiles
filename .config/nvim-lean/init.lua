require("mappings")
require("plugins")
require("lspconf")

vim.o.laststatus = 3
vim.o.showmode = false
vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.cursorlineopt = "number"

vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.tabstop = 4
vim.o.softtabstop = 4

vim.opt.fillchars = { eob = " " }
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = "a"

vim.o.number = true
vim.o.numberwidth = 2
vim.o.ruler = false
vim.opt.shortmess:append("sI")

vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.timeoutlen = 300
vim.o.undofile = true
vim.o.updatetime = 250
vim.opt.winbar = ""
vim.opt.termguicolors = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.lazyredraw = true
vim.opt.scrolloff = 8
vim.opt.inccommand = "nosplit"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.whichwrap = {
	["<"] = true,
	[">"] = true,
	["["] = true,
	["]"] = true,
}
vim.cmd.colorscheme("gruvbox")
