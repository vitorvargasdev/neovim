return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    config = function()
      -- Fold options
      vim.o.foldcolumn = "1"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Keymaps for folding
      vim.keymap.set("n", "<leader>zo", require("ufo").openAllFolds, { desc = "Open all folds" })
      vim.keymap.set("n", "<leader>zc", require("ufo").closeAllFolds, { desc = "Close all folds" })
      
      -- Toggle fold at cursor - using native za but with easier keybind
      vim.keymap.set("n", "<Space><Space>", "za", { desc = "Toggle fold at cursor" })

      -- Setup ufo
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "lsp", "indent" }
        end,
      })
    end,
  },
}