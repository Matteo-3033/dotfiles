return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "tpope/vim-fugitive",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()

            require("nvim-dap-virtual-text").setup({
                only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
                all_references = false, -- show virtual text on all all references of the variable (not only definitions)
                clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)

                -- experimental features:
                all_frames = true, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
            })

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            -- dap.listeners.before.event_terminated.dapui_config = function()
            --     dapui.close()
            -- end
            -- dap.listeners.before.event_exited.dapui_config = function()
            --     dapui.close()
            -- end

            vim.keymap.set("n", "<Leader>db", ":DapToggleBreakpoint<CR>", { desc = "Toggle Breakpoint" })
            vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>", { desc = "Continue" })
            vim.keymap.set("n", "<Leader>dt", ":DapTerminate<CR>", { desc = "Terminate" })
            vim.keymap.set("n", "<Leader>do", ":DapStepOver<CR>", { desc = "Step Over" })
            vim.api.nvim_set_keymap(
                "n",
                "<Leader>dd",
                ':lua require("dapui").close()<CR>',
                { noremap = true, silent = true, desc = "Close DAP UI" }
            )
        end,
    },
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            local dap = require("dap")
            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    justMyCode = false,
                    stopOnEntry = true,
                    console = "integratedTerminal",
                },
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file with arguments",
                    program = "${file}",
                    justMyCode = false,
                    args = function()
                        local args_string = vim.fn.input("Arguments: ")
                        return vim.split(args_string, " ")
                    end,
                    stopOnEntry = true,
                    console = "integratedTerminal",
                },
            }

            local venv = "~/.local/share/nvim/python/bin/python"

            require("dap-python").setup(venv, {
                include_configs = false,
            })
        end,
    },
}
