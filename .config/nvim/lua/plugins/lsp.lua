return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = { "williamboman/mason.nvim" },

	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		local function get_python_path()
			local handle = io.popen("pyenv which python 2>/dev/null")
			if handle then
				local result = handle:read("*a")
				handle:close()
				if result and result ~= "" then
					return result:gsub("%s+$", "")
				end
			end

			local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
			return venv .. "/bin/python"
		end

		local python_path = get_python_path()

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		vim.lsp.config("pyright", {
			settings = {
				python = {
					pythonPath = python_path,
					analysis = {
						typeCheckingMode = "strict",
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
			"pyright",
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
