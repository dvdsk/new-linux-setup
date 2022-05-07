local commands = {
	{
		"LuaSnipEdit",
		function() require("luasnip.loaders.from_lua").edit_snippet_files() end,
		description="edit lua file"
	},
}

require("legendary").bind_commands(commands)
