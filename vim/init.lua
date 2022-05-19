-- installs plugins
require("plugins")

require("settings")
require("maps")
require("commands")

-- -- these files mirrors those in the plugin file
-- -- and contain configurations
require("theme")
require("looks")
require("gui_tools")
require("text_tools")
require("treesitter")


require("comp") -- completions and snippets
require("lsp")
require("debuggers") -- debugger adapter
