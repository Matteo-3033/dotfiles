local function on_save()
	vim.lsp.buf.format()
end

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*.rs", -- Pattern per i file Rust
	callback = on_save, -- Callback alla funzione on_save
})
