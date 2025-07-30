return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
  opts = {
    -- Enable lazygit integration
    lazygit = { 
      enabled = true,
      -- Configure lazygit to use the current Neovim colorscheme
      theme = {
        nerdFontsVersion = "3", -- Use nerd fonts version 3
      },
    },
    -- Enable indent guides
    indent = {
      enabled = true,
      -- Show scope highlighting
      scope = {
        enabled = true,
      },
      -- Enable animations if Neovim >= 0.10
      animate = {
        enabled = vim.fn.has("nvim-0.10") == 1,
      },
    },
    -- Enable zen mode for distraction-free coding
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
        diagnostics = false,
        inlay_hints = false,
      },
      show = {
        statusline = false,
        tabline = false,
      },
      win = {
        width = 120,
        backdrop = {
          transparent = true,
          blend = 60,
        },
      },
    },
    -- Enable explorer as a file browser
    explorer = {
      enabled = true,
    },
    -- Configure picker for explorer sidebar
    picker = {
      enabled = true,
      sources = {
        explorer = {
          auto_close = false,
          follow_file = true,
          focus = "list",
          git_status = true,
          git_status_open = false,
          git_untracked = true,
          hidden = false,
          tree = true,
          layout = {
            preset = "sidebar",
            sidebar = {
              position = "right",
              width = 40,
            },
          },
          win = {
            list = {
              keys = {
                ["l"] = "confirm",
                ["h"] = "explorer_close",
                ["<BS>"] = "explorer_up",
                ["a"] = "explorer_add",
                ["d"] = "explorer_del",
                ["r"] = "explorer_rename",
                ["c"] = "explorer_copy",
                ["m"] = "explorer_move",
                ["y"] = "explorer_yank",
                ["p"] = "explorer_paste",
                ["<C-r>"] = "refresh",
              },
            },
          },
        },
      },
    },
  },
  keys = {
    -- Main lazygit command (matching your existing keybinding)
    { "<leader>tl", function() Snacks.lazygit() end, desc = "LazyGit" },
    -- Additional useful git commands
    { "<leader>tg", function() Snacks.lazygit() end, desc = "LazyGit" },
    { "<leader>tG", function() Snacks.lazygit.log() end, desc = "LazyGit Log" },
    { "<leader>tf", function() Snacks.lazygit.log_file() end, desc = "LazyGit Current File" },
    -- Zen mode keybindings
    { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    -- Explorer keybindings
    { "<leader>e", function()
      -- Sempre abre/foca no explorer (nunca fecha)
      local explorer_win = nil
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local ft = vim.bo[buf].filetype
        if ft == 'snacks_picker_list' then
          explorer_win = win
          break
        end
      end
      if explorer_win and vim.api.nvim_win_is_valid(explorer_win) then
        vim.api.nvim_set_current_win(explorer_win)
      else
        Snacks.explorer()
      end
    end, desc = "Open/Focus Explorer" },
    { "<leader>E", function() Snacks.explorer() end, desc = "Toggle Explorer" },
  },
}
