require("gitsigns").setup()

local M = {}

--- return (part of) file path if not too long
local function try_filepath()
	local maxlen = 40
	local path = vim.api.nvim_buf_get_name(0)

	local home = os.getenv("HOME")
	path = string.gsub(path, home, "~")

	local start = #path - maxlen
	if start < 0 then
		start = 0
	else
		start = string.find(path, "/", start)
	end

	return string.sub(path, start)
end

local function lsp_name()
	local msg = "No Active Lsp"
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_active_clients()
	if next(clients) == nil then
		return msg
	end
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			return client.name
		end
	end
	return msg
end

local lualine_sections = {
	lualine_a = { "mode" },
	lualine_b = { "branch", "diff" },
	lualine_c = { try_filepath },
	lualine_x = { { lsp_name, icon = "  LSP:" }, { "diagnostics", sources = { "nvim_lsp" } } },
	lualine_y = { "progress" },
	lualine_z = { "location" },
}

function M:lualine(theme)
	require("lualine").setup({
		options = {
			theme = theme,
		},
		sections = lualine_sections,
	})
end

return M
