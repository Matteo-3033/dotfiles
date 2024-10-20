return {
	"voldikss/vim-floaterm",
	config = function()
		vim.keymap.set("n", "<leader>t", ":FloatermToggle<CR>", { noremap = true, silent = true })
		vim.keymap.set("t", "<leader>t", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true, silent = true })
	end,
}
