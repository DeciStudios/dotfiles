local M = {
  {
    "3rd/image.nvim",
    config = function()
      require("image").setup(require("configs.media.image"))
    end,
  }
}

return M 
