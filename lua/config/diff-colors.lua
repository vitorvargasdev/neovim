-- Configure diff colors to show deletions as red and additions as green
local M = {}

function M.setup()
	-- Set up autocmd to apply after colorscheme loads
	vim.api.nvim_create_autocmd("ColorScheme", {
		pattern = "*",
		callback = function()
			-- Diff colors for split views (like :Gvdiffsplit)
			vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#1e3a1e", fg = "#5fb85f" }) -- Green background for additions
			vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#3a1e1e", fg = "#e85858" }) -- Red background for deletions
			vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1e2a3a", fg = "#8fbfdf" }) -- Blue background for changes
			vim.api.nvim_set_hl(0, "DiffText", { bg = "#2e3a4a", fg = "#afdfff", bold = true }) -- Highlighted changed text

			-- Git diff colors (for fugitive and other git integration)
			vim.api.nvim_set_hl(0, "diffAdded", { fg = "#5fb85f" }) -- Green for added lines
			vim.api.nvim_set_hl(0, "diffRemoved", { fg = "#e85858" }) -- Red for removed lines
			vim.api.nvim_set_hl(0, "diffChanged", { fg = "#8fbfdf" }) -- Blue for changed lines
			vim.api.nvim_set_hl(0, "diffOldFile", { fg = "#e85858" }) -- Red for old file
			vim.api.nvim_set_hl(0, "diffNewFile", { fg = "#5fb85f" }) -- Green for new file
			vim.api.nvim_set_hl(0, "diffFile", { fg = "#8fbfdf", bold = true }) -- Blue for file names
			vim.api.nvim_set_hl(0, "diffLine", { fg = "#6272a4" }) -- Gray for line numbers
			vim.api.nvim_set_hl(0, "diffIndexLine", { fg = "#bd93f9" }) -- Purple for index line
			vim.api.nvim_set_hl(0, "diffSubname", { fg = "#f8f8f2" }) -- White for subnames

			-- Additional git-related highlights
			vim.api.nvim_set_hl(0, "gitcommitSelectedFile", { fg = "#5fb85f" }) -- Green for selected files
			vim.api.nvim_set_hl(0, "gitcommitDiscardedFile", { fg = "#e85858" }) -- Red for discarded files
			vim.api.nvim_set_hl(0, "gitcommitUntrackedFile", { fg = "#f1fa8c" }) -- Yellow for untracked
			vim.api.nvim_set_hl(0, "gitcommitDiff", { fg = "#8fbfdf" }) -- Blue for diff sections

			-- Ensure these colors persist even with different colorschemes
			vim.api.nvim_set_hl(0, "Added", { fg = "#5fb85f" })
			vim.api.nvim_set_hl(0, "Removed", { fg = "#e85858" })
			vim.api.nvim_set_hl(0, "Changed", { fg = "#8fbfdf" })
		end,
	})

	-- Apply colors immediately for current colorscheme
	vim.cmd("doautocmd ColorScheme")
end

return M