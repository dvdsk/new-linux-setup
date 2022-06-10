local ls = require("luasnip")
local ts_utils = require 'nvim-treesitter.ts_utils'

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local fmt = require("luasnip.extras.fmt").fmt

local function is_relevant_import(node, name)
	if node:type() ~= "use_declaration" then
		return false
	end

	local path_text = vim.treesitter.query.get_node_text(node);
	return string.find(path_text, name)
end

local function search_level(start_node, name) 
	if is_relevant_import(start_node, name) then 
		return true
	end

	local node = start_node:prev_sibling()
	while node ~= nil do
		if is_relevant_import(node, name) then 
			return true
		end
		local node = node:prev_sibling()
	end

	local node = start_node:next_sibling()
	while node ~= nil do
		if is_relevant_import(node, name) then 
			return true
		end
		local node = node:next_sibling()
	end
	return false
end

local function has_import(name) 
	local start_node = ts_utils.get_node_at_cursor()
	if search_level(start_node, name) then
		return true
	end

	local parent = start_node:parent()
	while parent ~= nil do
		if search_level(start_node, name) then
			return true
		end
	end

	return false
end

local function get_result_type(position)
	return d(position, function()
		local nodes = {}
		if has_import("Result") then
			nodes[1] = sn(nil, fmt([[Result<{}>]], {i(0,"()")} ))
		end

		nodes[#nodes+1] = sn(nil, fmt([[Result<{},{}>]], {i(1,"()"), i(0,"()")})) 
		return sn(nil, c(1, nodes))
	end, {})
end

local function is_test_mod(node) 
	if node:type() == "mod_item" then
		local body = node:named_child(1)
		if body ~= nil then
			return true
		end
	end
	return false
end

local function in_test_scope()
	local here = ts_utils.get_node_at_cursor()
	if is_test_mod(here) then
		return true
	end

	local node = here:parent()
	while node ~= nil do
		if is_test_mod(node) then
			return true
		end

		node = node:parent()
	end
	return false
end


local function in_test_env()
	local path = vim.api.nvim_buf_get_name(0);
	local in_test_file = string.find(path, "test")
	return in_test_file or in_test_scope()
end

-- TODO if tokio imported switch make test a choice node 
-- with tokio::test as first choice
local function test_mod_or_function()
	if in_test_env() then
		return sn(nil, fmt([[
			#[test]
			fn {} () {{
				{}
			}}
		]], {i(1, "name"), i(0)}
		))
	else 
		return sn(nil, fmt([[
			#[cfg(test)]
			mod test {{
				use super::*;
				{}
			}}
		]], {i(0)}))
	end
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

	s({trig="ut", name="unit test"}, {
		d(1, test_mod_or_function)
	}),

	s({trig="dd", name="derive debug"}, t("#[Derive(Debug)]")),
	s({trig="ddc", name="derive debug, clone"}, t("#[Derive(Debug, Clone)]")),
	s({trig="ddcc", name="derive debug, clone, copy"}, t("#[Derive(Debug, Clone, Copy)]")),
	s({trig="dds", name="derive debug, serialize"}, t("#[Derive(Debug, Clone, Serialize, Deserialize)]")),

	struct_snip("sd", "Debug"),
	struct_snip("sdc", "Debug, Clone"),
	struct_snip("sdcc", "Debug, Clone, Copy"),
	struct_snip("sds", "Debug, Clone, Serialize, Deserialize"),
}, {}
