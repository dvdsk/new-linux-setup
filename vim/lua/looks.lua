require("gitsigns").setup()

local M = {}

local function format_terminal_path(path)
	local terminal = path:find("#toggleterm#")
	if terminal ~= nil then
		local numb = path:sub(terminal+#"#toggleterm#")
		return "Terminal "..numb
	else
		return nil
	end

end

--- return (part of) file path if not too long
local function try_filepath()
	local maxlen = 40
	local path = vim.api.nvim_buf_get_name(0)

	local terminal = format_terminal_path(path)
	if terminal ~= nil then
		return terminal
	end

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

local function diff_source()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed
    }
  end
end

local lualine_sections = {
	lualine_a = { "mode" },
    lualine_b = { {'b:gitsigns_head', icon = ''}, {'diff', source = diff_source}, },
	lualine_c = { try_filepath },
	lualine_x = { { lsp_name, icon = "  LSP:" }, { "diagnostics", sources = { "nvim_diagnostic" } } },
	lualine_y = { "progress" },
	lualine_z = { "location" },
}

local lualine_inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { try_filepath },
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
}

function M:lualine(theme)
	require("lualine").setup({
		options = {
			theme = theme,
		},
		sections = lualine_sections,
		inactive_sections = lualine_inactive_sections,

	})
end

return M
