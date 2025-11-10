return {
  "mikavilpas/yazi.nvim",
  branch = "main", -- Force main branch for latest updates
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<C-y>",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file",
    },
    {
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Open yazi in nvim's working directory",
    },
  },
  config = function()
    require("yazi").setup({
      open_for_directories = false,
      floating_window_scaling_factor = 0.9,
      yazi_floating_window_border = "rounded",
      keymaps = {
        show_help = "<f1>",
        open_file_in_vertical_split = "<c-v>",
        open_file_in_horizontal_split = "<c-x>",
        open_file_in_tab = "<c-t>",
        send_to_quickfix_list = "<c-q>",
        cycle_open_buffers = "<tab>",
      },
    })
  end,
}