local cmd = vim.cmd;
local map = vim.api.nvim_set_keymap
local unmap = vim.api.nvim_del_keymap

vim.g.mapleader = ' '

local options = {noremap = true}

-- move around with ctrl+arrow
local modes = {"n", "i", "t"}
local magic = "<C-\\><C-N><C-w>"
for _,mode in pairs(modes) do
	map(mode, '<C-down>', magic..'<Down>', options)
	map(mode, '<C-up>',   magic..'<Up>', options)
	map(mode, '<C-right>',magic..'<Right>', options)
	map(mode, '<C-left>', magic..'<Left>', options)
end

-- -- mouse drag does not go to visual mode
-- map('n', '<LeftDrag>', '<LeftMouse>', options)
-- unmap('n', '<LeftDrag>')

-- toggle between buffers
map('n', '<leader><leader>', '<C-^>', options) 
map('n', ';', ':', options)
map('n', ':', ';', options)
-- spell using leader instead of z=
map('n', '<leader>z', ':z=', options)
-- switch buffers
-- map('n', '<leader>b', ':buffers<CR>:buffer<Space>', options)
-- yank till end of line
map('n', 'Y', 'y$', options)

-- make escape in terminal mode go to normal mode
-- note this does make us get stuck in terminal 
-- apps which use esc
map('t', '<ESC>', '<C-\\><C-n>', options)

-- Code navigation
map('n', 'gd',        [[<cmd>lua vim.lsp.buf.definition()<CR>]], options)
map('n', 'gD',        [[<cmd>lua vim.lsp.buf.declaration()<CR>]], options)
map('n', 'gr',        [[<cmd>lua vim.lsp.buf.references()<CR>]], options)
map('n', 'gi',        [[<cmd>lua vim.lsp.buf.implementation()<CR>]], options)
map('n', 'K',         [[<cmd>lua vim.lsp.buf.hover()<CR>]], options)
map('n', '<leader>k', [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], options)
map('n', '<leader>n', [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]], options)
map('n', '<leader>p', [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]], options)

-- auto format
map('n', '<leader>f', [[<cmd>lua vim.lsp.buf.formatting()<CR>]], options)
