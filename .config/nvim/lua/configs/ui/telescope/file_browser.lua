local fb_actions = require("telescope").extensions.file_browser.actions
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")

require("telescope").setup({
	extensions = {
		file_browser = {
			theme = "ivy",
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = true,
			mappings = {
				["i"] = {
					-- your custom insert mode mappings
					["<C-e>"] = function(prompt_bufnr) -- Ctrl+Enter in most cases
						local picker = actions_state.get_current_picker(prompt_bufnr)
						if not picker then
							return
						end

						fb_actions.change_cwd(prompt_bufnr)
						actions.close(prompt_bufnr)
					end,
				},
				["n"] = {
					-- your custom normal mode mappings
					["<Space>"] = function(prompt_bufnr)
						local picker = actions_state.get_current_picker(prompt_bufnr)
						if not picker then
							return
						end -- Prevent errors if there's no active picker

						fb_actions.change_cwd(prompt_bufnr)
						actions.close(prompt_bufnr)
					end,
				},
			},
		},
	},
})
