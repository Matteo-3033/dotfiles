-- Floating terminal
-- Press <leader>tt to toggle the terminal
return {
    "voldikss/vim-floaterm",
    config = function()
        vim.keymap.set("n", "<leader>tt", ":FloatermToggle<CR>", { noremap = true, silent = true })
        vim.keymap.set("t", "<leader>tt", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true, silent = true })
    end,
}
