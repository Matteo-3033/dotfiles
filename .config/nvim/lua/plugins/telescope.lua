-- Search panel for files and text
return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
        config = function()
            local builtin = require("telescope.builtin")
            local actions = require("telescope.actions")
            vim.keymap.set("n", "<C-p>", builtin.find_files, {})
            vim.keymap.set("n", "<leader>lg", builtin.live_grep, {})

            require("telescope").setup({
                defaults = {
                    preview = {
                        mime_hook = function(filepath, bufnr, opts)
                            if Snacks.image.supports_file(filepath) then
                                Snacks.image.buf.attach(bufnr, { src = filepath })
                            else
                                require("telescope.previewers.utils").set_preview_message(
                                    bufnr,
                                    opts.winid,
                                    "Binary cannot be previewed"
                                )
                            end
                        end,
                    },
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close,
                        },
                    },
                    file_ignore_patterns = { "node_modules", ".git", "build/", "%.class" },
                },
            })
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
}
