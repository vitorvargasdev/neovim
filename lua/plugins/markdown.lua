return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = "markdown",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("render-markdown").setup({
				enabled = true,
				preset = "lazy",
				heading = {
					enabled = true,
					icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
				},
				code = {
					enabled = true,
					sign = false,
					width = "block",
					right_pad = 1,
				},
				bullet = {
					enabled = true,
					icons = { "•", "◦", "▸", "▹" },
				},
				checkbox = {
					enabled = true,
					unchecked = { icon = "☐ " },
					checked = { icon = "✔ " },
				},
				quote = {
					enabled = true,
					icon = "▎",
				},
				pipe_table = {
					enabled = true,
					style = "normal",
				},
			})
		end,
	},
}
