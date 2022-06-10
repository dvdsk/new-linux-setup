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

-- local function_use = {
--  ["lua"] = "(.*)",
--  ["python"] = "(.*)",
--  ["rust"] = "(.*)",
--  ["c"] = "(.*)",
--  ["cpp"] = "(.*)",
--  ["latex"] = "\\section",
-- }

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

-- TODO make this work
-- function M.func_use_scope()
-- 	func_scope(function_use)
-- 	-- vim.api.nvim_win_set_cursor(0, {0,0})
-- end

-- M.func_use_scope()
--

function M.has_words_before()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.open_terminal()
	vim.api.nvim_command('split')
	vim.api.nvim_command('terminal')
end

return M
