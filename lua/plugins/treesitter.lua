return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			install_dir = vim.fn.stdpath("data") .. "/site",
		})

		require("nvim-treesitter").install({
			"bash",
			"c",
			"cmake",
			"cpp",
			"css",
			"csv",
			"diff",
			"dockerfile",
			"editorconfig",
			"git_config",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
			"go",
			"gomod",
			"gosum",
			"gowork",
			"hcl",
			"html",
			"htmldjango",
			"hyprlang",
			"ini",
			"java",
			"javascript",
			"jsdoc",
			"json",
			"lua",
			"luadoc",
			"luap",
			"make",
			"markdown",
			"markdown_inline",
			"nginx",
			"pem",
			"php",
			"phpdoc",
			"printf",
			"properties",
			"python",
			"query",
			"regex",
			"scss",
			"sql",
			"ssh_config",
			"terraform",
			"toml",
			"tsx",
			"typescript",
			"vim",
			"vimdoc",
			"vue",
			"xml",
			"yaml",
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				if pcall(vim.treesitter.start, args.buf) then
					pcall(function()
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end)
				end
			end,
		})
	end,
}
