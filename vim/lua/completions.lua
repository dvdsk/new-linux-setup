local u = require 'utils'
local lsp = require 'lsp'

vim.o.completeopt = "menuone,noselect"

local on_attach = function(client)
	require 'completion'.on_attach(client)
end

lsp.setup(on_attach)

-- prevent completions from appearing inside clap
vim.api.nvim_command('autocmd FileType clap_input "let g:completion_enable_auto_pop = 0"')

