return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 2 } },
				{ section = "startup" },
			},
		},
		explorer = { enabled = true },
		-- `doc.enabled` fa scansionare a snacks (via treesitter, in modo asincrono)
		-- ogni buffer aperto alla ricerca di link a immagini per l'anteprima al
		-- cursore. Su Neovim 0.12 questo parsing asincrono va in race con quello
		-- dell'highlighter e crasha (v. commento in indent.scope sotto). La
		-- renderizzazione immagini vera e propria (:h snacks-image) resta attiva.
		image = { enabled = true, doc = { enabled = false } },
		-- `scope.async = false`: come sopra, evita il parsing treesitter asincrono
		-- che va in race con l'highlighter e causa
		-- "attempt to call method 'range' (a nil value)" ad ogni apertura di un
		-- file con parser/injection piu' complessi (es. markdown con code fence).
		indent = { enabled = true, scope = { async = false } },
		input = { enabled = true },
		picker = {
			enabled = true,
			-- sostituisce `vim.ui.select` (menu code action, ecc.) al posto
			-- dell'estensione telescope-ui-select. E' gia' true di default, esplicito
			-- solo per chiarezza.
			ui_select = true,
			-- Esc closes the picker instead of just leaving insert mode
			-- (default behavior, see comment in snacks.picker.config.defaults).
			win = {
				input = { keys = { ["<Esc>"] = { "close", mode = { "n", "i" } } } },
			},
			sources = {
				-- stessi pattern esclusi da telescope (file_ignore_patterns), qui come
				-- glob passati a fd/rg invece che pattern Lua. ".git" e' gia' escluso
				-- di default dal finder.
				files = { exclude = { "node_modules", "build", "*.class" } },
				grep = { exclude = { "node_modules", "build", "*.class" } },
			},
		},
		notifier = { enabled = true },
		-- Disabilitato: quickfile forza un `vim.cmd("redraw")` sincrono e
		-- incondizionato (anche per i filetype in `exclude`) prima ancora che la
		-- UI sia pronta, per mostrare il file prima di caricare i plugin. Su file
		-- markdown con injection (code fence, inline) questo redraw troppo
		-- anticipato fa scattare un crash nel core di Neovim 0.12:
		-- "attempt to call method 'range' (a nil value)" nell'highlighter
		-- treesitter — il "mare di errori" all'apertura di un .md. Il guadagno di
		-- quickfile e' solo estetico (mostra il contenuto una frazione di secondo
		-- prima che i plugin finiscano di caricare); l'highlighting normale
		-- arriva comunque subito dopo, quindi si disattiva senza perdite reali.
		quickfile = { enabled = false },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	keys = {
		-- Explorer: sostituisce neo-tree. Si chiude con "q" o "<Esc>" come ogni
		-- altro picker di snacks (non e' un pannello persistente come neo-tree, ma
		-- una picker window che appare/scompare).
		{ "<C-n>", function() Snacks.explorer() end, desc = "File Explorer" },
		{ "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
		-- Sostituiscono telescope: stesse scorciatoie (<C-p>, <leader>lg) di prima.
		{ "<C-p>", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>lg", function() Snacks.picker.grep() end, desc = "Live Grep" },
	},
}
