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
				explorer = {
					-- Named custom actions: a raw Lua function placed directly in
					-- win.*.keys receives the window (snacks.win), not the picker
					-- (which exposes .main) — hence routing through a named action
					-- in opts.actions, resolved with access to the real picker.
					actions = {
						-- Opens Find Files on top of the explorer without closing it
						-- (unlike the built-in "picker_files" action, which closes
						-- the source picker once the new one shows).
						explorer_find_files = function()
							Snacks.picker.files()
						end,
						-- Returns focus to the document window, leaving the explorer
						-- open in the background (the picker is not closed).
						explorer_focus_main = function(picker)
							vim.api.nvim_set_current_win(picker.main)
						end,
					},
					win = {
						-- The explorer starts focused on the list (not the input),
						-- but if the user opens the search box ("/" or "i") we want
						-- the same behavior there too.
						input = {
							keys = {
								["<Esc>"] = { "explorer_focus_main", mode = { "n", "i" } },
							},
						},
						list = {
							keys = {
								-- <C-p> in the explorer defaults to "list_up" (inherited
								-- from the base picker keymaps); here it behaves like in
								-- a document: opens Find Files, without closing the explorer.
								["<c-p>"] = "explorer_find_files",
								-- <C-w>w would by default cycle all the way to the
								-- explorer's input window (search box); here it goes
								-- straight back to the document window, leaving the
								-- explorer open.
								["<c-w>w"] = "explorer_focus_main",
								-- Esc by default closes the explorer (like any other
								-- picker); here it just returns to the document,
								-- leaving it open.
								["<Esc>"] = "explorer_focus_main",
							},
						},
					},
				},
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
		-- Explorer: replaces neo-tree. Closes with "q"; "<Esc>" instead returns
		-- focus to the document, leaving it open in the background (see the
		-- override in picker.sources.explorer above).
		{ "<C-n>", function() Snacks.explorer() end, desc = "File Explorer" },
		{ "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
		-- Sostituiscono telescope: stesse scorciatoie (<C-p>, <leader>lg) di prima.
		{ "<C-p>", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>lg", function() Snacks.picker.grep() end, desc = "Live Grep" },
	},
}
