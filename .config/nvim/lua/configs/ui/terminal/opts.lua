local M = {
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end,
    hide_numbers = true,
    shade_terminals = true,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    close_on_exit = true,
    shell = vim.o.shell,
}

return M
