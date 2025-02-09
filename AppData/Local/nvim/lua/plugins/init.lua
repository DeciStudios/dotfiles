local cmp = require "cmp"

local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "black",
        "debugpy",
        "mypy",
        "ruff",
        "pyright",
        "ols",
        "glsl_analyzer"
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- require "plugins.configs.lspconfig"
      require "configs.lspconfig"
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require "configs.rustaceanvim"
    end
  },
  {
    "mfussenegger/nvim-dap",
    init = function()
      -- require("core.utils").load_mappings("dap")
    end
  },
  {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function(_, opts)
      local crates  = require('crates')
      crates.setup(opts)
      require('cmp').setup.buffer({
        sources = { { name = "crates" }}
      })
      crates.show()
      require("core.utils").load_mappings("crates")
    end,
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    config = function(_, opts)
      require("nvim-dap-virtual-text").setup()
    end
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "zbirenbaum/copilot-cmp",
    },
    opts = function()
      return require "configs.cmp"
    end,
  },
  -- {
  --   "jackMort/ChatGPT.nvim",
  --   event = "VeryLazy",
  --   dependencies = {
  --       "MunifTanjim/nui.nvim",
  --       "nvim-lua/plenary.nvim",
  --       "nvim-telescope/telescope.nvim",
  --   },
  --   config = function()
  --     require("chatgpt").setup({
  --       api_key_cmd = "pass show api/tokens/openai/gpt-nvim"
  --     })
  --   end,
  -- },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion={enabled=false},
        panel={enabled=false},
        copilot_node_command="C:/Users/jackm/AppData/Local/fnm_multishells/25708_1739059565931/node.exe"
      })
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = "CopilotChat",
    dependencies = {
      { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    config = function()
      require("CopilotChat").setup(require("configs/copilot"))
    end
    -- See Commands section for default commands if you want to lazy load on them
  },
  {
    "nvim-neotest/nvim-nio",
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      -- require("core.utils").load_mappings("dap_python")
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    ft = {"python"},
    opts = function()
      return require "configs.null-ls"
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    dependencies = "zbirenbaum/copilot.lua",
    config = function ()
      require("copilot_cmp").setup({})
    end
  },

  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    init = function()
      require("telescope").load_extension("file_browser")
    end,
    config = function()
      local fb_actions = require "telescope".extensions.file_browser.actions
      local actions = require "telescope.actions"
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
                  if not picker then return end

                  fb_actions.change_cwd(prompt_bufnr)
                  actions.close(prompt_bufnr)
                end
              },
              ["n"] = {
                -- your custom normal mode mappings
                ["<Space>"] = function(prompt_bufnr)
                  local picker = actions_state.get_current_picker(prompt_bufnr)
                  if not picker then return end -- Prevent errors if there's no active picker

                  fb_actions.change_cwd(prompt_bufnr)
                  actions.close(prompt_bufnr)
                end
              },
            },
          },
        },
      })
    end
  },
  --[[{ 
    "DeciStudios/mpv.nvim", 
    config=function()
      require("mpv").setup({
          width = 50,
          height = 5,              -- Changing these two might break the UI 😬
          border = 'single',
          setup_widgets = false,   -- to activate the widget components
          timer = {
              after = 1000,
              throttle = 250,      -- Update time for the widgets. (lesser the faster)
          }
      })
    end 
  }]]



}
return plugins
