local M = {
    animation = true,
    auto_hide = false,
    tabpages = true,
    closable = true,
    clickable = true,
    -- icons = {
    --     separator = { left = '', right = '' },
    -- },
    -- Add offset when nvim-tree is open
    sidebar_filetypes = {
        -- Use the default values: {event = 'BufWinLeave', text = nil}
        NvimTree = { text = 'File Explorer' },
        undotree = { text = 'Undo Tree' },
    },
}

return M
