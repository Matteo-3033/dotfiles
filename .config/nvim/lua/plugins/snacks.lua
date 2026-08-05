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
		-- `doc.enabled` makes snacks scan (via treesitter, asynchronously) every
		-- open buffer looking for image links to preview at the cursor. On
		-- Neovim 0.12 this async parsing races with the highlighter and crashes
		-- (see the comment on indent.scope below). Actual image rendering
		-- (:h snacks-image) stays enabled.
		image = { enabled = true, doc = { enabled = false } },
		-- `scope.async = false`: same as above, avoids the async treesitter
		-- parsing that races with the highlighter and causes
		-- "attempt to call method 'range' (a nil value)" on every file open
		-- with a more complex parser/injection (e.g. markdown with code fences).
		indent = { enabled = true, scope = { async = false } },
		input = { enabled = true },
		picker = {
			enabled = true,
			-- replaces `vim.ui.select` (code action menu, etc.) in place of the
			-- telescope-ui-select extension. Already true by default, made
			-- explicit only for clarity.
			ui_select = true,
			-- Esc closes the picker instead of just leaving insert mode
			-- (default behavior, see comment in snacks.picker.config.defaults).
			win = {
				input = { keys = { ["<Esc>"] = { "close", mode = { "n", "i" } } } },
			},
			sources = {
				-- same patterns excluded by telescope (file_ignore_patterns), here
				-- as globs passed to fd/rg instead of Lua patterns. ".git" is
				-- already excluded by the finder by default.
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
						-- Closes the explorer. Overrides the default "<c-n>"
						-- (list_down) so the global <C-n> toggle keymap
						-- (see plugins/snacks.lua keys) also works while
						-- focus is inside the explorer itself.
						explorer_toggle = function(picker)
							picker:close()
						end,
					},
					win = {
						-- The explorer starts focused on the list (not the input),
						-- but if the user opens the search box ("/" or "i") we want
						-- the same behavior there too.
						input = {
							keys = {
								["<Esc>"] = { "explorer_focus_main", mode = { "n", "i" } },
								["<c-n>"] = { "explorer_toggle", mode = { "n", "i" } },
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
								-- <C-n> defaults to "list_down"; overridden here to close
								-- the explorer, so the global <C-n> toggle keymap works
								-- from inside the explorer too.
								["<c-n>"] = "explorer_toggle",
							},
						},
					},
				},
			},
		},
		notifier = { enabled = true },
		-- Disabled: quickfile forces a synchronous, unconditional
		-- `vim.cmd("redraw")` (even for filetypes in `exclude`) before the UI
		-- is even ready, to show the file before plugins finish loading. On
		-- markdown files with injections (code fences, inline) this too-early
		-- redraw triggers a crash in Neovim 0.12 core:
		-- "attempt to call method 'range' (a nil value)" in the treesitter
		-- highlighter — the "sea of errors" when opening a .md file. The
		-- benefit of quickfile is purely cosmetic (shows content a fraction of
		-- a second before plugins finish loading); normal highlighting kicks
		-- in right after anyway, so disabling it loses nothing real.
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
		-- <C-n> toggles: closes the explorer if it's currently focused
		-- (list or input), opens/focuses it otherwise. Snacks.explorer()
		-- alone only opens/focuses, it never closes.
		{
			"<C-n>",
			function()
				local explorer = Snacks.picker.get({ source = "explorer" })[1]
				if explorer and explorer:is_focused() then
					explorer:close()
				else
					Snacks.explorer()
				end
			end,
			desc = "Toggle File Explorer",
		},
		{ "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
		-- Replace telescope: same shortcuts (<C-p>, <leader>lg) as before.
		{ "<C-p>", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>lg", function() Snacks.picker.grep() end, desc = "Live Grep" },
	},
}
