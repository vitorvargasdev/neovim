return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    { "<Leader>dt", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
    { "<Leader>dc", function() require("dap").continue() end, desc = "DAP continue" },
    { "<Leader>dx", function() require("dap").terminate() end, desc = "DAP terminate" },
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")

    require("dapui").setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- installed by mason-tool-installer (lsp-config.lua)
    local lldebugger = vim.fn.stdpath("data") .. "/mason/packages/local-lua-debugger-vscode/extension"

    dap.adapters["local-lua"] = {
      type = "executable",
      command = "node",
      args = {
        lldebugger .. "/extension/debugAdapter.js",
      },
      enrich_config = function(config, on_config)
        if not config["extensionPath"] then
          local c = vim.deepcopy(config)
          -- 💀 If this is missing or wrong you'll see
          -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
          c.extensionPath = lldebugger
          on_config(c)
        else
          on_config(config)
        end
      end,
    }

    dap.configurations.lua = {
      {
        name = "Current file (local-lua-dbg, lua)",
        type = "local-lua",
        repl_lang = "lua",
        request = "launch",
        cwd = "${workspaceFolder}",
        program = {
          lua = "luajit",
          file = "${file}",
        },
        args = {},
      },
      {
        name = "Current file (local-lua-dbg, neovim lua interpreter with nlua)",
        type = "local-lua",
        repl_lang = "lua",
        request = "launch",
        cwd = "${workspaceFolder}",
        program = {
          lua = "nlua",
          file = "${file}",
        },
        args = {},
      },
    }
  end,
}
