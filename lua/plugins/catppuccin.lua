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
						-- Ensure diff colors are properly set
						DiffAdd = { bg = colors.green, fg = colors.base },
						DiffDelete = { bg = colors.red, fg = colors.base },
						DiffChange = { bg = colors.blue, fg = colors.base },
						DiffText = { bg = colors.sky, fg = colors.base, style = { "bold" } },
						-- Git diff colors
						diffAdded = { fg = colors.green },
						diffRemoved = { fg = colors.red },
						diffChanged = { fg = colors.blue },
						diffOldFile = { fg = colors.red },
						diffNewFile = { fg = colors.green },
					}
				end,
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
