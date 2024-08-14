vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=3")
vim.cmd("set number relativenumber")
vim.cmd("set cursorline")
vim.cmd("set ignorecase")
vim.cmd("set smartcase")

vim.cmd(":map <Up> <Nop>")
vim.cmd(":map <Left> <Nop>")
vim.cmd(":map <Right> <Nop>")
vim.cmd(":map <Down> <Nop>")

vim.cmd("set ai")
vim.cmd("set si")
vim.cmd("set et")
vim.cmd("set sr")
vim.cmd("set sts=4")
vim.cmd("set sw=4")

vim.g.mapleader = " "

vim.api.nvim_set_option("clipboard", "unnamed")

vim.g.python3_host_prog = "~/.local/share/nvim/python/bin/python"

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
