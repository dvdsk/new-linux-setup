require("gitsigns").setup()

local M = {}

local function lsp_name()
	local msg = "No Active Lsp"
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_clients()
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
	lualine_b = { { 'b:gitsigns_head', icon = '' }, { 'diff', source = diff_source, colored = false }, },
	lualine_c = { { 'filename', path = 3, shorting_target = 40 } },
	lualine_x = {
		{ lsp_name, icon = "  LSP:" },
		-- { "lsp_progress", display_components = { "lsp_client_name", { "percentage" } } },
		{ "diagnostics", sources = { "nvim_diagnostic" } },
	},
	lualine_y = { "progress" },
	lualine_z = { "location" },
}

local lualine_inactive_sections = {
	lualine_a = {},
	lualine_b = {},
	lualine_c = { { 'filename', path = 3, shorting_target = 40 } },
	lualine_x = { 'location' },
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

require("fidget").setup{
	window = {
		relative = "win",
		blend = 20,
		zindex = nil,
	}

}

return M
