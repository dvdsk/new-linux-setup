-- which key
require("which-key").setup {}

require("kommentary.config").configure_language("default", {
	prefer_single_line_comments = true,
})

-- require("telescope").load_extension("prosesitter")
-- require("prosesitter"):setup({
-- 	auto_enable = true, -- default true
-- })
