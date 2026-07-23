local M = {}
vim.g.nvim_tree_respect_buf_cwd = 1

M.update_cwd =true 
M.renderer = {
    root_folder_label = false,
    highlight_git = true,
    indent_markers = { enable = true },
    icons = {
        glyphs = {
            default = "",
            folder = {
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
            },
            git = {
                unmerged = "",
            },
        }
    }
}

return M
