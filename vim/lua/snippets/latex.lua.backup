local ls = require("luasnip")

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

ls.snippets.tex = {
	list_snippet("li", "itemize"),
	list_snippet("le", "enumerate"),
}
