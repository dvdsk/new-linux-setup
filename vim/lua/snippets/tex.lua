local ls = require("luasnip")
local util = require("util")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local fmt = require("luasnip.extras.fmt").fmt

local function rec_ls()
	return sn(nil, {
		c(1, {
			-- important!! Having the sn(...) as the first choice will cause infinite recursion.
			t({""}),
			-- The same dynamicNode as in the snippet (also note: self reference).
			sn(nil, {t({"", "\t\\item "}), i(1), d(2, rec_ls, {})}),
		}),
	});
end

local function list_snippet(trig, kind)
	return s({trig = trig, name = kind}, {
		t({"\\begin{"..kind.."}",
		"\t\\item "}), i(1), d(2, rec_ls, {}),
		t({"", "\\end{"..kind.."}"}), i(0)
	})
end

-- returns a list of text nodes of all the styles found in latex files
local function find_styles()
	assert(vim.fn.executable("rg") == 1, "ripgrep needs to be installed")
	local handle = io.popen([[rg "\\\tikzstyle\{(.+)\}"]]
	..[[ --no-filename]]
	..[[ --no-line-number]]
	..[[ --only-matching]]
	..[[ --replace '$1']])
	local results = {}
	for res in handle:lines() do
		results[#results+1] = t(res)
	end
	handle:close()
	return results
end

local function tikz_scope()
	local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
	row = math.max(row-1, 0) -- ignore content of current row
	local lines = vim.api.nvim_buf_get_lines(0, 0, row, false)
	local PATTERN = "\\begin{tikzpicture}"

	local result = {}
	for i = #lines, 1, -1 do
		if string.match(lines[i], PATTERN) then
			break
		end
		result[#result+1] = lines[i]
	end

	return util.reverse(result)
end

local function find_node_ids()
	local lines = tikz_scope()
	local PATTERN = "\\node %([%w_]+%)"
	local results = {}
	for _, line in ipairs(lines) do
		local match = string.match(line, PATTERN)
		if match ~= nil then
			local node_id = string.sub(match, #"\node ("+2, -2)
			results[#results+1] = t(node_id)
		end
	end
	return results
end

local function tikz_style_node(pos)
	return d(pos, function(_)
		local choices = find_styles()
		return sn(nil, {c(1, choices)})
	end, {})
end

local function tikz_id_node(pos)
	return d(pos, function(_)
		local names = find_node_ids()
		return sn(nil, {c(1, names)})
	end, {})
end

local function tikz_dir(main_dir)
	local choice_node
	if main_dir == "above" or main_dir == "below" then
		choice_node = c(3, {t(""), t(" left"), t(" right")})
	else
		choice_node = c(3, {t(""), t(" above"), t(" below")})
	end
	return s({trig = "t"..main_dir , name = "tikz "..main_dir},
		fmt("\\node ({id}) [{style}, "..main_dir.."{sec_dir}=of {target}] {{{text}}};",
		{
			id = i(1, "id"),
			style = tikz_style_node(2),
			sec_dir = choice_node,
			target = tikz_id_node(4),
			text = i(0, "text")
		})
	)
end

local function tikz_deg_node(pos)
	return c(pos, {t("270"), t("180"), t("90"), t("0"), i(pos, "deg")})
end

return {
	list_snippet("li", "itemize"),
	list_snippet("le", "enumerate"),
	-- tikz
	tikz_dir("below"),
	tikz_dir("above"),
	tikz_dir("left"),
	tikz_dir("right"),
	s({trig = "tdraw", name = "tikz draw"},
		fmt("\\draw[{style}] ({start}) to [out={deg_out}, in={deg_in}] node [] {{{label}}} ({endn});{}",
		{
			style = tikz_style_node(1),
			start = tikz_id_node(2),
			deg_out = tikz_deg_node(3),
			deg_in = tikz_deg_node(4),
			label = i(5, "text"),
			endn = tikz_id_node(6),
			i(0,"")
		})
	)
}, {}
