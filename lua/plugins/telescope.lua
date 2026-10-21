return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          initial_mode = "normal",

          -- Appearance
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          multi_icon = " ",

          -- Borders and window style
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          winblend = 10,

          -- Layout
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              width = 0.99,
              height = 0.99,
              preview_width = 0.6,
              prompt_position = "bottom",
              preview_cutoff = 120,
            },
            vertical = {
              width = 0.99,
              height = 0.99,
              prompt_position = "bottom",
            },
          },
          sorting_strategy = "ascending",

          -- Path display
          path_display = { "truncate" },

          -- File ignore patterns
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "%.lock",
            "dist/",
            "build/",
            "%.jpg",
            "%.jpeg",
            "%.png",
            "%.svg",
            "%.otf",
            "%.ttf",
          },

          -- Colors and icons
          color_devicons = true,

          -- Mappings
          mappings = {
            n = {
              ["q"] = require("telescope.actions").close,
              ["e"] = false, -- Disable 'e' key in all pickers
              ["l"] = require("telescope.actions").select_default,
              ["h"] = require("telescope.actions").close,
              ["<S-l>"] = require("telescope.actions").select_vertical, -- Vertical split
              ["<S-h>"] = require("telescope.actions").select_horizontal, -- Horizontal split
              ["<S-j>"] = require("telescope.actions").preview_scrolling_down,
              ["<S-k>"] = require("telescope.actions").preview_scrolling_up,
            },
            i = {
              ["<S-j>"] = require("telescope.actions").preview_scrolling_down,
              ["<S-k>"] = require("telescope.actions").preview_scrolling_up,
            },
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", function()
        builtin.find_files({ initial_mode = "insert" })
      end, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fg", function()
        builtin.live_grep({ initial_mode = "insert" })
      end, { desc = "Telescope live grep" })
      vim.keymap.set("v", "<leader>fy", function()
        -- prompt is single-line; match the selection literally, not as a regex
        local text = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."))[1]
        builtin.live_grep({ default_text = text, additional_args = { "--fixed-strings" }, initial_mode = "normal" })
      end, { desc = "Telescope grep selected text" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
      vim.keymap.set("n", "<leader>fa", function()
        builtin.find_files({ hidden = true, no_ignore = true, initial_mode = "insert" })
      end, { desc = "Telescope find all files" })

      -- Resume last search
      vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume last Telescope search" })

      -- Restore telescope state
      vim.keymap.set("n", "<leader>fR", builtin.pickers, { desc = "Restore previous Telescope picker" })

      -- Git pickers
      vim.keymap.set("n", "<leader>tg", builtin.git_status, { desc = "Telescope git status" })
      -- vim.keymap.set("n", "<leader>gh", builtin.git_commits, { desc = "Telescope git commits" })
      -- vim.keymap.set("n", "<leader>gH", builtin.git_bcommits, { desc = "Telescope git buffer commits" })
      vim.keymap.set("n", "<leader>gS", builtin.git_stash, { desc = "Telescope git stash" })

      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("fzf")
    end,
  },
}
