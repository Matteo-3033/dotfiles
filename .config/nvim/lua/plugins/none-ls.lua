return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = {
				-- formatters
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.black,
				null_ls.builtins.formatting.isort,
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.formatting.sql_formatter.with({
					command = { "sleek" },
					extra_args = {
						"--indent-spaces",
						"4",
						"--uppercase",
						"true",
						"--lines-between-queries",
						"2",
						"--trailing-newline",
						"true",
					},
				}),
				null_ls.builtins.formatting.prettier.with({
					extra_args = {
						"--tab-width",
						"4",
						"--print-width",
						"120",
						"--arrow-parens",
						"avoid",
						"--trailing-comma",
						"none",
					},
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
					extra_args = function(params)
						local python_path = require("python-path").get(params and params.root)

						-- https://mypy.readthedocs.io/en/stable/command_line.html
						return {
							"--python-executable",
							python_path,
							"--strict-equality",
							"--strict-equality-for-none",
							"--warn-unreachable",
							-- "--check-untyped-defs",
							"--disallow-untyped-decorators",
							"--implicit-optional",
							"--warn-redundant-casts",
							"--warn-unused-ignores",
							"--warn-return-any",
							"--no-implicit-reexport",
							-- "--strict",
							"--extra-checks",
							"--install-types",
							"--disable-error-code=import-untyped",
						}
					end,
				}),
			},
			-- auto-formatting on save
			on_attach = function(client, bufnr)
				if client:supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ bufnr = bufnr })
						end,
					})
				end
			end,
		})

		vim.keymap.set("n", "<leader>f", function()
			vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
		end, { desc = "Format file" })
	end,
}
