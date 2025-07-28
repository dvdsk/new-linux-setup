local func = require("functions")
local lsp = require("lsp")

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

vim.api.nvim_create_user_command(
	"LspCodeAction",
	func.lsp_code_action_by_prefix,
	{
		nargs = 1,
		desc = "perform the lsp code action that matches the provided prefix",
		complete = function(_, _, _)
			return func.lst_list_code_actions()
		end,

	}
)

vim.api.nvim_create_user_command(
	"RustcDev",
	lsp.setup_rustc_dev,
	{ desc = "configure the rust-analyzer lsp for rustc development" }
)
