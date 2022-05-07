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

local function get_result_type(position)
	return d(position, function()
		local nodes = {}

		-- local row = vim.api.nvim.cur // TODO limit search
		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		for _, line in ipairs(lines) do
			if line:match("eyre::Result") then
				table.insert(nodes, t "Result<()>")
				break
			end
		end

		return sn(nil, c(1, { t"Result<(),()>", t"Result<()>" }))
	end, {})
end

local function struct_snip(trig, derive)
	return s({trig=trig, name="struct + derive "..derive},
	fmt("#[derive("..derive..")]\n"..[[
{}struct {{
	{}
}}
]], {c(1, {t(""), t("pub ")}), i(0)})
	)
end

return {
	s({trig="fno", name="function returning a option"},
	fmt([[
		fn {} ({}) -> Option<{}> {{
			{}
		}}
	]], {i(1, "name"), i(2, "args"), i(3, "rtype"), i(0)})
	),

	s({trig="fnr", name="function returning a result"},
	fmt([[
		fn {} ({}) -> {} {{
			{}
		}}
	]], {i(1, "name"), i(2, "args"), get_result_type(3), i(0)})
	),

	s({trig="dd", name="derive debug"}, t("#[Derive(Debug)]")),
	s({trig="ddc", name="derive debug, clone"}, t("#[Derive(Debug, Clone)]")),
	s({trig="ddcc", name="derive debug, clone, copy"}, t("#[Derive(Debug, Clone, Copy)]")),
	s({trig="dds", name="derive debug, serialize"}, t("#[Derive(Debug, Clone, Serialize, Deserialize)]")),

	struct_snip("sd", "Debug"),
	struct_snip("sdc", "Debug, Clone"),
	struct_snip("sdcc", "Debug, Clone, Copy"),
	struct_snip("sds", "Debug, Clone, Serialize, Deserialize"),
}, {}
