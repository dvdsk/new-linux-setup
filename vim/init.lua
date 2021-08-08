-- installs plugins
require("plugins")

require("settings")
require("maps")
require("maps_plugins")

-- these files mirrors those above in the package section
-- and contain configurations
require("theme")
require("looks")
require("gui_tools")
require("text_tools")
require("treesitter")

require("comp")
require("lsp")

local saga = require("lspsaga")
saga.init_lsp_saga()

-- testing etc:
-- vim.cmd("packadd prosesitter.nvim")
-- require("prosesitter").setup()
