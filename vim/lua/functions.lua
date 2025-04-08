-- test using :luafile %

local util = require("util")

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

-- TODO: fixme
-- -- only works for one line right now
-- function M.paste_keep_pasted()
-- 	-- local to_paste = vim.fn.getreg('"')
-- 	local to_paste = "\nhello thist test"

-- 	if vim.api.nvim_get_mode() ~= { "v", false } then
-- 		print("using normal paste handler")
-- 		print("to paste: "..vim.inspect(to_paste))
-- 		vim.api.nvim_paste(to_paste, true, -1)
-- 		return
-- 	end

-- 	print("using visual mode paste routine")
-- 	local row_start, col_start, row_end, col_end = util.visual_selection_range()

-- 	if row_start ~= row_end then
-- 		error("Can not (yet) use paste_keep_pasted() for multiple rows")
-- 		return
-- 	end

-- 	local current = vim.api.nvim_get_current_line()
-- 	col_start = math.max(col_start - 1, 1)
-- 	local before = current:sub(1, col_start)
-- 	local after = current:sub(col_end + 1, -1) -- till end of string

-- 	local new = before .. to_paste .. after
-- 	vim.api.nvim_set_current_line(new)
-- end

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
	local line = vim.api.nvim_get_current_line()

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
	vim.api.nvim_set_current_line(line)
end

function M.apply_custom_remaps()
	-- remappings for colemak
	-- free up home row keys s,t and n
	vim.keymap.set({ 'n', 'v' }, 'j', 's')
	-- only needed in visual mode (t there is used for moving)
	vim.keymap.set({ 'v' }, 'l', 't')
	vim.keymap.set({ 'n', 'v' }, 'h', 'n')
	-- not freeing 'e' key (part of nest), using m instead as e is more frequent then m

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
	-- vim.keymap.del({ 'n', 'v' }, 'l')
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

local virtual_lines_on = false
function M.toggle_diagnostic_lines()
	virtual_lines_on = not virtual_lines_on
	vim.diagnostic.config({ virtual_lines = virtual_lines_on })
end

-- opts is a table with a field fargs that has the arguments to the command
-- the first should be the required_prefix
function M.lsp_code_action_by_prefix(opts)
	local required_prefix = string.lower(opts.fargs[1])
	if required_prefix == nil or #required_prefix == 0 then
		print("CODE ACTION PREFIX IS NOT ALLOWED TO BE EMPTY, PASS ONE IN PLEASE")
		return
	end
	vim.lsp.buf.code_action({
		apply = true, -- If there is only one remaining action after filtering perform it
		filter = function(action)
			return string.lower(action.title:sub(1, #required_prefix)) == required_prefix
		end,
	})
end

function get_cached_code_actions()
	local cache = vim.b["cached_code_actions"]
	if cache == nil then
		return nil
	end

	local line = vim.api.nvim_get_current_line()
	local cache_line = cache[line]
	if cache_line == nil then
		return nil
	end

	local time_now = os.time(os.date("!*t"))
	local cache_updated_at = cache_line.unix_time
	if time_now - cache_updated_at > 180 then
		return nil
	else
		return cache_line.code_actions
	end
end

function update_cached_code_actions(code_actions)
	local cache = vim.b["cached_code_actions"]
	if vim.b["cached_code_actions"] == nil then
		vim.b["cached_code_actions"] = {}
	end

	local line = vim.api.nvim_get_current_line()
	vim.b["cached_code_actions"][line] = {
		unix_time = os.time(os.date("!*t")),
		code_actions = code_actions,
	}
end

function M.lst_list_code_actions()
	local cached = get_cached_code_actions()
	if cached ~= nil then
		return cached
	end

	local bufnr = vim.api.nvim_get_current_buf()

	local actions = {}
	for _, client in pairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
		params.context = {
			triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
			diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
		}
		local res = client:request_sync("textDocument/codeAction", params, 1000, 0)
		table.insert(actions, res)
	end

	local output = {}
	for _, action in pairs(actions) do
		if action.result ~= nil then
			for _, result in pairs(action.result) do
				table.insert(output, result.title)
			end
		end
	end

	update_cached_code_actions(output)
	return output
end

return M
