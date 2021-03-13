local M = {}
local lsp = require 'lspconfig'

vim.lsp.set_log_level("debug")

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

	lsp.pyls.setup{ on_attach=on_attach }
end

return M
