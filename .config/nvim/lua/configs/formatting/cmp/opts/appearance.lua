local M = {}
local cmp = require("cmp")
M.window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
}
M.formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
        local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })

        -- Add Copilot icon for Copilot source
        if entry.source.name == "copilot" then
            kind.kind = " " -- Copilot icon
            kind.menu = "    (Copilot)"
            return kind
        end

        kind.kind = " " .. (strings[1] or "") .. " "
        kind.menu = "    (" .. (strings[2] or "") .. ")"

        return kind
    end,
}

return M
