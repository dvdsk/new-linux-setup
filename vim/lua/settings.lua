local o = vim.o
local wo = vim.wo
local bo = vim.bo
local g = vim.g
local cmd = vim.cmd

-- global options
o.incsearch = true --Enable searching as you type
o.ignorecase = true --ignore case in search
o.smartcase = true --except when I put a capital in the query
o.incsearch = true --highlight all matches:
o.mouse = 'nic' --enable mouse support except for selecting text
o.undodir = '~/.vimdid' --permanent undo
o.undofile = true --permanent undo
-- o.nohlsearch = true --do not keep highlighting search after move
o.spell = true 
o.spelllang = 'en_gb'
o.spellsuggest = "10" --don't take up the entire screen
o.hidden = true --allow to hide an unsaved buffer
o.splitbelow = true --new split goes bottom
o.splitright = true --new split goes right
o.tabstop= 4
o.softtabstop= 0 
o.shiftwidth = 4
o.foldmethod = "syntax"
o.foldenable = true
o.foldlevel = 1

-- gui related
wo.number = true
wo.relativenumber = true
o.laststatus = 2
o.termguicolors = true

vim.api.nvim_exec([[
	highlight Comment cterm=italic gui=italic
	]], false)