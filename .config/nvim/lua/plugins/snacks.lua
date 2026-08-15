return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			enabled = true,
			sections = {
				{ section = "header" },
				{
					pane = 2,
					section = "terminal",
					cmd = "colorscript -e square",
					height = 5,
					padding = 1,
				},
				{ section = "keys", gap = 1, padding = 1 },
				{
					pane = 2,
					icon = { "", hl = "title" },
					title = "Recent Files",
					section = "recent_files",
					cwd = true,
					indent = 2,
					padding = 1,
				},
				{
					pane = 2,
					icon = { "", hl = "title" },
					title = "Projects",
					section = "projects",
					indent = 2,
					padding = 1,
				},
				{
					pane = 2,
					icon = { "", hl = "title" },
					title = "Git Status",
					section = "terminal",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "git status --short --branch --renames",
					height = 5,
					padding = 1,
					ttl = 5 * 60,
					indent = 3,
				},
				{ section = "startup" },
			},
		},
		explorer = { enabled = true },
		image = { enabled = true, doc = { enabled = false } },
		indent = {
			indent = {
				priority = 1,
				enabled = true, -- enable indent guides
				char = "│",
				only_scope = false, -- only show indent guides of the scope
				only_current = false, -- only show indent guides in the current window
				hl = "SnacksIndent", ---@type string|string[] hl groups for indent guides
				-- can be a list of hl groups to cycle through
				-- hl = {
				--     "SnacksIndent1",
				--     "SnacksIndent2",
				--     "SnacksIndent3",
				--     "SnacksIndent4",
				--     "SnacksIndent5",
				--     "SnacksIndent6",
				--     "SnacksIndent7",
				--     "SnacksIndent8",
				-- },
			},
			animate = {
				enabled = vim.fn.has("nvim-0.10") == 1,
				style = "out",
				easing = "linear",
				duration = {
					step = 20, -- ms per step
					total = 500, -- maximum duration
				},
			},
			scope = {
				enabled = true, -- enable highlighting the current scope
				priority = 200,
				char = "│",
				underline = false, -- underline the start of the scope
				only_current = false, -- only show scope in the current window
				hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
			},
			chunk = {
				-- when enabled, scopes will be rendered as chunks, except for the
				-- top-level scope which will be rendered as a scope.
				enabled = false,
				-- only show chunk scopes in the current window
				only_current = false,
				priority = 200,
				hl = "SnacksIndentChunk", ---@type string|string[] hl group for chunk scopes
				char = {
					corner_top = "┌",
					corner_bottom = "└",
					-- corner_top = "╭",
					-- corner_bottom = "╰",
					horizontal = "─",
					vertical = "│",
					arrow = ">",
				},
			},
			-- filter for buffers to enable indent guides
			filter = function(buf, win)
				return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
			end,
		},
		input = { enabled = true },
		picker = {
			enabled = true,
			-- replaces `vim.ui.select` (code action menu, etc.) in place of the
			-- telescope-ui-select extension.
			ui_select = true,
			-- Esc closes the picker instead of just leaving insert mode
			win = {
				input = { keys = { ["<Esc>"] = { "close", mode = { "n", "i" } } } },
			},
			sources = {
				-- ".git" is already excluded by the finder by default.
				files = { exclude = { "node_modules", "build", "*.class" } },
				grep = { exclude = { "node_modules", "build", "*.class" } },
				explorer = {
					actions = {
						explorer_find_files = function()
							Snacks.picker.files()
						end,
						-- Returns focus to the document window, leaving the explorer
						-- open in the background (the picker is not closed).
						explorer_focus_main = function(picker)
							vim.api.nvim_set_current_win(picker.main)
						end,
						-- Closes the explorer. Overrides the default "<c-n>"
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
		quickfile = { enabled = false },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
	},
	terminal = {
		enabled = true,
		bo = {
			filetype = "snacks_terminal",
		},
		wo = {},
		stack = true, -- when enabled, multiple split windows with the same position will be stacked together (useful for terminals)
		keys = {
			term_normal = {
				"<esc>",
				function(self)
					self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
					if self.esc_timer:is_active() then
						self.esc_timer:stop()
						vim.cmd("stopinsert")
					else
						self.esc_timer:start(200, 0, function() end)
						return "<esc>"
					end
				end,
				mode = "t",
				expr = true,
				desc = "Double escape to normal mode",
			},
		},
	},
	keys = {
		{
			"<C-n>",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer",
		},
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer",
		},
		{
			"<C-p>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>lg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Live Grep",
		},
		{
			"<leader>t",
			function()
				Snacks.terminal()
			end,
			desc = "Terminal",
		},
	},
	config = function(_, opts)
		require("snacks").setup(opts)
		-- Work around a known snacks.nvim bug (upstream issue #2634, closed as
		-- wontfix): once an image buffer is hidden (switching to another
		-- buffer/window) its kitty graphics placement doesn't reliably come
		-- back when the buffer becomes visible again — the placeholder text
		-- redraws but the actual pixels don't. Forcing a clean + reattach
		-- (equivalent to `:edit!`, which is the workaround mentioned in the
		-- issue) re-sends the image data and placement from scratch every
		-- time an image buffer is re-entered.
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("snacks-image-reload-fix", { clear = true }),
			callback = function(ev)
				if vim.bo[ev.buf].filetype == "image" then
					Snacks.image.placement.clean(ev.buf)
					Snacks.image.buf.attach(ev.buf)
				end
			end,
		})
	end,
}
