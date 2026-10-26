local M = {}

local function get_source_dir()
	local paths = { ".", "source", "src" }
	for _, path in ipairs(paths) do
		-- Check if main.lua exists in this directory
		local f = io.open(path .. "/main.lua", "r")
		if f then
			f:close()
			return path
		end
	end
	return "." -- Fallback to current directory if not found
end

local function get_playbit_source()
	local paths = { ".", "source", "src" }
	for _, path in ipairs(paths) do
		local f = io.open(path .. "/main.lua", "r")
		if f then
			f:close()
			return path
		end
	end
	return "src" -- Playbit template default
end

local function run_in_horizontal_terminal(cmd)
	local terminals = require("configs.ui.terminal")
	terminals.horizontal:toggle()

	local term = terminals.horizontal.term
	if term and term.job_id then
		local full_cmd = cmd .. " && exit\n"
		vim.fn.chansend(term.job_id, full_cmd)
	else
		vim.notify("Terminal not ready", vim.log.levels.WARN)
	end
end

local function run_command(cmd)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
	vim.api.nvim_buf_set_option(buf, "modifiable", true)

	vim.cmd("botright split")
	vim.api.nvim_win_set_buf(0, buf)
	local win = vim.api.nvim_get_current_win()

	local function close_window()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	-- Allow easy closing with 'q' or 'Enter'
	vim.keymap.set("n", "q", close_window, { buffer = buf, nowait = true, silent = true })
	vim.keymap.set("n", "<CR>", close_window, { buffer = buf, nowait = true, silent = true })

	vim.fn.jobstart(cmd, {
		stdout_buffered = false,
		stderr_buffered = false,
		on_stdout = function(_, data)
			if not data then
				return
			end
			local clean = {}
			for _, line in ipairs(data) do
				if line ~= "" then
					table.insert(clean, line)
				end
			end
			if #clean > 0 then
				vim.api.nvim_buf_set_lines(buf, -1, -1, false, clean)
			end
		end,
		on_stderr = function(_, data)
			if not data then
				return
			end
			local clean = {}
			for _, line in ipairs(data) do
				if line ~= "" then
					table.insert(clean, line)
				end
			end
			if #clean > 0 then
				vim.api.nvim_buf_set_lines(buf, -1, -1, false, clean)
			end
		end,
		on_exit = function()
			vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "", "[Process finished – press q or Enter to close]" })
		end,
	})
end

M.tasks = {
	n = {
		-- Universal Makefile Run
		["<leader>rm"] = {
			function()
				run_command({ "make" })
			end,
			"Run project Makefile",
		},
		["<leader>ro"] = {
			function()
				run_command({ "odin", "run", "." })
			end,
			"Run Odin project",
		},
		["<leader>bo"] = {
			function()
				run_command({ "odin", "build", "." })
			end,
			"Build Odin project",
		},
		["<leader>rl"] = {
			function()
				run_command({ "love", "." })
			end,
			"Run Love2D project",
		},
		["<leader>bl"] = {
			function()
				run_command({
					"sh",
					"-c",
					"rm -f build.love && zip -9 -r build.love . -x build.love -x .git/**\\* -x .gitignore",
				})
			end,
			"Build Love2D project (.love)",
		},
		-- Helper function to find the source directory containing main.lua

		-- Your updated keymaps
		["<leader>bpd"] = {
			function()
				local sdk = os.getenv("PLAYDATE_SDK_PATH") or "~/PlaydateSDK"
				local src_dir = get_source_dir()
				run_command({
					"sh",
					"-c",
					string.format(
						"mkdir -p build && rm -rf build/build.pdx && %s/bin/pdc %s build/build.pdx",
						sdk,
						src_dir
					),
				})
			end,
			"Build Playdate project (.pdx)",
		},

		["<leader>rpd"] = {
			function()
				local sdk = os.getenv("PLAYDATE_SDK_PATH") or "~/PlaydateSDK"
				local src_dir = get_source_dir()
				run_command({
					"sh",
					"-c",
					string.format(
						"mkdir -p build && rm -rf build/build.pdx && %s/bin/pdc %s build/build.pdx && %s/bin/PlaydateSimulator build/build.pdx",
						sdk,
						src_dir,
						sdk
					),
				})
			end,
			"Run Playdate project",
		},

		-- Playbit Neovim Keymaps

		["<leader>rpbl"] = {
			function()
				run_command({ "sh", "-c", "lua .build/love2d.lua && love build/love2d/" })
			end,
			"Run Playbit project (Love2D)",
		},

		["<leader>rpbp"] = {
			function()
				local sdk = os.getenv("PLAYDATE_SDK_PATH") or "~/PlaydateSDK"
				run_command({
					"sh",
					"-c",
					string.format(
						'lua .build/playdate.lua && rm -rf "build/pdx/build.pdx" && %s/bin/pdc build/pdx "build/pdx/build.pdx" && %s/bin/PlaydateSimulator "build/pdx/build.pdx"',
						sdk,
						sdk
					),
				})
			end,
			"Run Playbit project (Playdate)",
		},
		["<leader>rpi"] = {
			function()
				run_command({ "pio", "run", "-t upload -t monitor" })
			end,
			"Upload and monitor Platform.io project",
		},

		["<leader>bpi"] = {
			function()
				run_command({ "pio", "run" })
			end,
			"Build Platform.io project",
		},
	},
}

return M
