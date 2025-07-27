return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				-- null_ls.builtins.formatting.prettier,
				null_ls.builtins.formatting.prettierd.with({
					condition = function(utils)
						return utils.has_file({ ".prettierrc.js" })
					end,
				}),
				null_ls.builtins.diagnostics.golangci_lint,
				require("none-ls.diagnostics.eslint_d"), -- requires none-ls-extras.nvim
				-- null_ls.builtins.diagnostics.phpcs,
				null_ls.builtins.diagnostics.phpstan,
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		vim.keymap.set("n", "<leader>gc", ":EslintFixAll<CR>")
	end,
}
