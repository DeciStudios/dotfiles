local M = {}

M.dap = {
  plugin = true,
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
  plugin = true,
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
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function()
        require('dap-python').test_method()
      end
    }
  }
}

M.copilot = {
  plugin = true,
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

local map = vim.keymap.set
for name, maps in pairs(M) do
  for mode, data in pairs(maps) do
    for key,val in pairs(data) do
      map(mode, key, val[1], { desc=val[2] })
    end
  end
end