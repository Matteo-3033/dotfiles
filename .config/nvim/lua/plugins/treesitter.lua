-- Sintax highlighting and indentation based on language
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")

        config.setup({
            auto_install = true,
            ensure_installed = {
                "lua",
                "javascript",
                "typescript",
                "python",
                "c",
                "cpp",
                "rust",
                "toml",
                "json",
            },
            highlight = { enable = true, disable = { "latex" } },
            indent = { enable = true },
            rainbow = {
                enable = true,
                extended_mode = true,
                max_file_lines = nil,
            },
        })

        -- Folding
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
        vim.wo.foldlevel = 99
    end,
}
