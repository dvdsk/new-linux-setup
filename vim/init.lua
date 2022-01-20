-- installs plugins
require("plugins")

require("settings")
require("maps")

-- -- these files mirrors those in the plugin file
-- -- and contain configurations
require("theme")
require("looks")
require("gui_tools")
require("text_tools")
require("treesitter")
require("other")

require("comp")
require("lsp")
require("debuggers") -- debugger adapter


-- development
-- vim.cmd[[
-- 	:packadd prosesitter.nvim
-- ]]

-- require("telescope").load_extension("prosesitter")
-- require("prosesitter"):setup({
-- 	auto_enable = true, -- default true
-- })
