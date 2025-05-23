return {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
        {
            "williamboman/mason-lspconfig.nvim",
            opts = { automatic_installation = true },
        },
    },
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        local python_virtual_env = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"

        local lspconfig = require("lspconfig")
        lspconfig.ts_ls.setup({
            capabilities = capabilities,
        })
        lspconfig.jsonls.setup({
            capabilities = capabilities,
        })
        lspconfig.pyright.setup({
            capabilities = capabilities,
            settings = {
                python = {
                    pythonPath = python_virtual_env .. "/bin/python",
                },
            },
        })
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
        })
        lspconfig.clangd.setup({
            capabilities = capabilities,
        })

        -- get info
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
        -- go to definition
        vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
        -- go to references
        --vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
        vim.keymap.set("n", "<leader>gr", function()
            require("telescope.builtin").lsp_references({})
        end, {})
        -- rename symbol
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})
        -- get code actions
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
}
