-- Catppuccin colorscheme
return {
    "catppuccin/nvim",
    as = "catppuccin",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            flavour = "macchiato",
        })
        vim.cmd.colorscheme("catppuccin")
    end,
}
