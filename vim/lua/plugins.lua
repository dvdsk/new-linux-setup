local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
	local install = vim.fn.input("packer plugin manager not installed, install it?\n(will place files in: "..install_path..") y/n: ")
	if install == "y" then
		fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
		execute 'packadd packer.nvim'
	end
end

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Dependencies
	use "nvim-lua/plenary.nvim" -- telescope, gitsigns
	use "nvim-lua/popup.nvim" -- telescope

	-- themes
	use "folke/tokyonight.nvim"
	use "shaunsingh/solarized.nvim"
	use "sainnhe/gruvbox-material"

	-- Looks
	use "machakann/vim-highlightedyank"
	use "lewis6991/gitsigns.nvim"
	use "nvim-lualine/lualine.nvim"
	use "kyazdani42/nvim-web-devicons"
	use "mhinz/vim-startify"

	-- GUI Tools
	-- awaiting rewrite: "kyazdani42/nvim-tree.lua"
	use "nvim-telescope/telescope.nvim"
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	use "nvim-telescope/telescope-ui-select.nvim"
	use "folke/which-key.nvim"
	use "mrjones2014/legendary.nvim"
	use "ThePrimeagen/harpoon"

	-- Text Tools
	use "junegunn/vim-easy-align"
	use "b3nj5m1n/kommentary"
	use "conradirwin/vim-bracketed-paste"
	use "Ron89/thesaurus_query.vim"

	-- Other
	use "ggandor/lightspeed.nvim"

	-- Nouns, Verbs, textobjects
	use "tpope/vim-surround"
	use "tpope/vim-repeat"
	use "kana/vim-textobj-user"
	use "kana/vim-textobj-indent"

	-- TreeSitter
	use "nvim-treesitter/nvim-treesitter"
	use "nvim-treesitter/nvim-treesitter-textobjects"
	use "nvim-treesitter/playground"

	-- LSP
	use "neovim/nvim-lspconfig"

	-- Completions
	use "L3MON4D3/LuaSnip"
	use "rafamadriz/friendly-snippets"

	use "hrsh7th/nvim-cmp"
	use "hrsh7th/cmp-nvim-lsp"
	use "hrsh7th/cmp-nvim-lsp-signature-help"
	use "hrsh7th/cmp-buffer"
	use "hrsh7th/cmp-path"
	use "hrsh7th/cmp-cmdline"
	use "saadparwaiz1/cmp_luasnip"

	-- Debugger
	use "mfussenegger/nvim-dap"
    use "theHamsta/nvim-dap-virtual-text"
	use "rcarriga/nvim-dap-ui"
	use "jbyuki/one-small-step-for-vimkind"
end)
