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
					"lua_ls",
					"vtsls",
					"gopls",
					"golangci-lint",
					"typescript-language-server",
					"vue-language-server", -- This installs Volar
					"intelephense",
					"php-cs-fixer",
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

			-- Add folding capabilities for nvim-ufo
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			local lspconfig = require("lspconfig")

			-- Volar configuration for Vue.js
			lspconfig.volar.setup({
				capabilities = capabilities,
				filetypes = { "vue" }, -- Only handle Vue files for better compatibility
				init_options = {
					vue = {
						hybridMode = false, -- Keep false for better file completion and imports
					},
					typescript = {
						tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
					},
				},
			})

			-- TypeScript/JavaScript configuration
			lspconfig.vtsls.setup({
				capabilities = capabilities,
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
				-- Exclude .vue files to let Volar handle them completely
				root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
			})

			-- Lua LSP
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			-- Go LSP
			lspconfig.gopls.setup({
				capabilities = capabilities,
			})

			-- PHP LSP
			lspconfig.intelephense.setup({
				capabilities = capabilities,
			})

			-- Terraform LSP
			lspconfig.terraformls.setup({
				capabilities = capabilities,
			})

			-- CSS LSP
			lspconfig.cssls.setup({
				capabilities = capabilities,
			})

			-- Tailwind CSS LSP
			lspconfig.tailwindcss.setup({
				capabilities = capabilities,
			})

			lspconfig.eslint.setup({
				capabilities = capabilities,
			})

			-- Copilot Language Server
			-- lspconfig.copilot.setup({
			-- 	capabilities = capabilities,
			-- 	cmd = { "copilot-language-server", "--stdio" },
			-- 	filetypes = { "*" },
			-- 	root_dir = lspconfig.util.root_pattern(".git"),
			-- })

			-- Key mappings
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
