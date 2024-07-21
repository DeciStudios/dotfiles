vim.g.dap_virtual_text = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel=99
vim.api.nvim_create_autocmd("TermClose", {
    callback = function()
       vim.cmd("close")
    end
})

-- Define a key mapping for :CopilotChat
vim.api.nvim_set_keymap('n', '<leader>co', ':CopilotChat<CR>', { noremap = true, silent = true })


if vim.g.neovide then
  -- Helper function for transparency formatting
  local alpha = function()
    return string.format("%x", math.floor(255))
  end
  -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  --vim.g.neovide_transparency = 1.0
  --vim.g.transparency = 0.8
  vim.g.neovide_background_color = "#1e1e2e" --.. alpha()
  vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
  vim.keymap.set({ "n", "v" }, "<C-->", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
  vim.keymap.set({ "n" , "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>")
end

vim.o.completeopt = "menuone,noselect"
-- Map Enter to accept completion
vim.api.nvim_set_keymap('i', '<CR>', 'pumvisible() ? "\\<C-y>" : "\\<CR>"', { expr = true, noremap = true })

