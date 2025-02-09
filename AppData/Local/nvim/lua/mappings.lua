require "nvchad.mappings"
local M = {}

M.dap = {
  n = {
    ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>" },
    ["<leader>dus"] = {
      function ()
        local widgets = require('dap.ui.widgets');
        local sidebar = widgets.sidebar(widgets.scopes);
        sidebar.open();
      end,
      "Open debugging sidebar"
    }
  }
}

M.crates = {
  n = {
    ["<leader>rcu"] = {
      function ()
        require('crates').upgrade_all_crates()
      end,
      "update crates"
    }
  }
}

M.dap_python = {
  n = {
    ["<leader>dpr"] = {
      function()
        require('dap-python').test_method()
      end
    }
  }
}

M.copilot = {
  n = {
    ["<leader>gc"] = {
      function()
        require("CopilotChat").open()
      end,
      "open copilot chat"
    },
    ["<leader>go"] = {
      function ()
        require("copilot").toggle()
      end,
      "toggle copilot"
    },
    ["<leader>gi"] = {
      function ()
        require("CopilotChat").open({
          window = {
            layout = 'float',
            relative = 'cursor',
            width = 1,
            height = 0.4,
            row = 1,
          }
        })
      end,
      "open copilot chat inline"
    }
  }
}

M.telescope_dir = {
  n = {
    ["cd"] = {
      function ()
        require("telescope").extensions.file_browser.file_browser()
      end,
      "open file in default app"
    },
    ["<leader>cd"] = {
      function ()
        require("telescope").extensions.file_browser.file_browser()
      end,
      "open file in default app"
    }
  }
}

--[[M.mpv = {
  n = {
    ["<leader>mv"] = {
      function ()
        require("mpv").toggle_player()
      end,
      "play video"
    }
  }
}]]


local map = vim.keymap.set
for name, maps in pairs(M) do
  for mode, data in pairs(maps) do
    for key,val in pairs(data) do

      map(mode, key, val[1], { desc=val[2] })
    end
  end
end
