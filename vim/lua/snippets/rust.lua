local ls = require("luasnip")
local ts_utils = require 'nvim-treesitter.ts_utils'

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node

local fmt = require("luasnip.extras.fmt").fmt

local function is_relevant_import(node, name)
	if node:type() ~= "use_declaration" then
		return false
	end

	local path_text = vim.treesitter.get_node_text(node, 0);
	return string.find(path_text, name)
end

local function search_level(start_node, name)
	-- we can skip checking the current node,
	-- it does not make sense to need to know the import
	-- on the same line as the import

	if start_node:type() == "source_file" then
		for child, _ in start_node:iter_children() do
			if is_relevant_import(child, name) then
				return true
			end
		end
	end

	local node = start_node:prev_sibling()
	while node ~= nil do
		if is_relevant_import(node, name) then
			return true
		end
		node = node:prev_sibling()
	end

	node = start_node:next_sibling()
	while node ~= nil do
		if is_relevant_import(node, name) then
			return true
		end
		node = node:next_sibling()
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
		if has_import("Result") then
			return sn(nil, fmt([[Result<{}>]], { i(0, "()") }))
		else
			return sn(nil, fmt([[Result<{},{}>]], { i(1, "()"), i(0, "()") }))
		end
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
			fn {}() {{
				{}
			}}
		]], { i(1, "name"), i(0) }
		))
	else
		return sn(nil, fmt([[
			#[cfg(test)]
			mod test {{
				use super::*;
				
				#[test]
				fn {}() {{
					{}
				}}
			}}
		]], { i(1, "name"), i(0) }))
	end
end

local function enum_snip(trig, derive)
	return s({ trig = trig, snippetType = "autosnippet", name = "enum + derive " .. derive },
		fmt("#[derive(" .. derive .. ")]\n" .. [[
{}enum {} {{
	{}
}}
]], { c(1, { t(""), t("pub ") }), i(2), i(0) })
	)
end

local function err_enum_snip()
	return s({ trig = "xtee", snippetType = "autosnippet", name = "thiserror enum" },
		fmt([[
#[derive(Debug, thiserror::Error)]
pub enum {} {{
	#[error("{}")]
	{},
}}
]], { i(1), i(0), i(2) }))
end

local function err_struct_snip()
	return s({ trig = "xtes", snippetType = "autosnippet", name = "thiserror enum" },
		fmt([[
#[derive(Debug, thiserror::Error)]
#[error("{}")]
pub struct {} {{
	{},
}}
]], { i(1), i(0), i(2) }))
end

local function struct_snip(trig, derive)
	return s({ trig = trig, snippetType = "autosnippet", name = "struct + derive " .. derive },
		fmt("#[derive(" .. derive .. ")]\n" .. [[
{}struct {{
	{}
}}
]], { c(1, { t(""), t("pub ") }), i(0) })
	)
end

local function fn_snippets()
	local vis_options = {
		["pc"] = "pub(crate) ",
		["ps"] = "pub(super) ",
		["p"] = "pub ",
		[""] = ""
	}
	local ret_options = {
		["o"] = { "-> Option<{}> ", i(3) },
		["r"] = { "-> {} ", get_result_type(3) },
		["c"] = { "-> {} ", i(3) },
		[" "] = { "{}", t("") },
	}
	-- todo check if in impl block and add a &self arg in that case

	local snippets = {}
	for prefix, vis in pairs(vis_options) do
		for suffix, rets in pairs(ret_options) do
			local ret = rets[1]
			local ret_node = rets[2]

			local trigger = "x" .. prefix .. "fn" .. suffix
			local fmt_str = vis .. "fn {}({}) " .. ret .. "{{\n\t{}\n}}"
			local fmt_node = fmt(fmt_str, { i(1), i(2), vim.deepcopy(ret_node), i(0) })
			local snippet = s({ trig = trigger, snippetType = "autosnippet" }, fmt_node)

			snippets[#snippets + 1] = snippet
		end
	end
	return snippets
end

return {
	s({ trig = "xut", snippetType = "autosnippet", name = "unit test" }, {
		d(1, test_mod_or_function)
	}),

	s({ trig = "dd ", snippetType = "autosnippet", name = "derive debug" }, t("#[derive(Debug)]")),
	s({ trig = "ddt", snippetType = "autosnippet", name = "derive debug, thiserror" },
		t("#[derive(Debug, thiserror::Error)]")),
	s({ trig = "ddc", snippetType = "autosnippet", name = "derive debug, clone" }, t("#[derive(Debug, Clone)]")),
	s({ trig = "ddcc", snippetType = "autosnippet", name = "derive debug, clone, copy" },
		t("#[derive(Debug, Clone, Copy)]")),
	s({ trig = "dds", snippetType = "autosnippet", name = "derive debug, serialize" },
		t("#[derive(Debug, Clone, Serialize, Deserialize)]")),

	s({ trig = "xcf", snippetType = "autosnippet", name = "config feature" }, {
		t("#[cfg(feature = \""), i(0), t("\")]")
	}),

	struct_snip("sd ", "Debug"),
	struct_snip("sdc", "Debug, Clone"),
	struct_snip("sds", "Debug, Clone, Serialize, Deserialize"),

	enum_snip("ed ", "Debug"),
	enum_snip("edc", "Debug, Clone"),
	enum_snip("eds", "Debug, Clone, Serialize, Deserialize"),

	err_enum_snip(),
	err_struct_snip(),
}, fn_snippets()
