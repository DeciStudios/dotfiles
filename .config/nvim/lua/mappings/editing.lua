local M = {}

M.editing = {
	-- Normal mode mappings
	n = {
		-- Toggle comment on current line
		["<leader>/"] = {
			function()
				require("Comment.api").toggle.linewise.current()
			end,
			"Toggle comment",
		},
		-- Toggle comment on multiple lines
		["<leader>c/"] = {
			function()
				require("Comment.api").toggle.linewise.count(vim.v.count1)
			end,
			"Toggle comment on multiple lines",
		},
		-- Toggle block comment
		["<leader>cb"] = {
			function()
				require("Comment.api").toggle.blockwise.current()
			end,
			"Toggle block comment",
		},

		["<leader>u"] = {
			"<cmd>UndotreeFocus<CR>",
			"Focus Undotree",
		},
		["<C-u>"] = {
			"<cmd>UndotreeToggle<CR>",
			"Toggle Undotree",
		},
		["<C-s>"] = { ":w<CR>", "Quick save" },

		-- Duplicate line
		["<C-d>"] = { "yyp", "Duplicate line" },

		-- Move lines up/down
		["<A-j>"] = { ":m .+1<CR>==", "Move line down" },
		["<A-k>"] = { ":m .-2<CR>==", "Move line up" },

		-- Quick indent/dedent
		[">"] = { ">>", "Indent" },
		["<"] = { "<<", "Dedent" },

		-- Quick end of line
		["<C-e>"] = { "$", "End of line" },
		["<C-a>"] = { "^", "Start of line" },
		["ga"] = { "<Plug>(EasyAlign)", "Easy Align" },

		--Find and replace menu
		["<leader>fr"] = {
			function()
				require("ssr").open()
			end,
			"Find and replace (ssr)",
		},
		["w"] = {
			":w<CR>",
			"Quick save",
		},
	},
	x = {},
	-- Visual mode mappings
	v = {
		-- Toggle comment on selection
		["<leader>/"] = {
			"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
			"Toggle comment on selection",
		},
		-- Toggle block comment on selection
		["<leader>cb"] = {
			"<ESC><cmd>lua require('Comment.api').toggle.blockwise(vim.fn.visualmode())<CR>",
			"Toggle block comment on selection",
		},


		["<leader>cf"] = {
			function()
				require("conform").format({ async = true })
			end,
			"Format buffer",
		},
		["<C-z>"] = {
			"<esc>u",
			"Undo",
		},
		["<C-r>"] = {
			"<esc><C-r>",
			"Redo",
		},
		["<A-j>"] = { ":m '>+1<CR>gv=gv", "Move selection down" },
		["<A-k>"] = { ":m '<-2<CR>gv=gv", "Move selection up" },

		-- Keep visual selection when indenting
		[">"] = { ">gv", "Indent" },
		["<"] = { "<gv", "Dedent" },
		["ga"] = { "<Plug>(EasyAlign)", "Easy Align" },
	},
	i = {
		["<C-z>"] = {
			"<C-o>u",
			"Undo",
		},
		["<C-r>"] = {
			"<C-o><C-r>",
			"Redo",
		},
		["jk"] = { "<ESC>", "Escape insert mode" },
		["kj"] = { "<ESC>", "Escape insert mode" },

		-- Quick save in insert mode
		["<C-s>"] = { "<ESC>:w<CR>a", "Save file" },

		-- Quick movement in insert mode
		["<C-h>"] = { "<Left>", "Move left" },
		["<C-l>"] = { "<Right>", "Move right" },
		["<C-j>"] = { "<Down>", "Move down" },
		["<C-k>"] = { "<Up>", "Move up" },

		-- Quick end/start of line in insert mode
		["<C-e>"] = { "<ESC>A", "End of line" },
		["<C-a>"] = { "<ESC>I", "Start of line" },
	},
}
M.multicursor = {
	n = {
		["<C-Up>"] = {
			"<cmd>MultipleCursorsAddUp<CR>",
			"Add cursor above",
		},
		["<C-Down>"] = {
			"<cmd>MultipleCursorsAddDown<CR>",
			"Add cursor below",
		},
	},
	i = {
		["<C-Up>"] = {
			"<cmd>MultipleCursorsAddUp<CR>",
			"Add cursor above",
		},
		["<C-Down>"] = {
			"<cmd>MultipleCursorsAddDown<CR>",
			"Add cursor below",
		},
	},
}
-- Additional editing utilities can go here
M.editing.n["<leader>cf"] = {
	function()
		vim.lsp.buf.format({ async = true })
	end,
	"Format document",
}

M.editing.x["<leader>fr"] = M.editing.n["<leader>fr"]

return M
