return {
	{
		"tpope/vim-fugitive",
		cmd = { "G", "Git", "Gvdiffsplit", "Gdiffsplit", "Gread", "Gwrite", "GBrowse" },
		keys = {
			{ "<leader>gt", "<cmd>Git blame<CR>", desc = "Git blame (fugitive)" },
			{ "<leader>gr", "<cmd>e!<CR>", desc = "Refresh current buffer" },
			{ "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
			{ "<leader>gd", "<cmd>Gvdiffsplit<CR>", desc = "Git diff split" },
			{ "<leader>gl", "<cmd>Git log --oneline<CR>", desc = "Git log" },
			{ "<leader>gc", "<cmd>Git commit<CR>", desc = "Git commit" },
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles" },
		keys = {
			{
				"M",
				function()
					local lib = require("diffview.lib")
					-- drop views whose tab was closed by hand
					lib.dispose_stray_views()
					if lib.get_current_view() then
						vim.cmd("DiffviewClose")
					elseif lib.views[1] then
						-- a view is open in another tab: jump to it instead of opening a second one
						vim.api.nvim_set_current_tabpage(lib.views[1].tabpage)
					else
						vim.cmd("DiffviewOpen")
					end
				end,
				desc = "Diffview Toggle",
			},
		},
		config = function()
			local actions = require("diffview.actions")
			local lib = require("diffview.lib")

			-- goto_file_edit leaves the Diffview tab, so grab the view before it
			local function open_and_close()
				local view = lib.get_current_view()
				actions.goto_file_edit()
				if view then
					view:close()
					lib.dispose_view(view)
				end
			end

			require("diffview").setup({
				keymaps = {
					file_panel = {
						{
							"n",
							"gf",
							open_and_close,
							{ desc = "Open file and close Diffview" },
						},
					},
					view = {
						{
							"n",
							"gf",
							open_and_close,
							{ desc = "Open file and close Diffview" },
						},
					},
				},
			})
		end,
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<CR>", desc = "Open Neogit" },
			{ "<leader>gn", "<cmd>Neogit commit<CR>", desc = "Neogit commit" },
		},
		opts = {
			integrations = {
				telescope = true,
				diffview = true,
			},
		},
	},
}
