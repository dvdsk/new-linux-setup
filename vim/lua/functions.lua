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

local function_use = {
 ["lua"] = "(.*)",
 ["python"] = "(.*)",
 ["rust"] = "(.*)",
 ["c"] = "(.*)",
 ["cpp"] = "(.*)",
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
return M
