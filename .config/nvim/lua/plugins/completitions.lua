return {
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "hrsh7th/cmp-buffer",
    },
    {
        "hrsh7th/cmp-nvim-lsp-signature-help",
    },
    {
        "hrsh7th/cmp-nvim-lua",
    },
    {
        "hrsh7th/cmp-path",
    },
    {
        "hrsh7th/cmp-vsnip",
    },
    {
        "hrsh7th/vim-vsnip",
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    -- ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    -- ["<Tab>"] = cm-- p.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    }),
                }),
                sources = cmp.config.sources({
                    { name = "path" },          -- file paths
                    { name = "nvim_lsp",               keyword_length = 3 }, -- from language server
                    { name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
                    { name = "nvim_lua",               keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
                    { name = "buffer",                 keyword_length = 2 }, -- source current buffer
                    { name = "vsnip",                  keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
                    { name = "calc" },          -- simple calculator
                    { name = "luasnip" },       -- code snippets
                }),
                formatting = {
                    fields = { "menu", "abbr", "kind" },
                    format = function(entry, item)
                        local menu_icon = {
                            nvim_lsp = "λ",
                            vsnip = "⋗",
                            buffer = "Ω",
                            path = "🖫",
                        }
                        item.menu = menu_icon[entry.source.name]
                        return item
                    end,
                },
            })

            --Set completeopt to have a better completion experience
            -- :help completeopt
            -- menuone: popup even when there's only one match
            -- noinsert: Do not insert text until a selection is made
            -- noselect: Do not select, force to select one from the menu
            -- shortness: avoid showing extra messages when using completion
            -- updatetime: set updatetime for CursorHold
            vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
            vim.opt.shortmess = vim.opt.shortmess + { c = true }
            vim.api.nvim_set_option("updatetime", 300)

            -- Fixed column for diagnostics to appear
            -- Show autodiagnostic popup on cursor hover_range
            -- Goto previous / next diagnostic warning / error
            -- Show inlay_hints more frequently
            vim.cmd([[
                set signcolumn=yes
                autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
            ]])
        end,
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({
                fast_wrap = {},
                disable_filetype = { "TelescopePrompt", "vim" },
            })

            -- setup cmp for autopairs
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
}
