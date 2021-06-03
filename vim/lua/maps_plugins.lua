local cmd = vim.cmd;
map = vim.api.nvim_set_keymap
local silent = {noremap = true, silent = true}

-- Tree
map('n', '<leader>d', ':NvimTreeToggle<CR>', silent)

-- Undo
map('n', '<leader>u', ':MundoToggle<CR>', silent)

-- Telescope
function map_scope(key, func)
	map('n', key, ":lua require'telescope.builtin'."..func.."()<CR>", silent)
end

map_scope('<leader>o', 'find_files')
map_scope('<leader>r', 'live_grep')
map_scope('<leader>b', 'buffers')

-- lspsaga
function map_saga(key, module, func)
	map('n', key, ":lua require'lspsaga."..module.."'."..func.."()<CR>", silent)
end

map_saga('<leader>a', 'codeaction', 'code_action') 
map_saga('k', 'hover' , 'render_hover_doc') -- show doc
-- map_saga('m', 'action', 'smart_scroll_with_saga(1)')
-- map_saga('n', 'action', 'smart_scroll_with_saga(-1)')
map_saga('cr', 'rename', 'rename')

-- Termwrapper
map('n', '<leader>t', ':Ttoggle<CR>', silent)

-- Completions
local expr = {silent = true, expr = true}
map("i", "<CR>", [[compe#confirm('<CR>')]], expr)

-- Snippets
map("i", "<TAB>", [[vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' : '<TAB>']], expr)
