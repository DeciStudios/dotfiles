local M = {
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		odin = { "odin_fmt" },
		python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
		-- Add a fallback formatter for unknown filetypes
		["*"] = { "trim_whitespace", "trim_newlines" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback", -- replaces lsp_fallback in newer versions
	},
	-- Replace format_on_save with format_after_save for async formatting
	formatters = {
		odin_fmt = {
			command = "odinfmt",
			args = { "-w", "$FILENAME" },
			stdin = false,
		},
	},
}

return M
