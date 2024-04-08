local func = require("functions")

vim.api.nvim_create_user_command(
	"LuaSnipEdit",
	function() require("luasnip.loaders.from_lua").edit_snippet_files() end,
	{ desc = "edit lua file" }
)

vim.api.nvim_create_user_command(
	"Unmap",
	func.undo_custom_remaps,
	{ desc = "undo custom remappings" }
)

vim.api.nvim_create_user_command(
	"Remap",
	func.apply_custom_remaps,
	{ desc = "redo custom remappings" }
)
