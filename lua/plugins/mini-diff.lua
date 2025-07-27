return {
  "echasnovski/mini.diff",
  event = "VeryLazy",
  opts = {
    -- View style for diff visualization
    view = {
      style = "sign", -- Use signs in the gutter
      signs = {
        add = "▎",
        change = "▎",
        delete = "",
      },
    },
    
    -- Source configuration (using Git by default)
    source = nil, -- Will use default Git source
    
    -- Delay before updating diff
    delay = {
      text_change = 200,
    },
    
    -- Mappings configuration
    mappings = {
      -- Apply hunks
      apply = "gh",
      reset = "gH",
      
      -- Navigation
      goto_first = "[H",
      goto_prev = "[h",
      goto_next = "]h",
      goto_last = "]H",
    },
    
    -- Options for diff computation
    options = {
      algorithm = "histogram",
      linematch = 60, -- Hunk size for more granular diff (default: 60)
      wrap_goto = true,
    },
  },
  
  config = function(_, opts)
    require("mini.diff").setup(opts)
    
    -- Custom highlight groups - Red for deletions, Green for additions/changes
    -- Signs in gutter
    vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#5fb85f" })        -- Medium green for additions
    vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#8fdf8f" })     -- Light green for changes (minor modifications)
    vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#e85858" })     -- Medium red for deletions
    
    -- Overlay view colors with gradation based on change intensity
    vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { fg = "#2fb82f", bg = "#0a1f0a" })          -- Dark green (major additions)
    vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { fg = "#d83838", bg = "#1f0a0a" })       -- Dark red (major deletions)
    vim.api.nvim_set_hl(0, "MiniDiffOverChange", { fg = "#7fcf7f", bg = "#0f1f0f" })       -- Medium green (modifications)
    vim.api.nvim_set_hl(0, "MiniDiffOverContext", { fg = "#6272a4" })                      -- Muted blue-gray for context
    vim.api.nvim_set_hl(0, "MiniDiffOverContextBuf", { fg = "#6272a4" })                   -- Muted blue-gray for buffer context
    vim.api.nvim_set_hl(0, "MiniDiffOverChangeBuf", { fg = "#6fbf6f", bg = "#0a1a0a" })    -- Intermediate green for buffer changes
    
    -- Custom keymaps similar to gitsigns
    vim.keymap.set("n", "m", function()
      require("mini.diff").toggle_overlay(0)
    end, { desc = "Toggle diff overlay (preview)" })
    
    vim.keymap.set("n", "<leader>gd", function()
      require("mini.diff").toggle_overlay(0)
    end, { desc = "Git diff (mini.diff overlay)" })
    
    -- Navigation without preview
    vim.keymap.set("n", ",", function()
      require("mini.diff").goto_hunk("prev", { wrap = true })
    end, { desc = "Previous hunk" })
    
    vim.keymap.set("n", ".", function()
      require("mini.diff").goto_hunk("next", { wrap = true })
    end, { desc = "Next hunk" })
    
    -- Navigation with automatic preview (shift+, and shift+.)
    vim.keymap.set("n", "<", function()
      require("mini.diff").goto_hunk("prev", { wrap = true })
      vim.defer_fn(function()
        require("mini.diff").toggle_overlay(0)
      end, 50)
    end, { desc = "Previous hunk + preview" })
    
    vim.keymap.set("n", ">", function()
      require("mini.diff").goto_hunk("next", { wrap = true })
      vim.defer_fn(function()
        require("mini.diff").toggle_overlay(0)
      end, 50)
    end, { desc = "Next hunk + preview" })
  end,
}