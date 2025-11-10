return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup({
      use_icons = true,
      enhanced_diff_hl = true,
      git_cmd = { "git" },
      hooks = {
        diff_buf_read = function(bufnr)
          -- Better diff highlighting
          vim.opt_local.wrap = false
          vim.opt_local.list = false
          
          -- Override diff colors for this buffer with GitHub style
          vim.api.nvim_set_hl(0, 'DiffAdd', { bg = '#1a3b2e' })
          vim.api.nvim_set_hl(0, 'DiffDelete', { bg = '#3d1e20' })
          vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#1f2d3d' })
          vim.api.nvim_set_hl(0, 'DiffText', { bg = '#365a7a', bold = true })
        end,
      },
    })
    
    -- Toggle function for diffview
    local function toggle_diffview()
      local view = require("diffview.lib").get_current_view()
      if view then
        vim.cmd("DiffviewClose")
      else
        vim.cmd("DiffviewOpen")
      end
    end
    
    -- Toggle function for file panel
    local function toggle_files_panel()
      local view = require("diffview.lib").get_current_view()
      if view then
        if view.panel and view.panel.focused then
          view.panel:toggle(false)
        else
          vim.cmd("DiffviewToggleFiles")
        end
      end
    end
    
    -- Keymaps for diffview
    vim.keymap.set("n", "M", toggle_diffview, { desc = "Toggle diffview", silent = true })
    vim.keymap.set("n", "F", ":DiffviewToggleFiles<CR>", { desc = "Toggle diffview files panel", silent = true })
    vim.keymap.set("n", "<leader>dv", ":DiffviewOpen<CR>", { desc = "Open diffview" })
    vim.keymap.set("n", "<leader>dc", ":DiffviewClose<CR>", { desc = "Close diffview" })
    vim.keymap.set("n", "<leader>dh", ":DiffviewFileHistory %<CR>", { desc = "File history" })
    vim.keymap.set("n", "<leader>df", ":DiffviewFocusFiles<CR>", { desc = "Focus files panel" })
  end,
}
