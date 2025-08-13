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
        { icon = " ", title = "Recent Files (Current Project)", section = "recent_files", cwd = true, limit = 8, padding = 1 },
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
      enabled = false,
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
        git_signs = true,  -- Show git changes
        mini_diff_signs = true,  -- Show mini diff signs
        diagnostics = false,
        inlay_hints = false,
        -- Hide more distractions for better focus
        number = false,
        relativenumber = false,
        signcolumn = true,  -- Keep signcolumn for git signs
        foldcolumn = false,
        cursorline = false,
        colorcolumn = false,
        spell = false,
        list = false,
      },
      show = {
        statusline = false,
        tabline = false,
        -- Hide command line when not in use
        ruler = false,
        showcmd = false,
      },
      win = {
        -- Use full screen width (0 = full width in Snacks.nvim)
        width = 0,
        -- Configure backdrop for better focus
        backdrop = {
          transparent = false,
          -- Maximum blend for ultimate focus
          blend = 90,
        },
        -- Add padding around the window
        wo = {
          -- Add virtual text padding
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          signcolumn = "yes",  -- Show signcolumn for git signs
          colorcolumn = "",
          spell = false,
          list = false,
          -- Smooth scrolling margins
          scrolloff = 10,
          sidescrolloff = 15,
          -- Clean wrap settings
          wrap = true,
          linebreak = true,
        },
      },
      -- Animation for smooth transitions
      animate = {
        enabled = true,
        duration = {
          step = 10,
          total = 150,
        },
      },
      -- Callbacks for additional customization
      on_open = function()
        -- Optional: Set a clean colorscheme or adjust highlights
        vim.cmd("set laststatus=0")
        vim.cmd("set cmdheight=0")
      end,
      on_close = function()
        -- Restore settings
        vim.cmd("set laststatus=2")
        vim.cmd("set cmdheight=1")
      end,
    },
    -- Enable explorer as a file browser
    explorer = {
      enabled = false,
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
    -- Explorer keybindings (disabled - using telescope instead)
    -- { "<leader>e", function() Snacks.explorer() end, desc = "Open/Focus Explorer" },
    -- { "<leader>eq", function() Snacks.explorer() end, desc = "Toggle Explorer" },
    -- Buffer management
    { "<leader>dd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>daa", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
  },
}
