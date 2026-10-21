return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"php-cs-fixer",
					"phpcs",
					"phpstan",
					"prettierd",
					"stylua",
					"golangci-lint",
					"local-lua-debugger-vscode",
				},
			})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		opts = {
			-- nomes do lspconfig, nao do mason
			ensure_installed = {
				"lua_ls",
				"vtsls",
				"gopls",
				"vue_ls",
				"intelephense",
				"terraformls",
				"cssls",
				"tailwindcss",
				"eslint",
			},
			-- vim.lsp.enable e chamado manualmente abaixo
			automatic_enable = false,
		},
	},
	{
		-- vim/luv/plugin types for lua_ls when editing this config
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			-- blink.cmp ja injeta as capabilities dele em "*"; aqui so o foldingRange do ufo
			vim.lsp.config("*", {
				capabilities = {
					textDocument = {
						foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
					},
				},
			})

			local vue_language_server_path = vim.fn.stdpath("data")
				.. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

			vim.lsp.config("vtsls", {
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

			-- ESLint (o stylistic do @nuxt/eslint) e o formatter oficial dos projetos
			-- Vue/Nuxt aqui. O vue_ls traz um formatter HTML proprio que reflowa o
			-- <template> inteiro e briga com essas regras, entao ficam so as features
			-- de linguagem dele; formatacao sai.
			vim.lsp.config("vue_ls", {
				on_attach = function(client)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
			})

			vim.lsp.config("intelephense", {
				settings = {
					intelephense = {
						stubs = {
							"apache",
							"bcmath",
							"bz2",
							"calendar",
							"com_dotnet",
							"Core",
							"ctype",
							"curl",
							"date",
							"dba",
							"dom",
							"enchant",
							"exif",
							"FFI",
							"fileinfo",
							"filter",
							"fpm",
							"ftp",
							"gd",
							"gettext",
							"gmp",
							"hash",
							"iconv",
							"imap",
							"intl",
							"json",
							"ldap",
							"libxml",
							"mbstring",
							"meta",
							"mysqli",
							"oci8",
							"odbc",
							"openssl",
							"pcntl",
							"pcre",
							"PDO",
							"pdo_ibm",
							"pdo_mysql",
							"pdo_pgsql",
							"pdo_sqlite",
							"pgsql",
							"Phar",
							"posix",
							"pspell",
							"readline",
							"Reflection",
							"session",
							"shmop",
							"SimpleXML",
							"snmp",
							"soap",
							"sockets",
							"sodium",
							"SPL",
							"sqlite3",
							"standard",
							"superglobals",
							"sysvmsg",
							"sysvsem",
							"sysvshm",
							"tidy",
							"tokenizer",
							"xml",
							"xmlreader",
							"xmlrpc",
							"xmlwriter",
							"xsl",
							"Zend OPcache",
							"zip",
							"zlib",
							"redis",
							"phpunit",
						},
						files = {
							maxSize = 5000000,
						},
					},
				},
			})

			-- Tailwind v4 e CSS-first: @theme, @custom-variant, @utility, @apply e
			-- @source sao at-rules do Tailwind, nao do CSS. O cssls nao conhece
			-- nenhuma delas e marcava todas como "Unknown at rule".
			vim.lsp.config("cssls", {
				settings = {
					css = { lint = { unknownAtRules = "ignore" } },
					scss = { lint = { unknownAtRules = "ignore" } },
					less = { lint = { unknownAtRules = "ignore" } },
				},
			})

			vim.lsp.enable({
				"vtsls",
				"vue_ls",
				"lua_ls",
				"gopls",
				"intelephense",
				"terraformls",
				"cssls",
				"tailwindcss",
				"eslint",
			})

			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>gh", vim.diagnostic.open_float, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})

			-- 0.11+ defaults gr* make `gr` wait timeoutlen before firing
			for _, lhs in ipairs({ "grr", "grn", "gri", "grt", "grx" }) do
				pcall(vim.keymap.del, "n", lhs)
			end
			pcall(vim.keymap.del, { "n", "x" }, "gra")
		end,
	},
}
