return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.keymap.set("n", "<C-n>", ":Neotree filesystem toggle left<CR>", {})
		-- vim.cmd(":Neotree filesystem reveal left")
		require("neo-tree").setup({
			filesystem = {
				window = {
					mappings = {
						["o"] = "system_open",
					},
				},
				commands = {
					system_open = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						-- macOs: open file in default application in the background.
						vim.fn.jobstart({ "xdg-open", "-g", path }, { detach = true })
						-- Linux: open file in default application
						vim.fn.jobstart({ "xdg-open", path }, { detach = true })
					end,
				},
			},
		})
	end,
}
