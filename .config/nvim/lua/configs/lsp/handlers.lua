local M = {}

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	vim.diagnostic.config({
		virtual_text = true,
		signs = { active = signs },
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})

	vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
		config = config or {}
		config.border = "rounded"
		return vim.lsp.handlers.hover(err, result, ctx, config)
	end

	vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
		config = config or {}
		config.border = "rounded"
		return vim.lsp.handlers.signature_help(err, result, ctx, config)
	end
end

return M
