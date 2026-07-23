local merge = require("utils.merge")
local map = vim.keymap.set
function set_mappings(...)
    local keymaps = merge(...)
    
    for name, maps in pairs(keymaps) do
        
        for mode, data in pairs(maps) do
            for key, val in pairs(data) do
                map(mode, key, val[1], { desc = val[2] })
            end
        end
    end
end


return set_mappings