vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"

local select = {
	enable = true,
	keymaps = {
		-- You can use the capture groups defined in textobjects.scm
		["af"] = "@function.outer",
		["if"] = "@function.inner",
		["ac"] = "@class.outer",
		["ic"] = "@class.inner",
	},
}

-- local swap = {
	-- enable = true,
	-- swap_next = {
	-- 	["h"] = "@parameter.inner",
	-- },
	-- swap_previous = {
	-- 	["H"] = "@parameter.inner",
	-- },
-- }

require("nvim-treesitter.configs").setup {
	ensure_installed = { "c", "rust", "python", "bash", "lua", "latex", "bibtex", "toml", "json", "cpp", "query" },
	highlight = { enable = true },
	indent = { enable = false },
	playground = {
		enable = true,
		disable = {},
		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
		persist_queries = false, -- Whether the query persists across vim sessions
		keybindings = {
			toggle_query_editor = "o",
			toggle_hl_groups = "i",
			toggle_injected_languages = "t",
			toggle_anonymous_nodes = "a",
			toggle_language_display = "I",
			focus_language = "f",
			unfocus_language = "F",
			update = "R",
			goto_node = "<cr>",
			show_help = "?",
		},
	},
	textobjects = {
		select = select,
		-- swap = swap,
	},
}
