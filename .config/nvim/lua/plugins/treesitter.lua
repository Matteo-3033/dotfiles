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
				"html",
				"css",
				"markdown_inline",
				"markdown",
				"tsx",
				"norg",
				"scss",
				"svelte",
				"typst",
				"vue",
				"regex",
			},
			-- Il parser `latex` non ha binari precompilati compatibili: va rigenerato
			-- con il CLI `tree-sitter`, cosa che blocca l'avvio per minuti. Dato che
			-- l'highlight latex e' comunque disattivato qui sotto, lo escludiamo del
			-- tutto (anche da `auto_install`, che altrimenti ritenta all'apertura di
			-- un .tex). Per installarlo a mano: `:TSInstall latex`.
			ignore_install = { "latex" },
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
