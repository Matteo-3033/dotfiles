-- Floating terminal
-- Press <leader>tt to toggle the terminal
return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = { --[[ things you want to change go here]]
		},
		config = function()
			require("toggleterm").setup({
				size = 10,
				direction = "float", -- float | horizontal | vertical | tab
				float_opts = {
					border = "curved",
				},
			})

			local Terminal = require("toggleterm.terminal").Terminal
			local float_term = Terminal:new({ id = 1, direction = "float" })

			local toggle_float = function()
				float_term:toggle()
			end

			-- mapping sia in normal che in terminal mode
			vim.keymap.set("n", "<leader>tt", toggle_float, { desc = "Toggle floating terminal" })
			vim.keymap.set(
				"t",
				"<leader>tt",
				[[<C-\><C-n><cmd>lua require("toggleterm.terminal").get(1):toggle()<CR>]],
				{ desc = "Toggle floating terminal" }
			)
		end,
	},
}
