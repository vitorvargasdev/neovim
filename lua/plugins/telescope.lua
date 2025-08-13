return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
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

          -- Preview settings
          preview = {
            treesitter = true,
          },

          -- Colors and icons
          color_devicons = true,

          -- Better performance
          file_sorter = require("telescope.sorters").get_fuzzy_file,
          generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,

          -- Mappings
          mappings = {
            n = {
              ["q"] = require("telescope.actions").close,
              ["e"] = false, -- Disable 'e' key in all pickers
              ["l"] = require("telescope.actions").select_default,
              ["h"] = require("telescope.actions").close,
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
          file_browser = {
            initial_mode = "normal",
            grouped = true, -- Group folders before files
            files = true, -- Show both files and folders
            dir_icon = "󰉋", -- Nerd font folder icon
            display_stat = false,
            git_status = true, -- Show git status indicators
            sorting_strategy = "ascending", -- Show results from top to bottom
            mappings = {
              ["n"] = {
                ["l"] = require("telescope.actions").select_default,
                ["h"] = require("telescope").extensions.file_browser.actions.goto_parent_dir,
                ["q"] = require("telescope.actions").close,
                ["e"] = false, -- Disable 'e' key to prevent conflicts
              },
            },
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
      vim.keymap.set("n", "<leader>fa", ":Telescope find_files hidden=true no_ignore=true<CR>")

      -- Resume last search
      vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume last Telescope search" })

      -- Git pickers
      vim.keymap.set("n", "<S-M>", builtin.git_status, { desc = "Telescope git status" })
      vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Telescope git branches" })
      vim.keymap.set("n", "<leader>gh", builtin.git_commits, { desc = "Telescope git commits" })
      vim.keymap.set("n", "<leader>gH", builtin.git_bcommits, { desc = "Telescope git buffer commits" })
      vim.keymap.set("n", "<leader>gS", builtin.git_stash, { desc = "Telescope git stash" })

      -- File browser keymaps
      vim.keymap.set(
        "n",
        "<leader>e",
        ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
        { desc = "File Explorer" }
      )
      vim.keymap.set("n", "<leader>E", ":Telescope file_browser<CR>", { desc = "Explorer root" })

      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("fzf")
    end,
  },
}
