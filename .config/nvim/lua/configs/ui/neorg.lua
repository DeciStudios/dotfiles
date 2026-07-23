local M = {
    load = {
        ["core.defaults"] = {},  -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.dirman"] = {      -- Manages Neorg workspaces
            config = {
                workspaces = {
                    notes = "~/notes",
                    work = "~/notes/work",
                    personal = "~/notes/personal",
                },
            },
        },
        ["core.completion"] = {
            config = {
                engine = "nvim-cmp",
            },
        },
        ["core.presenter"] = {
            config = {
                zen_mode = "zen-mode",
            },
        },
    },
}
require("neorg").setup(M)
