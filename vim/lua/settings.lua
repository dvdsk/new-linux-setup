local o = vim.o -- global options
local wo = vim.wo
local g = vim.g

-- global options
o.clipboard = "unnamedplus" -- by default copy/past to/from sys clipboard
o.shortmess = "" -- useful for debug handlers/autocommands
o.ignorecase = true --ignore case in search
o.smartcase = true --except when I put a capital in the query
o.incsearch = true --highlight all matches:
o.hlsearch = false --do not keep highlighting search after move
o.inccommand = "nosplit" -- live subsitution
o.mouse = "nic" --enable mouse support except for selecting text
o.spell = false
o.spelllang = "en_gb"
o.spellsuggest = "10" --don't take up the entire screen
o.hidden = true --allow to hide an unsaved buffer
o.splitbelow = true --new split goes bottom
o.splitright = true --new split goes right
o.tabstop = 4
o.softtabstop = 0
o.shiftwidth = 4
o.smartindent = true
o.foldmethod = "syntax"
o.foldenable = true
o.foldlevel = 1
o.foldlevelstart = 99
o.completeopt = "menu,menuone,noselect"

-- gui related
wo.number = true
wo.relativenumber = true
o.laststatus = 2
o.termguicolors = true

-- file specific
g.tex_flavor = "latex"

-- undo
local undodir = vim.fn.system("echo $HOME/.vimdid")
o.undodir = undodir --permanent undo
o.undofile = true --permanent undo
vim.fn.system("mkdir -p " .. o.undodir) -- ensure the folder exists

-- make comments italic
vim.api.nvim_exec([[
	highlight Comment cterm=italic gui=italic
	]], false)
