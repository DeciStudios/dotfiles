local M = {}

M["nvim-tree"] = {
	n = {
		["<C-n>"] = {
			"<cmd>NvimTreeToggle<CR>",
			"Toggle NvimTree",
		},
		["<C-f>"] = {
			"<cmd>NvimTreeFindFile<CR>",
			"Find file in NvimTree",
		},
		["<leader>a"] = {
			"<cmd>NvimTreeFocus<CR>",
			"Focus NvimTree",
		},
	},
}

M.telescope = {
	n = {
		["<leader>fw"] = {
			"<cmd>Telescope live_grep<CR>",
			"Find in files",
		},
		["<leader>ff"] = {
			"<cmd>Telescope find_files<CR>",
			"Find files",
		},
		["<leader>fa"] = {
			"<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
			"Find in hidden files",
		},
		["<leader>fd"] = {
			function()
				require("telescope").extensions.file_browser.file_browser()
			end,
			"Open file browser",
		},
		["<leader>fz"] = {
			"<cmd>Telescope current_buffer_fuzzy_find<CR>",
			"Find in current buffer",
		},
		["<leader>gm"] = {
			"<cmd>Telescope git_commits<CR>",
			"Git commits",
		},
		["<leader>gs"] = {
			"<cmd>Telescope git_status<CR>",
			"Git status",
		},
	},
}
local terminals = require("configs.ui.terminal")

M.terminal = {
	n = {
		["<leader>th"] = {
			function()
				terminals.horizontal:toggle()
			end,
			"Toggle horizontal terminal",
		},
		["<leader>tv"] = {
			function()
				terminals.vertical:toggle()
			end,
			"Toggle vertical terminal",
		},
		["<leader>tnh"] = {
			function()
				terminals.new_horizontal()
			end,
			"New horizontal terminal",
		},
		["<leader>tnv"] = {
			function()
				terminals.new_vertical()
			end,
			"New vertical terminal",
		},
	},
	t = {},
}

M.git = {
	n = {
		["<leader>gl"] = {
			"<cmd>LazyGit<CR>",
			"Open LazyGit",
		},
	},
}

M.trouble = {
	n = {
		["<leader>e"] = {
			"<cmd>Trouble diagnostics toggle<cr>",
			"Toggle trouble (diagnostics)",
		},
	},
}

M.terminal.n["<A-h>"] = M.terminal.n["<leader>th"]
M.terminal.n["<A-v>"] = M.terminal.n["<leader>tv"]
M.terminal.t["<A-h>"] = M.terminal.t["<leader>th"]
M.terminal.t["<A-v>"] = M.terminal.t["<leader>tv"]
-- M.telescope.n["cd"] = M.telescope.n["<leader>cd"]
-- M.telescope.n["ff"] = M.telescope.n["<leader>ff"]

return M
