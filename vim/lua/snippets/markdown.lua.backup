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

local function rec_ls(_,_,_,list)
	return sn(nil, {
		c(1, {
			-- important!! Having the sn(...) as the first choice will cause infinite recursion.
			t({""}),
			sn(nil, {t({"", list.." "}), i(1), d(2, rec_ls, nil, {user_args = {list}})}),
		}),
	});
end

local function list_snippet(trig, list)
	return s({trig = trig}, {
		t(list.." "),
		i(1),
		d(2, rec_ls, nil, {user_args = {list}}),
		i(0)
	})
end

return {
	list_snippet("li", "1."),
	list_snippet("le", "-"),
	s({trig = "quote", name = "quote"}, {
		t("> "), i(0, "quote")
	}),
	s({trig = "code", name = "code"}, {
		fmt([[
		'''{}
		{}
		'''
		]], {i(1, "language"), i(0, "code")})
	}),
}, {}
