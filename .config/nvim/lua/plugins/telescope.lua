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
                            local is_image = function(filepath)
                                local image_extensions = { "png", "jpg", "jpeg", "gif" } -- Supported image formats
                                local split_path = vim.split(filepath:lower(), ".", { plain = true })
                                local extension = split_path[#split_path]
                                return vim.tbl_contains(image_extensions, extension)
                            end
                            if is_image(filepath) then
                                local term = vim.api.nvim_open_term(bufnr, {})
                                local function send_output(_, data, _)
                                    for _, d in ipairs(data) do
                                        vim.api.nvim_chan_send(term, d .. "\r\n")
                                    end
                                end

                                vim.fn.jobstart({
                                    "viu",
                                    "-w",
                                    "48",
                                    "-b",
                                    filepath,
                                }, {
                                    on_stdout = send_output,
                                    stdout_buffered = true,
                                })
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
