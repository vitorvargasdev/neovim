return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					initial_mode = "normal",
					mappings = {
						n = {
							["q"] = require("telescope.actions").close,
							["e"] = false,  -- Disable 'e' key in all pickers
							["l"] = require("telescope.actions").select_default,
							["h"] = require("telescope.actions").close,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
					file_browser = {
						initial_mode = "normal",
						grouped = true,  -- Group folders before files
						files = true,    -- Show both files and folders
						dir_icon = "󰉋",  -- Nerd font folder icon
						display_stat = false,
						git_status = true,  -- Show git status indicators
						sorting_strategy = "ascending",  -- Show results from top to bottom
						mappings = {
							["n"] = {
								["l"] = require("telescope.actions").select_default,
								["h"] = require("telescope").extensions.file_browser.actions.goto_parent_dir,
								["q"] = require("telescope.actions").close,
								["e"] = false,  -- Disable 'e' key to prevent conflicts
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
			vim.keymap.set("n", "<S-M>", builtin.git_status, { desc = "Telescope git changes" })

			-- File browser keymaps
			vim.keymap.set("n", "<leader>e", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { desc = "File Explorer" })
			vim.keymap.set("n", "<leader>E", ":Telescope file_browser<CR>", { desc = "Explorer root" })

			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("file_browser")
		end,
	},
}
