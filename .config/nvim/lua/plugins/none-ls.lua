return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- formatters
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.formatting.prettier.with({
					extra_args = { "--tab-width", "4" },
					filetypes = {
						"javascript",
						"typescript",
						"json",
						"yaml",
						"html",
						"css",
						"markdown",
						"json",
						"javascriptreact",
						"typescriptreact",
					},
				}),
				-- diagnostics
				null_ls.builtins.diagnostics.mypy.with({
					extra_args = function()
						local function get_python_path()
							local handle = io.popen("pyenv which python 2>/dev/null")
							if handle then
								local result = handle:read("*a")
								handle:close()
								if result and result ~= "" then
									return result:gsub("%s+$", "")
								end
							end

							local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
							return venv .. "/bin/python"
						end

						local python_path = get_python_path()

						return {
							"--python-executable",
							python_path,
							"--strict-equality",
							"--strict",
							"--extra-checks",
							"--install-types",
						}
					end,
				}),
			},
			-- auto-formatting on save
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format()
						end,
					})
				end
			end,
		})

		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {})
	end,
}
