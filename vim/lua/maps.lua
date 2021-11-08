local cmd = vim.cmd;
local map = vim.api.nvim_set_keymap
local unmap = vim.api.nvim_del_keymap

vim.g.mapleader = ' '

local options = {noremap = true}

-- move around with ctrl+arrow
local modes = {"n", "i", "t"}
local move_magic = "<C-\\><C-N><C-w>"
for _,mode in pairs(modes) do
	map(mode, '<C-down>', move_magic..'<Down>', options)
	map(mode, '<C-up>',   move_magic..'<Up>', options)
	map(mode, '<C-right>',move_magic..'<Right>', options)
	map(mode, '<C-left>', move_magic..'<Left>', options)
end

-- change current window (split) size using alt
local resize_magic = "<C-\\><C-N><C-w>"
for _,mode in pairs(modes) do
	map(mode, '<A-down>',  resize_magic..'-', options)
	map(mode, '<A-up>',    resize_magic..'+', options)
	map(mode, '<A-right>', resize_magic..'>', options)
	map(mode, '<A-left>',  resize_magic..'<', options)
end

map('n', '<leader><leader>', '<C-^>', options)
map('n', ';', ':', options)
map('n', ':', ';', options)

-- yank till end of line
map('n', 'Y', 'y$', options)

-- make escape in terminal mode go to normal mode
-- note this does make us get stuck in terminal
-- apps which use esc
map('t', '<ESC>', '<C-\\><C-n>', options)

-- Code navigation
map('n', 'gd',        [[<cmd>lua vim.lsp.buf.definition()<CR>]], options)
map('n', 'gD',        [[<cmd>lua vim.lsp.buf.declaration()<CR>]], options)
map('n', 'gi',        [[<cmd>lua vim.lsp.buf.implementation()<CR>]], options)
map('n', 'k',         [[<cmd>lua vim.lsp.buf.hover()<CR>]], options)
map('i', '<C-k>',     [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], options) -- control + k
map('n', '<leader>p', [[<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]], options)
map('n', '<leader>n', [[<cmd>lua vim.lsp.diagnostic.goto_next()<CR>]], options)
map('n', '<leader>l', [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>]], options)

-- auto format
map('n', '<leader>f', [[<cmd>lua vim.lsp.buf.formatting()<CR>]], options)
map('n', 'cr', [[<cmd>lua vim.lsp.buf.rename()<CR>]], options)
map('n', '<leader>a', [[<cmd>lua vim.lsp.buf.code_action()<CR>]], options)
