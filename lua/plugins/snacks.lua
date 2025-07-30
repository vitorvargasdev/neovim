return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
  opts = {
    -- Dashboard (replacement for alpha.nvim)
    dashboard = {
      enabled = true,
      width = 60,
      pane_gap = 3,
      preset = {
        keys = {},
        header = [[


⠸⣷⣦⠤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⠀⠀⠀
⠀⠙⣿⡄⠈⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠔⠊⠉⣿⡿⠁⠀⠀⠀
⠀⠀⠈⠣⡀⠀⠀⠑⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⡠⠊⠁⠀⠀⣰⠟⠀⠀⠀⣀⣀
⠀⠀⠀⠀⠈⠢⣄⠀⡈⠒⠊⠉⠁⠀⠈⠉⠑⠚⠀⠀⣀⠔⢊⣠⠤⠒⠊⠉⠀⡜
⠀⠀⠀⠀⠀⠀⠀⡽⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠩⡔⠊⠁⠀⠀⠀⠀⠀⠀⠇
⠀⠀⠀⠀⠀⠀⠀⡇⢠⡤⢄⠀⠀⠀⠀⠀⡠⢤⣄⠀⡇⠀⠀⠀⠀⠀⠀⠀⢰⠀
⠀⠀⠀⠀⠀⠀⢀⠇⠹⠿⠟⠀⠀⠤⠀⠀⠻⠿⠟⠀⣇⠀⠀⡀⠠⠄⠒⠊⠁⠀
⠀⠀⠀⠀⠀⠀⢸⣿⣿⡆⠀⠰⠤⠖⠦⠴⠀⢀⣶⣿⣿⠀⠙⢄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢻⣿⠃⠀⠀⠀⠀⠀⠀⠀⠈⠿⡿⠛⢄⠀⠀⠱⣄⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢸⠈⠓⠦⠀⣀⣀⣀⠀⡠⠴⠊⠹⡞⣁⠤⠒⠉⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣠⠃⠀⠀⠀⠀⡌⠉⠉⡤⠀⠀⠀⠀⢻⠿⠆⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠰⠁⡀⠀⠀⠀⠀⢸⠀⢰⠃⠀⠀⠀⢠⠀⢣⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢶⣗⠧⡀⢳⠀⠀⠀⠀⢸⣀⣸⠀⠀⠀⢀⡜⠀⣸⢤⣶⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠈⠻⣿⣦⣈⣧⡀⠀⠀⢸⣿⣿⠀⠀⢀⣼⡀⣨⣿⡿⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠈⠻⠿⠿⠓⠄⠤⠘⠉⠙⠤⢀⠾⠿⣿⠟⠋]],
      },
      sections = {
        { section = "header" },
        { icon = " ", title = "Recent Files", section = "recent_files", limit = 8, padding = 1 },
        {
          pane = 2,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            Snacks.gitbrowse()
          end,
        },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              title = "Git Status",
              cmd = "git status --short --branch --renames",
              height = 5,
              icon = " ",
            },
            {
              title = "GitHub Notifications",
              cmd = "gh notify -s -a -n5 2>/dev/null || echo 'gh not configured'",
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
              key = "n",
              icon = " ",
              height = 5,
            },
            {
              title = "Open Issues",
              cmd = "gh issue list -L 3 2>/dev/null || echo 'No issues'",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              icon = " ",
              height = 7,
            },
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3 2>/dev/null || echo 'No PRs'",
              key = "p",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 7,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        { section = "startup" },
      },
    },
    -- Smooth scrolling (replacement for neoscroll.nvim)
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 20, total = 250 },
        easing = "linear",
      },
    },
    -- Cursor animations (disabled in favor of smear-cursor.nvim)
    animate = {
      enabled = false,
    },
    -- Better notifications
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    -- LSP rename with preview
    rename = {
      enabled = true,
    },
    -- Highlight word references
    words = {
      enabled = true,
    },
    -- Better buffer deletion
    bufdelete = {
      enabled = true,
    },
    -- Better vim.ui.input
    input = {
      enabled = true,
    },
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
    -- Buffer management
    { "<leader>dd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>daa", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
  },
}
