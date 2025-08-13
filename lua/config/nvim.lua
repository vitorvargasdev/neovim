vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set nu")
vim.cmd("set relativenumber")
vim.cmd("set ignorecase")
vim.cmd("set smartcase")
-- vim.cmd("set splitbelow")
vim.cmd("set splitright")
vim.cmd("set title")

-- Line ending settings to prevent ^M characters
vim.opt.fileformats = "unix,dos"  -- Prefer Unix line endings
vim.opt.fileformat = "unix"       -- Use Unix line endings for new files

vim.g.mapleader = " "

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<Esc>", ":noh<CR>")

vim.keymap.set("n", "ty", ":bn<CR>")
vim.keymap.set("n", "tr", ":bp<CR>")
vim.keymap.set("n", "tw", ":w<CR>")

vim.keymap.set("n", "<leader>dd", ":bd<CR>")
vim.keymap.set("n", "<leader>daa", ":bufdo bd<CR>")

vim.keymap.set("n", "tq", ":qa!<CR>")

vim.keymap.set("n", "<leader>lp", ":LspRestart volar<CR>:LspRestart vtsls<CR>")

-- Avante keymaps
vim.keymap.set("n", "<leader>avm", ":AvanteModels<CR>")
vim.keymap.set("n", "<leader>avc", ":AvanteClear<CR>")

vim.keymap.set("n", "=", [[<cmd>vertical resize +5<cr>]]) -- make the window biger vertically
vim.keymap.set("n", "-", [[<cmd>vertical resize -5<cr>]]) -- make the window smaller vertically
vim.keymap.set("n", "+", [[<cmd>horizontal resize +2<cr>]]) -- make the window bigger horizontally by pressing shift and =
vim.keymap.set("n", "_", [[<cmd>horizontal resize -2<cr>]]) -- make the window smaller horizontally by pressing shift and -

vim.opt.titlestring = table.concat({
  "%{fnamemodify(getcwd(),':t')}",    -- CWD basename :contentReference[oaicite:0]{index=0}
  "%t",                               -- filename only :contentReference[oaicite:1]{index=1}
}, " -- ")
