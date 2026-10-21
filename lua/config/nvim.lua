vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.title = true

-- Before any <leader> mapping (here and in lazy.lua)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Start Neovim server socket for MCP integration (Claude Code)
if vim.fn.has('unix') == 1 then
  pcall(function() vim.fn.serverstart('/tmp/nvim') end)
end

-- Auto-reload files when modified externally (e.g., by Claude Code)
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  -- checktime raises E11 inside the cmdline window
  command = "if getcmdwintype() == '' | checktime | endif",
})

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "ty", ":bn<CR>")
vim.keymap.set("n", "tr", ":bp<CR>")
vim.keymap.set("n", "tw", ":w<CR>")

vim.keymap.set("n", "tq", ":qa!<CR>")
vim.keymap.set("n", "Q", "<C-w>j:q<CR>")

vim.keymap.set("n", "<leader>lp", ":LspRestart vue_ls<CR>:LspRestart vtsls<CR>")

-- Page up/down with C-u and C-d (also work in insert mode)
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Page down and center
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- Page up and center
vim.keymap.set("i", "<C-d>", "<C-o><C-d><C-o>zz") -- Page down in insert mode
vim.keymap.set("i", "<C-u>", "<C-o><C-u><C-o>zz") -- Page up in insert mode

-- Native commenting (0.10+), treesitter-aware for Vue/injected languages
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
vim.keymap.set("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })

vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -

vim.opt.titlestring = table.concat({
  "%{fnamemodify(getcwd(),':t')}", -- CWD basename
  "%t", -- filename only
}, " -- ")

-- Terminal mode: Super+Left (or º / Alt+\) to exit terminal mode and move to left window
vim.keymap.set("t", "<D-Left>", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "º", "<C-\\><C-N><C-w>h")
vim.keymap.set("t", "<A-\\>", "<C-\\><C-N><C-w>h")

-- Normal mode: Super+Right to focus right window; enter insert if it's a terminal
vim.keymap.set("n", "<D-Right>", function()
  vim.cmd("wincmd l")
  if vim.bo.buftype == "terminal" then
    vim.cmd("startinsert")
  end
end)
