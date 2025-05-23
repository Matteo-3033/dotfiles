return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"tpope/vim-fugitive",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("dapui").setup()

			local dap, dapui = require("dap"), require("dapui")

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

			vim.keymap.set("n", "<Leader>db", ":DapToggleBreakpoint<CR>")
			vim.keymap.set("n", "<Leader>dc", ":DapContinue<CR>")
			vim.keymap.set("n", "<Leader>dt", ":DapTerminate<CR>")
			vim.keymap.set("n", "<Leader>do", ":DapStepOver<CR>")
			vim.api.nvim_set_keymap(
				"n",
				"<Leader>dd",
				':lua require("dapui").close()<CR>',
				{ noremap = true, silent = true }
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
