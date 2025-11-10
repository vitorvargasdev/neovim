return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				integrations = {
					gitsigns = false, -- We're using mini.diff instead
					native_lsp = {
						enabled = true,
					},
					telescope = {
						enabled = true,
						style = "nvchad",
					},
				},
				custom_highlights = function(colors)
					return {
						-- GitHub-style diff colors with better visibility
						DiffAdd = { bg = "#1a3b2e", fg = colors.text },
						DiffDelete = { bg = "#3d1e20", fg = colors.text },
						DiffChange = { bg = "#1f2d3d", fg = colors.text },
						DiffText = { bg = "#365a7a", fg = colors.text, style = { "bold" } },
						-- Git diff colors for inline diffs
						diffAdded = { fg = "#3fb950", style = { "bold" } },
						diffRemoved = { fg = "#f85149", style = { "bold" } },
						diffChanged = { fg = "#d29922" },
						diffOldFile = { fg = "#f85149" },
						diffNewFile = { fg = "#3fb950" },
						diffLine = { fg = "#58a6ff" },
						diffFile = { fg = "#d29922", style = { "bold" } },
						-- Diffview specific highlights
						DiffviewDiffAddAsDelete = { bg = "#3d1e20", fg = colors.text },
						DiffviewDiffDelete = { bg = "#3d1e20", fg = "#f85149" },
						DiffviewDiffAdd = { bg = "#1a3b2e", fg = "#3fb950" },
						DiffviewDiffChange = { bg = "#1f2d3d", fg = "#d29922" },
					}
				end,
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
