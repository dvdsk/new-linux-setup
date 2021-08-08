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

	-- Looks
	use "machakann/vim-highlightedyank"
	use "lewis6991/gitsigns.nvim"
	use "hoob3rt/lualine.nvim"
	use "kyazdani42/nvim-web-devicons"
	use "mhinz/vim-startify"

	-- GUI Tools
	use "kyazdani42/nvim-tree.lua"
	use "simnalamburt/vim-mundo"
	use "nvim-telescope/telescope.nvim"
	use "oberblastmeister/termwrapper.nvim"
	use "folke/which-key.nvim"

	-- Text Tools
	-- 	use  'svermeulen/vim-macrobatics'
	use "vim-scripts/Align"
	use "b3nj5m1n/kommentary"
	use "conradirwin/vim-bracketed-paste"
	-- 	use "lewis6991/spellsitter.nvim" -- disabled to check in progress prosesitter
	-- 	use  'airblade/vim-rooter' -- has issues with rust workspaces

	-- Nouns, Verbs, textobjects
	use "tpope/vim-surround"
	use "tpope/vim-repeat"
	use "kana/vim-textobj-user"
	use "kana/vim-textobj-indent"

	-- TreeSitter
	use "nvim-treesitter/nvim-treesitter"
	-- 	use "nvim-treesitter/nvim-treesitter-textobjects"
	use "nvim-treesitter/playground"

	-- LSP
	use "neovim/nvim-lspconfig"
	use "glepnir/lspsaga.nvim" -- extend lsp ui

	-- Completions
	-- 	use  'L3MON4D3/LuaSnip' -- switch to in future
	use "hrsh7th/nvim-compe"
	use "hrsh7th/vim-vsnip"
	use "rafamadriz/friendly-snippets"
end)

