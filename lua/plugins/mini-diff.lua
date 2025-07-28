return {
	"echasnovski/mini.diff",
	event = "VeryLazy",
	opts = {
		-- View style for diff visualization
		view = {
			style = "sign", -- Use signs in the gutter
			signs = {
				add = "▎",
				change = "▎",
				delete = "▎", -- Changed from empty string to visible sign
			},
		},

		-- Source configuration (using Git by default)
		source = nil, -- Will use default Git source

		-- Delay before updating diff
		delay = {
			text_change = 200,
		},

		-- Mappings configuration
		mappings = {
			-- Apply hunks
			apply = "gh",
			reset = "gH",

			-- Navigation
			goto_first = "[H",
			goto_prev = "[h",
			goto_next = "]h",
			goto_last = "]H",
		},

		-- Options for diff computation
		options = {
			algorithm = "histogram",
			linematch = 60, -- Hunk size for more granular diff (default: 60)
			wrap_goto = true,
		},
	},

	config = function(_, opts)
		require("mini.diff").setup(opts)

		-- Function to set mini.diff colors
		local function set_mini_diff_colors()
			-- Custom highlight groups - Red for deletions, Yellow for changes, Green for additions
			-- Signs in gutter
			vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#5fb85f" }) -- Medium green for additions
			vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#f9e2af" }) -- Yellow for changes (modifications)
			vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#e85858" }) -- Medium red for deletions

			-- Overlay view colors with gradation based on change intensity
			vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { fg = "#2fb82f", bg = "#0a1f0a" }) -- Dark green (major additions)
			vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { fg = "#d83838", bg = "#1f0a0a" }) -- Dark red (major deletions)
			vim.api.nvim_set_hl(0, "MiniDiffOverChange", { fg = "#f9e2af", bg = "#1f1a0f" }) -- Yellow (modifications)
			vim.api.nvim_set_hl(0, "MiniDiffOverContext", { fg = "#6272a4" }) -- Muted blue-gray for context
			vim.api.nvim_set_hl(0, "MiniDiffOverContextBuf", { fg = "#6272a4" }) -- Muted blue-gray for buffer context
			vim.api.nvim_set_hl(0, "MiniDiffOverChangeBuf", { fg = "#e6d29f", bg = "#1a170a" }) -- Muted yellow for buffer changes
		end

		-- Set colors immediately
		set_mini_diff_colors()

		-- Ensure colors persist after colorscheme changes
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "*",
			callback = set_mini_diff_colors,
		})

		-- Also set colors after Neovim fully starts (to override any late-loading colorscheme settings)
		vim.api.nvim_create_autocmd("VimEnter", {
			pattern = "*",
			callback = function()
				vim.defer_fn(set_mini_diff_colors, 100) -- Small delay to ensure everything is loaded
			end,
		})

		-- Custom keymaps similar to gitsigns
		vim.keymap.set("n", "m", function()
			require("mini.diff").toggle_overlay(0)
		end, { desc = "Toggle diff overlay (preview)" })

		vim.keymap.set("n", "<leader>gd", function()
			require("mini.diff").toggle_overlay(0)
		end, { desc = "Git diff (mini.diff overlay)" })

		-- Navigation without preview
		vim.keymap.set("n", ",", function()
			require("mini.diff").goto_hunk("prev", { wrap = true })
		end, { desc = "Previous hunk" })

		vim.keymap.set("n", ".", function()
			require("mini.diff").goto_hunk("next", { wrap = true })
		end, { desc = "Next hunk" })

		-- Navigation with automatic preview (shift+, and shift+.)
		vim.keymap.set("n", "<", function()
			require("mini.diff").goto_hunk("prev", { wrap = true })
			vim.defer_fn(function()
				require("mini.diff").toggle_overlay(0)
			end, 50)
		end, { desc = "Previous hunk + preview" })

		vim.keymap.set("n", ">", function()
			require("mini.diff").goto_hunk("next", { wrap = true })
			vim.defer_fn(function()
				require("mini.diff").toggle_overlay(0)
			end, 50)
		end, { desc = "Next hunk + preview" })
	end,
}
