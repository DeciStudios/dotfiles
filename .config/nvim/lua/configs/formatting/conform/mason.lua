local M = {
    -- You can add automatic installation of formatters here
    ensure_installed = {
        "prettier",
        "stylua",
        "black",
        "debugpy",
        "mypy",
    },
    automatic_installation = true,
}

return M
