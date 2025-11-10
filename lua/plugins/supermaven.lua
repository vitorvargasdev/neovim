return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<C-/>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-.>",
      },
      ignore_filetypes = {
        yaml = true,
        markdown = true,
        help = true,
        gitcommit = true,
        gitrebase = true,
        hgcommit = true,
        svn = true,
        cvs = true,
      },
      color = {
        suggestion_color = "#808080",
        cterm = 244,
      },
      log_level = "info",
      disable_inline_completion = false,
      disable_keymaps = false,
    })
  end,
}
