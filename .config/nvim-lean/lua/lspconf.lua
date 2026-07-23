vim.o.autocomplete = true
vim.o.completeopt = "fuzzy,menuone,noselect"

vim.filetype.add({ extension = { odin = "odin" } })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		vim.lsp.completion.enable(true, ev.data.client_id, ev.buf)
	end,
})

local capabilities = vim.tbl_deep_extend(
	"force",
	vim.lsp.protocol.make_client_capabilities(),
	{
		textDocument = {
			formatting = {
				dynamicRegistration = true,
			},
		},
	}
)

local function on_attach(client, bufnr)
	local map = vim.keymap.set
	local function opts(desc)
		return { buffer = bufnr, desc = "LSP " .. desc }
	end
	map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
	map("n", "gi", vim.lsp.buf.implementation, opts("Go to implementation"))
	map("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename symbol"))
	map("n", "<leader>sh", vim.lsp.buf.signature_help, opts("Show signature help"))
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("Add workspace folder"))
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("Remove workspace folder"))
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, opts("List workspace folders"))
	map("n", "<leader>D", vim.lsp.buf.type_definition, opts("Go to type definition"))
	map("n", "gr", vim.lsp.buf.references, opts("Show references"))
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code action"))

	if client:supports_method("textDocument/formatting") then
		vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
			require("conform").format({ bufnr = bufnr })
		end, { desc = "Format buffer" })
	end
end

local function on_init(client, _)
	if client:supports_method("textDocument/semanticTokens") then
		client.server_capabilities.semanticTokensProvider = nil
	end
end

vim.lsp.config("*", {
	capabilities = capabilities,
	on_attach = on_attach,
	on_init = on_init,
})

vim.lsp.enable({
	"lua_ls",
	"pyright",
	"ts_ls",
	"rust_analyzer",
	"ols",
	"clangd",
	"csharp_ls",
	"intelephense",
	"html",
	"cssls",
	"emmet_language_server",
})

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
	format_on_save = {
		timeout_ms = 500,
	},
})
