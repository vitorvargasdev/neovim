return {
	"lewis6991/gitsigns.nvim",
	event = "VeryLazy",
	config = function()
		require("gitsigns").setup({
			-- mini.diff owns the gutter signs; gitsigns here only for blame
			signcolumn = false,
			numhl = false,
			linehl = false,
			word_diff = false,

			-- Passive virtual-text blame on the current line (always on)
			current_line_blame = true, -- toggle with <leader>gB
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol",
				delay = 300,
				ignore_whitespace = false,
			},
			current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		})

		local gs = require("gitsigns")

		-- Floating popup blame for the line under the cursor (gitsigns style)
		vim.keymap.set("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end, { desc = "Git blame line (popup)" })

		-- Toggle passive virtual-text blame on the current line
		vim.keymap.set("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "Toggle inline blame" })
	end,
}
