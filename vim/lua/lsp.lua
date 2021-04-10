-- list of installable lang-servers
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
--
local M = {}
local lsp = require 'lspconfig'

vim.lsp.set_log_level("debug")

-- on attach is not used right now but could be used by other
-- plugins in the future
function M.setup(on_attach)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	lsp.rust_analyzer.setup({
		on_attach=on_attach,
		capabilities = capabilities,
		settings = {
			["rust-analyzer"] = {
				assist = {
					importMergeBehavior = "last",
					importPrefix = "by_self",
				},
				cargo = {
					loadOutDirsFromCheck = true
				},
				procMacro = {
					enable = true
				},
			}
		}
	})

	lsp.pyls.setup{ on_attach=on_attach }   -- python
	lsp.texlab.setup{ on_attach=on_attach } -- latex
	lsp.bashls.setup{ on_attach=on_attach } -- bash
end

M.setup()
