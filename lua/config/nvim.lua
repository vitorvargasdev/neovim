vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set nu")
vim.cmd("set relativenumber")
vim.g.mapleader = " "

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>j")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "ty", ":bn<CR>")
vim.keymap.set("n", "tr", ":bp<CR>")
vim.keymap.set("n", "tw", ":w<CR>")

vim.keymap.set("n", "<leader>c", ":b#|bd#<CR>")
vim.keymap.set("n", "<leader>bC", ":bufdo bd<CR>")

vim.keymap.set("n", "tq", ":qa!<CR>")
