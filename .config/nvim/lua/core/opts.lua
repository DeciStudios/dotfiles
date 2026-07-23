local opt = vim.opt
local o = vim.o
local g = vim.g

-- General
o.laststatus = 3
o.showmode = false
-- Clipboard
o.clipboard = "unnamedplus"
-- Cursor
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false
-- disable nvim intro
opt.shortmess:append("sI")

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 300
o.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 250
opt.winbar = "" -- Disable the winbar
opt.laststatus = 3 -- Global statusline
opt.termguicolors = true
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.undolevels = 1000
opt.undoreload = 10000
opt.lazyredraw = true
opt.scrolloff = 8
opt.inccommand = "nosplit"
g.user_emmet_leader_key = "<C-y>"
g.user_emmet_mode = "a" -- enable in all modes
g.user_emmet_install_global = 1
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.whichwrap = {
	["<"] = true,
	[">"] = true,
	["["] = true,
	["]"] = true,
}
