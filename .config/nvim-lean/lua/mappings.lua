local map = vim.keymap.set
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Delete
map({ "n", "x" }, "d", '"_d', { desc = "Delete" })
map({ "n", "x" }, "D", '"_D', { desc = "Delete line" })
map({ "n", "x" }, "x", "d", { desc = "Cut" })
map({ "n", "x" }, "X", "D", { desc = "Cut line" })
map("x", "p", '"_dP', { desc = "Paste over" })

-- Trees
map("n", "<C-n>", function()
	require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle file tree" })
map("n", "<C-u>", function()
	require("undotree").toggle()
end, { desc = "Open undotree" })

-- Comment
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle line comment" })
map("x", "<leader>/", "gc", { remap = true, desc = "Toggle visual comment" })
map("n", "<leader>b", "gbc", { remap = true, desc = "Toggle block comment" })
map("x", "<leader>b", "gb", { remap = true, desc = "Toggle block comment (visual)" })

map("n", "<C-d>", "yyp", { desc = "Duplicate line" })

map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

map("n", ">", ">>", { desc = "Indent" })
map("n", "<", "<<", { desc = "Dedent" })

map("n", "<C-e>", "$", { desc = "End of line" })
map("n", "<C-a>", "^", { desc = "Start of line" })

map({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true })
end, { desc = "Format buffer" })

map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '>-2<CR>gv=gv", { desc = "Move selection up" })

map("v", ">", ">gv", { desc = "Indent" })
map("v", "<", "<gv", { desc = "Dedent" })

map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })

map("i", "<C-a>", "<Esc>I", { desc = "Start of line" })

map("i", "<C-b>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-b>"
	end
end, { expr = true })

map("i", "<C-f>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-f>"
	end
end, { expr = true })

map("i", "<C-Space>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-e>"
	else
		return "<C-x><C-o>"
	end
end, { expr = true })

map("i", "<C-e>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-e>"
	else
		return "<Esc>A"
	end
end, { expr = true, desc = "End of line" })

map("i", "<C-BS>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-e>"
	else
		return "<C-BS>"
	end
end, { expr = true })

map("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-y>"
	else
		return "<CR>"
	end
end, { expr = true })

map({ "i", "x" }, "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-n>"
	elseif vim.snippet.active({ direction = 1 }) then
		vim.schedule(function()
			vim.snippet.jump(1)
		end)
		return ""
	else
		return "<Tab>"
	end
end, { expr = true })

map({ "i", "x" }, "<S-Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-p>"
	elseif vim.snippet.active({ direction = -1 }) then
		vim.schedule(function()
			vim.snippet.jump(-1)
		end)
		return ""
	else
		return "<S-Tab>"
	end
end, { expr = true })

-- Find
map("n", "<leader>ff", function()
	require("telescope.builtin").find_files()
end, { desc = "Find files" })
map("n", "<leader>fr", function()
	require("spectre").toggle()
end, { desc = "Search and replace" })
map("n", "<leader>fz", function()
	require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Find in current buff" })
map("n", "<leader>fa", function()
	require("telescope.builtin").find_files({ follow = true, no_ignore = true, hidden = true })
end, { desc = "Find hidden files" })
map("n", "<leader>fw", function()
	require("telescope.builtin").live_grep()
end, { desc = "Find in files (grep)" })
map("n", "<leader>fd", function()
	require("telescope").extensions.file_browser.file_browser()
end, { desc = "File browser" })
map("n", "<leader>sw", function()
	require("spectre").open_visual({ select_word = true })
end, { desc = "Search current word" })
map("v", "<leader>sw", function()
	require("spectre").open_visual()
end, { desc = "Search current word" })

-- Git
map("n", "<leader>gs", function()
	require("telescope.builtin").git_status()
end, { desc = "Git status (telescope)" })
map("n", "<leader>gc", function()
	require("telescope.builtin").git_commits()
end, { desc = "Git commits (telescope)" })
map("n", "<leader>gl", function()
	require("lazygit").lazygit()
end, { desc = "Open Lazygit" })

-- Buffers
map("n", "<A-,>", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
map("n", "<A-.>", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
map("n", "<A-c>", "<Cmd>BufferClose<CR>", { desc = "Close buffer" })
map("n", "<C-p>", "<Cmd>BufferPick<CR>", { desc = "Pick buffer" })

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Misc
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save" })
map("n", "<leader>qq", "<cmd>q<CR>", { desc = "Quit" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
