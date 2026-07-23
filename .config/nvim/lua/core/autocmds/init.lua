-- Conform auto
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

--Auto open diagnostic float

local function show_diagnostics_if_normal()
	if vim.api.nvim_get_mode().mode == "n" then
		vim.diagnostic.open_float()
	end
end

local function hide_diagnostics()
	vim.diagnostic.hide()
end

-- Open diagnostics when scrolling in normal mode
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorHoldI" }, {
	callback = show_diagnostics_if_normal,
})

-- Hide diagnostics when entering insert or visual mod
vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "*:[iv]*", -- Detect entering Insert or Visual mode
	callback = hide_diagnostics,
})

local luaApi = require("core.autocmds.lua_api")
luaApi()

local pio = require("core.autocmds.platformio")
pio()
