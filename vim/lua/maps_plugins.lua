local cmd = vim.cmd;
map = vim.api.nvim_set_keymap
options = {noremap = true, silent = true}

-- Tree
map('n', '<leader>f', ':NvimTreeToggle<CR>', options)

-- Undo
map('n', '<leader>u', ':MundoToggle<CR>', options)

-- Telescope
function map_scope(key, func)
	map('n', key, ":lua require'telescope.builtin'."..func.."()<CR>", options)
end

map_scope('<leader>o', 'find_files')
map_scope('<leader>r', 'live_grep')
map_scope('<leader>b', 'buffers')

-- lspsaga
function map_saga(key, module, func)
	map('n', key, ":lua require'lspsaga."..module.."'."..func.."()<CR>", options)
end

map_saga('<leader>a', 'codeaction', 'code_action') 
map_saga('k', 'hover' , 'render_hover_doc') -- show doc
-- map_saga('m', 'action', 'smart_scroll_with_saga(1)')
-- map_saga('n', 'action', 'smart_scroll_with_saga(-1)')
map_saga('cr', 'rename', 'rename')

-- Termwrapper
map('n', 'gt', ':Ttoggle<CR>', options)
