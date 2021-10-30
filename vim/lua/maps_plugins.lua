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

-- lspsaga
local function map_saga(key, module, func)
	map('n', key, ":lua require'lspsaga."..module.."'."..func.."()<CR>", silent)
end

map_saga('<leader>a', 'codeaction', 'code_action')
map_saga('K', 'provider' , 'preview_definition') -- show doc
-- map_saga('<leader>k', 'hover' , 'render_hover_doc') -- show doc
-- map_saga('m', 'action', 'smart_scroll_with_saga(1)')
-- map_saga('n', 'action', 'smart_scroll_with_saga(-1)')
map_saga('cr', 'rename', 'rename')

-- Termwrapper
map('n', '<leader>t', ':Ttoggle<CR>', silent)

-- Completions
local expr = {silent = true, expr = true}
-- Snippets
map("i", "<TAB>", [[vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<TAB>']], expr)
-- map("i", "<TAB>", [[luasnip#expand_or_jumpable() ? '<Plug>(luasnip-expand-or-jump)' : '<TAB>']], expr)

-- Prosesitter
local opt = { noremap = true, silent = true, nowait = true }
function Hover()
	if not require('prosesitter').popup() then
		vim.lsp.buf.hover()
	end
end

local cmd = ":lua Hover()<CR>"
vim.api.nvim_set_keymap("n", ",", cmd, opt)
