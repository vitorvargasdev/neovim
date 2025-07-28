return {
	{
		"tpope/vim-fugitive",
		config = function()
			-- Git blame using fugitive
			vim.keymap.set("n", "<leader>gt", ":Git blame<CR>", { desc = "Git blame (fugitive)" })
			vim.keymap.set("n", "<leader>gr", ":e!<CR>", { desc = "Refresh current buffer" })
			
			-- Additional useful fugitive commands
			vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
			vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<CR>", { desc = "Git diff split" })
			vim.keymap.set("n", "<leader>gl", ":Git log --oneline<CR>", { desc = "Git log" })
			vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
		end,
	},
	-- Gitsigns disabled in favor of mini.diff
	-- {
	--   "lewis6991/gitsigns.nvim",
	--   config = function()
	--     require("gitsigns").setup()
	--
	--     vim.keymap.set("n", "<leader>gt", ":Gitsigns blame_line<CR>", { desc = "Git blame line" })
	--     vim.keymap.set("n", "<leader>gr", ":Gitsigns refresh<CR>", { desc = "Refresh gitsigns" })
	--   end
	-- }
}