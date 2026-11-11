-- Resolve the Python interpreter for a project.
-- Order: VIRTUAL_ENV -> <root>/.venv -> `pyenv which python` (run in root) -> system python.
local M = {}

local function executable(path)
	return path and path ~= "" and vim.fn.executable(path) == 1
end

---@param root string|nil project root (defaults to nvim's cwd)
---@return string
function M.get(root)
	root = root or vim.uv.cwd()

	local venv = vim.env.VIRTUAL_ENV
	if venv and venv ~= "" and executable(venv .. "/bin/python") then
		return venv .. "/bin/python"
	end

	local local_venv = root .. "/.venv/bin/python"
	if executable(local_venv) then
		return local_venv
	end

	if vim.fn.executable("pyenv") == 1 then
		local ok, res = pcall(function()
			return vim.system({ "pyenv", "which", "python" }, { cwd = root, text = true }):wait(3000)
		end)
		if ok and res and res.code == 0 then
			local path = vim.trim(res.stdout or "")
			if executable(path) then
				return path
			end
		end
	end

	return "/usr/bin/python3"
end

return M
