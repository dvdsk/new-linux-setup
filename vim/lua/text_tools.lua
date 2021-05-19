--[[ -- vim rooter
-- vim.g.rooter_pattern = {'src'}
vim.g["rooter_pattern"] = {'src'} ]]

-- which key
require"which-key".setup {}

require"kommentary.config".configure_language("default", {
	prefer_single_line_comments = true,
})
