return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({})
		end,
	},
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua-language-server",
					"vtsls",
					"gopls",
					"vue-language-server",
					"intelephense",
					"terraform-ls",
					"css-lsp",
					"tailwindcss-language-server",
					"eslint-lsp",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			local vue_language_server_path = vim.fn.stdpath("data")
				.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

			vim.lsp.config("vtsls", {
				capabilities = capabilities,
				settings = {
					vtsls = {
						tsserver = {
							globalPlugins = {
								{
									name = "@vue/typescript-plugin",
									location = vue_language_server_path,
									languages = { "vue" },
									configNamespace = "typescript",
								},
							},
						},
					},
				},
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			})

			vim.lsp.config("vue_ls", {
				capabilities = capabilities,
			})

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
			})

			vim.lsp.config("gopls", {
				capabilities = capabilities,
			})

			vim.lsp.config("intelephense", {
				capabilities = capabilities,
			})

			vim.lsp.config("terraformls", {
				capabilities = capabilities,
			})

			vim.lsp.config("cssls", {
				capabilities = capabilities,
			})

			vim.lsp.config("tailwindcss", {
				capabilities = capabilities,
			})

			vim.lsp.config("eslint", {
				capabilities = capabilities,
			})

			vim.lsp.enable("vtsls")
			vim.lsp.enable("vue_ls")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("gopls")
			vim.lsp.enable("intelephense")
			vim.lsp.enable("terraformls")
			vim.lsp.enable("cssls")
			vim.lsp.enable("tailwindcss")
			vim.lsp.enable("eslint")

			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "gh", vim.diagnostic.open_float, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "<leader>gh", vim.diagnostic.open_float, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
		end,
	},
}
