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
			},
			highlight = { enable = true, disable = { "latex" } },
			indent = { enable = true },
		})
	end,
}
