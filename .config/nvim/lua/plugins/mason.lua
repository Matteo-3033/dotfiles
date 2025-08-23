return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    config = function()
        local ensure_installed = {
            "prettier",
            "stylua",
            "black",
            "isort",
            "clang-format",
            "ruff",
            "mypy",
            "flake8",
            "clangd",
            "codelldb",
            "css-lsp",
            "debugpy",
            "eslint-lsp",
            "html-lsp",
            "json-lsp",
            "lua-language-server",
            "markuplint",
            "pyright",
            "stylelint",
            "typescript-language-server",
        }
        require("mason").setup({
            ensure_installed = ensure_installed,
        })

        vim.api.nvim_create_user_command("MasonInstallAll", function()
            vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end, {})

        vim.g.mason_binaries_list = ensure_installed
    end,
}
