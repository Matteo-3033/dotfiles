return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = { "williamboman/mason.nvim" },

	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.lsp.config("basedpyright", {
			-- resolved per project, when the server starts
			before_init = function(_, config)
				config.settings = config.settings or {}
				config.settings.python = config.settings.python or {}
				config.settings.python.pythonPath = require("python-path").get(config.root_dir)
			end,
			settings = {
				basedpyright = {
					analysis = {
						typeCheckingMode = "off",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
					},
				},
			},
		})

		vim.lsp.enable({
			"ts_ls",
			"jsonls",
			"basedpyright",
			"lua_ls",
			"clangd",
		})

		-- get info
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
		-- go to definition
		vim.keymap.set("n", "<leader>gd", function()
			Snacks.picker.lsp_definitions()
		end, { desc = "LSP Go to Definition" })
		-- go to references
		--vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
		vim.keymap.set("n", "<leader>gr", function()
			Snacks.picker.lsp_references()
		end, { desc = "LSP References" })
		-- rename symbol
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename Symbol" })
		-- get code actions
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
	end,
}
