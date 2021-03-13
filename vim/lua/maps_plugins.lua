local cmd = vim.cmd;
map = vim.api.nvim_set_keymap
options = {noremap = true, silent = true}

-- Clap
map('n', '<leader>o', ':Clap files<CR>', options)
map('n', '<leader>r', ':Clap grep<CR>', options)

-- completion-nvim


function map_saga(key, module, func)
	map('n', key, ":lua require'lspsaga."..module.."'."..func.."<CR>", options)
end
-- function map_hover(key, func)

-- lspsaga
map_saga('<leader>a', 'codeaction', 'code_action()') 
map_saga('k', 'hover' , 'render_hover_doc()') -- show doc
map_saga('m', 'action', 'smart_scroll_with_saga(1)')
map_saga('n', 'action', 'smart_scroll_with_saga(-1)')
map_saga('cr', 'rename', 'rename()')
