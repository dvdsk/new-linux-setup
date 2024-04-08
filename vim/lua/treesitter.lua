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
		updatetime = 25,   -- Debounced time for highlighting nodes in the playground from source code
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

require("treesitter-context").setup {
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	-- Minimum editor window height to enable context. Values <= 0 mean no limit.
	min_window_height = 0,
	line_numbers = true,
	-- Maximum number of lines to collapse for a single context line
	multiline_threshold = 100,
	-- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	trim_scope = 'outer',
	mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
	-- Separator between context and content. Should be a single 
	-- character string, like '-'. When separator is set, the context 
	-- will only show up when there are at least 2 lines above cursorline.
	separator = nil,
	zindex = 20,  -- The Z-index of the context window
	on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching

	patterns = {  -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
		-- For all filetypes
		-- Note that setting an entry here replaces all other patterns for this entry.
		-- By setting the 'default' entry below, you can control which nodes you want to
		-- appear in the context window.
		default = {
			'class',
			'function',
			'method',
			'switch',
			'case',
			-- 'for', -- These won't appear in the context
			-- 'while',
			-- 'if',
		},
		rust = {
			'impl_item',
			'match'
		},
	},
}
