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
				null_ls.builtins.formatting.phpcsfixer.with({
					condition = function(utils)
						return utils.has_file({ ".php-cs-fixer.php", ".php-cs-fixer.dist.php" })
					end,
				}),
				null_ls.builtins.diagnostics.golangci_lint,
				null_ls.builtins.diagnostics.phpcs.with({
					condition = function(utils)
						return utils.has_file({ "phpcs.xml", "phpcs.xml.dist", ".phpcs.xml", ".phpcs.xml.dist" })
					end,
				}),
				null_ls.builtins.diagnostics.phpstan.with({
					condition = function(utils)
						return utils.has_file({ "phpstan.neon", "phpstan.neon.dist", "phpstan.dist.neon" })
					end,
				}),
			},
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		vim.keymap.set("n", "<leader>ge", "<cmd>LspEslintFixAll<CR>", { desc = "ESLint fix all" })
	end,
}
