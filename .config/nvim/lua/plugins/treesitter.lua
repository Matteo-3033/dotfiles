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
			--
			-- `markdown`/`markdown_inline` sono esclusi apposta: il pacchetto di
			-- sistema `neovim` su Arch dipende gia' da `tree-sitter-markdown` e
			-- Neovim spedisce le sue query core per markdown in
			-- /usr/share/nvim/runtime/queries/markdown(_inline). Se nvim-treesitter
			-- si compila una sua copia del parser (parser/markdown.so) e la accoppia
			-- alle query del branch `master` (legacy, non piu' sincronizzato 1:1 con
			-- la grammatica upstream), capture/nodi non combaciano piu' e
			-- l'highlighter va in crash ad ogni redraw con
			-- "attempt to call method 'range' (a nil value)" — cioe' il "mare di
			-- errori" che si vede aprendo un .md. Lasciando la coppia
			-- parser+query di sistema (gia' compatibile) il problema sparisce.
			ignore_install = { "latex", "markdown", "markdown_inline" },
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
