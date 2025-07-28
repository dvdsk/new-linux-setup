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
	use "arkav/lualine-lsp-progress"
	use "kyazdani42/nvim-web-devicons"
	use "mhinz/vim-startify"

	-- GUI Tools
	use {
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons",
		}
	}
	use "nvim-telescope/telescope.nvim"
	use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	use "nvim-telescope/telescope-ui-select.nvim"
	use "folke/which-key.nvim"
	use "ThePrimeagen/harpoon"
	use "https://git.sr.ht/~whynothugo/lsp_lines.nvim"
	use {
		"j-hui/fidget.nvim",
		tag = "legacy"
	}

	-- Text Tools
	use "junegunn/vim-easy-align"
	use "numToStr/Comment.nvim"
	use "conradirwin/vim-bracketed-paste"
	use "Ron89/thesaurus_query.vim"

	-- Other
	use "ggandor/leap.nvim"

	-- Nouns, Verbs, textobjects
	use "tpope/vim-surround"
	use "tpope/vim-repeat"
	use "kana/vim-textobj-user"
	use "kana/vim-textobj-indent"

	-- Tree-sitter
	use "nvim-treesitter/nvim-treesitter"
	use "nvim-treesitter/nvim-treesitter-context" 
	use "nvim-treesitter/nvim-treesitter-textobjects"
	-- Use "nvim-treesitter/playground" -- plugin development

	-- LSP
	use {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		run = ":MasonUpdate" -- :MasonUpdate updates registry contents
	}

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
	use "nvim-neotest/nvim-nio"
	use "mfussenegger/nvim-dap"
    use "theHamsta/nvim-dap-virtual-text"
	use "rcarriga/nvim-dap-ui"
	-- for using dap to debug running nvim plugins:
	-- use "jbyuki/one-small-step-for-vimkind"
end)
