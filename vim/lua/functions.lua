-- test using :luafile %
M = {}

local function_def = {
	["lua"] = "function",
	["python"] = "def",
	["rust"] = "fn",
	["c"] = ".+ .+\\(\\) \\{",
	["cpp"] = ".+ .+\\(\\) \\{",
	["latex"] = "\\section",
}

local extensions = {
	["lua"] = { "lua" },
	["python"] = { "py" },
	["rust"] = { "rs" },
	["c"] = { "c", "h" },
	["cpp"] = { "cpp", "hpp" },
	["latex"] = { "tex" },
}

-- idea take from https://www.reddit.com/r/neovim/comments/st1kxs/some_telescope_tips/
-- Update link in blogpost if this function in moved
local function func_scope(pattern)
	local bufnr = vim.api.nvim_get_current_buf()
	local filetype = vim.bo[bufnr].filetype
	local search = pattern[filetype] .. " "
	local patterns = function()
		local list = {}
		for _, ext in ipairs(extensions[filetype]) do
			list[#list + 1] = "-g*." .. ext .. ""
		end
		return list
	end

	require('telescope.builtin').live_grep({
		default_text = search,
		prompt_title = "find function",
		additional_args = patterns -- TODO figure out how this works
	})
end

function M.func_def_scope()
	func_scope(function_def)
end

function M.has_words_before()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.open_terminal()
	vim.api.nvim_command('split')
	vim.api.nvim_command('terminal')
end

function M.more_pub()
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	row = row - 1
	local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]

	local function replace(key, rest)
		local lookup = {}
		lookup["fn "] = "pub(super) fn "
		lookup["type "] = "pub(super) type "
		lookup["trait "] = "pub(super) trait "
		lookup["struct "] = "pub(super) struct "
		lookup["async "] = "pub(super) async "
		lookup["pub(super) "] = "pub(crate) "
		lookup["pub(crate) "] = "pub "
		lookup["pub "] = ""

		if lookup[key] == nil then
			return
		end

		return lookup[key] .. rest
	end

	line = line:gsub("([traittypestructfnasyncsuperpub()]+%s)([%w_]+)", replace, 1)
	vim.api.nvim_buf_set_lines(0, row, row + 1, false, { line })
end

function M.apply_custom_remaps()
	-- remappings for colemak
	-- free up home row keys
	vim.keymap.set({ 'n', 'v' }, 'j', 's')
	vim.keymap.set({ 'n', 'v' }, 'l', 't') -- not needed for v/d/c till as that uses operator mode
	vim.keymap.set({ 'n', 'v' }, 'h', 'n')
	-- not freeing 'e' key (part of nest), using m instead as e is more frequent then
	-- m

	-- set movement keys to home row
	local modes = { 'n', 'o', 'v' }
	vim.keymap.set(modes, 'm', '<Down>')
	vim.keymap.set(modes, 'n', '<Up>')
	vim.keymap.set(modes, 's', '<Left>')
	vim.keymap.set({ 'n', 'v' }, 't', '<Right>')

	vim.keymap.set(modes, 'N', '<PageUp>')
	vim.keymap.set(modes, 'M', '<PageDown>')
	vim.keymap.set(modes, 'S', '<Home>')
	vim.keymap.set(modes, 'T', '<End>')

	-- unbind normal mode arrow keys to force new `nest` keys
	vim.keymap.set(modes, '<Up>', '<nop>')
	vim.keymap.set(modes, '<Down>', '<nop>')
	vim.keymap.set(modes, '<Left>', '<nop>')
	vim.keymap.set(modes, '<Right>', '<nop>')

	vim.keymap.set({ 'n', 'v' }, ";", ":", { noremap = true })
	vim.keymap.set({ 'n', 'v' }, ":", ";", { noremap = true })
end

function M.undo_custom_remaps()
	vim.keymap.del({ 'n', 'v' }, 'j')
	vim.keymap.del({ 'n', 'v' }, 'l')
	vim.keymap.del({ 'n', 'v' }, 'h')

	local modes = { 'n', 'o', 'v' }
	vim.keymap.del(modes, 'm')
	vim.keymap.del(modes, 'n')
	vim.keymap.del(modes, 's')
	vim.keymap.del({ 'n', 'v' }, 't')

	vim.keymap.del(modes, 'N')
	vim.keymap.del(modes, 'M')
	vim.keymap.del(modes, 'S')
	vim.keymap.del(modes, 'T')

	vim.keymap.del(modes, '<Up>')
	vim.keymap.del(modes, '<Down>')
	vim.keymap.del(modes, '<Left>')
	vim.keymap.del(modes, '<Right>')

	vim.keymap.del({ 'n', 'v' }, ";")
	vim.keymap.del({ 'n', 'v' }, ":")
end

return M
