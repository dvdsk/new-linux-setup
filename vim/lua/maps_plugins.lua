local map = vim.api.nvim_set_keymap
local silent = {noremap = true, silent = true}

-- Tree
map('n', '<leader>d', ':NvimTreeToggle<CR>', silent)

-- Undo
map('n', '<leader>u', ':MundoToggle<CR>', silent)

-- Gitsigns
map('n', '<leader>hp', ":lua require'gitsigns'.preview_hunk()", silent)

-- Telescope
local function map_scope(key, func)
	map('n', key, ":lua require'telescope.builtin'."..func.."()<CR>", silent)
end

map_scope('<leader>o', 'find_files')
map_scope('<leader>r', 'live_grep')
map_scope('<leader>b', 'buffers')
map_scope('<leader>s', 'lsp_workspace_symbols')
map_scope('<leader>e', 'lsp_workspace_diagnostics')
map_scope('<leader>E', 'lsp_document_diagnostics')
map_scope('gr', 'lsp_references')

-- Termwrapper
map('n', '<leader>t', ':Ttoggle<CR>', silent)

-- Prosesitter
local opt = { noremap = true, silent = true, nowait = true }
function Hover()
	if not require('prosesitter').popup() then
		vim.lsp.buf.hover()
	end
end

local cmd = ":lua Hover()<CR>"
vim.api.nvim_set_keymap("n", ",", cmd, opt)
