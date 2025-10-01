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
