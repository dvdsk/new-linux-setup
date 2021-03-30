vim.cmd 'packadd paq-nvim'
local paq = require 'paq-nvim'.paq
paq{'savq/paq-nvim', opt=true}

-- Dependencies
paq 'nvim-lua/plenary.nvim' -- telescope, gitsigns
paq 'nvim-lua/popup.nvim' -- telescope

-- themes
-- paq 'lifepillar/vim-solarized8'  
-- paq 'jnurmine/Zenburn'
paq 'mhartington/oceanic-next'
paq 'sainnhe/edge'

-- Looks
paq 'machakann/vim-highlightedyank'
paq 'lewis6991/gitsigns.nvim'
paq 'vim-airline/vim-airline'
paq 'vim-airline/vim-airline-themes'
paq 'mhinz/vim-startify'
paq 'ryanoasis/vim-devicons'

-- GUI Tools
paq 'simnalamburt/vim-mundo'
paq 'ms-jpq/chadtree'
-- paq{'liuchengxu/vim-clap', run=':Clap install-binary'}
paq 'nvim-telescope/telescope.nvim'
paq 'oberblastmeister/termwrapper.nvim' -- broken though promising

-- Text Tools
paq 'vim-scripts/Align'
paq 'tpope/vim-commentary'
paq 'conradirwin/vim-bracketed-paste'
paq 'airblade/vim-rooter'

-- Nouns, Verbs, textobjects
paq 'tpope/vim-surround'
paq 'tpope/vim-repeat'
paq 'kana/vim-textobj-user'
paq 'kana/vim-textobj-indent'

-- TreeSitter -- TODO has all kind of optional stuff no idea if needed...
paq{'nvim-treesitter/nvim-treesitter', run=treesitter_languages}
paq 'nvim-treesitter/nvim-treesitter-textobjects'

-- LSP
paq 'neovim/nvim-lspconfig'
paq 'anott03/nvim-lspinstall'
paq 'hrsh7th/vim-vsnip' -- lsp snippets
paq 'glepnir/lspsaga.nvim' -- extend lsp ui

-- Completions
paq 'hrsh7th/nvim-compe'


require 'settings'
require 'maps'
require 'maps_plugins'

-- these files mirrors those above in the package section
-- and contain configurations
require 'theme'
require 'looks'
require 'gui_tools'
require 'treesitter'

require 'comp'

local saga = require 'lspsaga'
saga.init_lsp_saga()
