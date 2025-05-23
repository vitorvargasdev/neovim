return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
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

    dap.adapters["local-lua"] = {
      type = "executable",
      command = "node",
      args = {
        "/home/vitor/dev/local-lua-debugger-vscode/extension/debugAdapter.js",
      },
      enrich_config = function(config, on_config)
        if not config["extensionPath"] then
          local c = vim.deepcopy(config)
          -- 💀 If this is missing or wrong you'll see
          -- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
          c.extensionPath = "/home/vitor/dev/local-lua-debugger-vscode/"
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

    vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<Leader>dc", dap.continue, {})
    vim.keymap.set("n", "<Leader>dx", dap.terminate, {})
  end,
}
