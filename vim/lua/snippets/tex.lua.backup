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
	local handle = io.popen([[rg "\\\tikzstyle\{(.+?)\}"]]
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
		if #choices > 0 then
			return sn(nil, {c(1, choices)})
		else
			return sn(nil, i(1, "style or args"))
		end
	end, {})
end

local function tikz_id_node(pos)
	return d(pos, function(_)
		local names = find_node_ids()
		if #names > 0 then
			return sn(nil, {c(1, names)})
		else
			return sn(nil, i(1, "other node"))
		end
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

local function tikz_deg_node_a(pos)
	return c(pos, {t("90"), t("0"), t("270"), t("180"), i(pos, "deg")})
end
local function tikz_deg_node_b(pos)
	return c(pos, {t("270"), t("180"), t("90"), t("0"), i(pos, "deg")})
end

local function fig_input(pos)
	return c(pos, {
		sn(nil, {t("\\includegraphics{"), i(1, "path"), t("}")}),
		sn(nil, {t("\\input{"), i(1, "path"), t("}") })
	})
end

local tikz = s({trig = "bt", name = "figure"},
fmt([[
\begin{{tikzpicture}}[node distance=0.5cm and 1.0cm, auto]
	{}
\end{{tikzpicture}}
]], {i(0)}))

local figure = s({trig = "bf", name = "figure"},
fmt([[
\begin{{figure}}[htbp]
	\centering
	{fig}
	\caption{{{caption}}}
	\label{{fig:{label}}}
\end{{figure}}{}
]], {fig= fig_input(1), caption=i(2), label=i(3), i(0)}))


local subfigure = s({trig = "bsf", name = "subfigure"},
fmt([[
\begin{{figure}}[htbp]
	\begin{{subcaptionblock}}{{.4\textwidth}}
		\centering
		{fig_a}
		\caption{{{caption_a}}}
		\label{{fig:{label_a}}}
	\end{{subcaptionblock}}%
	\begin{{subcaptionblock}}{{.4\textwidth}}
		\centering
		{fig_b}
		\caption{{{caption_b}}}
		\label{{fig:{label_b}}}
	\end{{subcaptionblock}}%
	{fig_caption}
	{fig_label}
\end{{figure}}
]], {
	fig_a= fig_input(1), caption_a=i(2), label_a=i(3),
	fig_b= fig_input(4), caption_b=i(5), label_b=i(6),
	fig_caption=c(7, {sn(nil, {t("\\caption{"),i(1),t("}")}), t("")}),
	fig_label=c(8, {sn(nil, {t("\\label{fig:"),i(0),t("}")}), t("")}),
}))


return {
	list_snippet("li", "itemize"),
	list_snippet("le", "enumerate"),
	-- tikz
	tikz,
	tikz_dir("below"),
	tikz_dir("above"),
	tikz_dir("left"),
	tikz_dir("right"),
	s({trig = "tdraw", name = "tikz draw"},
		fmt("\\draw[{style}] ({start}) to [out={deg_out}, in={deg_in}] node [] {{{label}}} ({endn});{}",
		{
			style = tikz_style_node(1),
			start = tikz_id_node(2),
			deg_out = tikz_deg_node_a(3),
			deg_in = tikz_deg_node_b(4),
			label = i(5, "text"),
			endn = tikz_id_node(6),
			i(0,"")
		})
	),
	figure,
	subfigure,
}, {}
