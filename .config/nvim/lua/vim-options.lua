-- Style
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=3")
vim.cmd("set number relativenumber")
vim.cmd("set cursorline")
vim.cmd("set ignorecase")
vim.cmd("set smartcase")

vim.cmd("set ai")
vim.cmd("set si")
vim.cmd("set et")
vim.cmd("set sr")
vim.cmd("set sts=4")
vim.cmd("set sw=4")

vim.g.mapleader = " "

vim.api.nvim_set_option("clipboard", "unnamed")

-- Python path
vim.g.python3_host_prog = "~/.local/share/nvim/python/bin/python"

-- Navigation
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
vim.cmd(":map <Up> <Nop>")
vim.cmd(":map <Left> <Nop>")
vim.cmd(":map <Right> <Nop>")
vim.cmd(":map <Down> <Nop>")

-- New line without entering insert mode
vim.keymap.set("n", "<leader>o", "o<Esc>")
vim.keymap.set("n", "<leader>O", "O<Esc>")

-- Inline errors
vim.diagnostic.config({
    virtual_text = {
        prefix = "●", -- o '■', '▶', '»', oppure lascia vuoto ""
        spacing = 2,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
vim.keymap.set("n", "<leader>xd", function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
end, { desc = "Show diagnostics under cursor" })
vim.keymap.set("n", "<leader>xp", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "<leader>xn", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
