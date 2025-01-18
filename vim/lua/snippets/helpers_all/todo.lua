-- Todo comments vim snippet by Martin Kunz (kunzaatko)
-- source: https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets#all

local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local ls = require("luasnip")
local i = ls.insert_node
local f = ls.function_node
local t = ls.text_node
local c = ls.choice_node
local s = ls.snippet

local calculate_comment_string = require('Comment.ft').calculate
local utils = require('Comment.utils')

--- Get the comment string {beg,end} table
---@param ctype integer 1 for `line`-comment and 2 for `block`-comment
---@return table comment_strings {begcstring, endcstring}
local get_cstring = function(ctype)
	local cstring = calculate_comment_string { ctype = ctype, range = utils.get_region() } or vim.bo.commentstring
	local left, right = utils.unwrap_cstr(cstring)
	return { left or '', right or '' }
end

_G.luasnip = {}
_G.luasnip.vars = {
	username = 'dvdsk',
	email = 'noreply@davidsk.dev',
	github = 'https://github.com/dvdsk',
	real_name = 'David Kleingeld',
}

--- Options for marks to be used in a TODO comment
local marks = {
	signature = function()
		return fmt('<{}>', i(1, _G.luasnip.vars.username))
	end,

	signature_with_email = function()
		return fmt('<{}{}>', { i(1, _G.luasnip.vars.username), i(2, ' ' .. _G.luasnip.vars.email) })
	end,

	date_signature_with_email = function()
		return fmt(
			'<{}{}{}>',
			{ i(1, os.date '%d-%m-%y'), i(2, ', ' .. _G.luasnip.vars.username), i(3, ' ' .. _G.luasnip.vars.email) }
		)
	end,

	date_signature = function()
		return fmt('<{}{}>', { i(1, os.date '%d-%m-%y'), i(2, ', ' .. _G.luasnip.vars.username) })
	end,

	date = function()
		return fmt('<{}>', i(1, os.date '%d-%m-%y'))
	end,

	empty = function()
		return t ''
	end,
}

local function todo_snippet_nodes(aliases, opts)
	local aliases_nodes = vim.tbl_map(function(alias)
		return i(nil, alias) -- generate choices for [name-of-comment]
	end, aliases)
	local sigmark_nodes = {} -- choices for [comment-mark]
	for _, mark in pairs(marks) do
		table.insert(sigmark_nodes, mark())
	end
	-- format them into the actual snippet
	local comment_node = fmta('<> <>: <> <> <><>', {
		f(function()
			return get_cstring(opts.ctype)[1] -- get <comment-string[1]>
		end),
		c(1, aliases_nodes), -- [name-of-comment]
		i(3), -- {comment-text}
		c(2, sigmark_nodes), -- [comment-mark]
		f(function()
			return get_cstring(opts.ctype)[2] -- get <comment-string[2]>
		end),
		i(0),
	})
	return comment_node
end

--- Generate a TODO comment snippet with an automatic description and docstring
---@param context table merged with the generated context table `trig` must be specified
---@param aliases string[]|string of aliases for the todo comment (ex.: {FIX, ISSUE, FIXIT, BUG})
---@param opts table merged with the snippet opts table
local function todo_snippet(context, aliases, opts)
	opts = opts or {}
	-- if we do not have aliases, be smart about the function parameters
	aliases = type(aliases) == 'string' and { aliases } or aliases
	context = context or {}
	if not context.trig then
		return error("context doesn't include a `trig` key which is mandatory", 2)
	end
	opts.ctype = opts.ctype or 1

	-- `choice_node` documentation
	local alias_string = table.concat(aliases, '|')
	context.name = context.name or (alias_string .. ' comment')
	context.dscr = context.dscr or (alias_string .. ' comment with a signature-mark')
	context.docstring = context.docstring or (' {1:' .. alias_string .. '}: {3} <{2:mark}>{0} ')
	context.snippetType = "autosnippet"
	context.trig = "x" .. context.trig

	local comment_node = todo_snippet_nodes(aliases, opts)
	return s(context, comment_node, opts)
end

local todo_snippet_specs = {
	{ { trig = 'todo' }, 'TODO' },
	{ { trig = 'fix' }, { 'FIX', 'BUG', 'ISSUE', 'FIXIT' } },
	{ { trig = 'hack' }, 'HACK' },
	{ { trig = 'warn' }, { 'WARN', 'WARNING', 'XXX' } },
	{ { trig = 'perf' }, { 'PERF', 'PERFORMANCE', 'OPTIM', 'OPTIMIZE' } },
	{ { trig = 'note' }, { 'NOTE', 'INFO' } },
	-- NOTE: Block commented
	{ { trig = 'todob' }, 'TODO', { ctype = 2 } },
	{ { trig = 'fixb' }, { 'FIX', 'BUG', 'ISSUE', 'FIXIT' }, { ctype = 2 } },
	{ { trig = 'hackb' }, 'HACK', { ctype = 2 } },
	{ { trig = 'warnb' }, { 'WARN', 'WARNING', 'XXX' }, { ctype = 2 } },
	{ { trig = 'perfb' }, { 'PERF', 'PERFORMANCE', 'OPTIM', 'OPTIMIZE' }, { ctype = 2 } },
	{ { trig = 'noteb' }, { 'NOTE', 'INFO' }, { ctype = 2 } },
}

local function add(list)
	for _, v in ipairs(todo_snippet_specs) do
		list[#list + 1] = todo_snippet(v[1], v[2], v[3])
	end
end

return add
