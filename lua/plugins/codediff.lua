return {
	"esmuellert/codediff.nvim",
	cmd = "CodeDiff",
	keys = {
		{
			"<leader>cd",
			"<cmd>CodeDiff<cr>",
			mode = { "n", "v" },
			desc = "Open CodeDiff (git status explorer)",
		},
	},
	opts = {
		diff = {
			layout = "side-by-side",
		},
		explorer = {
			position = "left",
			width = 40,
			view_mode = "tree",
			auto_refresh = false, -- evita rebuild do tree a cada Tab (BufEnter); use R pra atualizar
		},
		keymaps = {
			view = {
				next_file = "<Tab>",
				prev_file = "<S-Tab>",
			},
		},
	},
}
