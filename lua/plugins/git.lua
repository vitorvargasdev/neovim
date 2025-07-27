return {
  {
    "tpope/vim-fugitive"
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()

      vim.keymap.set("n", "<leader>gt", ":Gitsigns blame_line<CR>", { desc = "Git blame line" })
      vim.keymap.set("n", "<leader>gr", ":Gitsigns refresh<CR>", { desc = "Refresh gitsigns" })
    end
  }
}
