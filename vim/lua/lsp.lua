-- list of installable lang-servers
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md

require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = {
		"lua_ls", "rust_analyzer", "texlab", "ltex", "harper_ls",
		-- "pylsp", "bashls",
	},
}

local lsp = vim.lsp

-- local null_ls = require("null-ls")
-- null_ls.setup({
-- 	sources = { null_ls.builtins.diagnostics.vale }
-- })

-- on attach is not used right now but could be used by other
-- plugins in the future
local function setup(on_attach)
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	-- capabilities.textDocument.completion.completionItem.snippetSupport = true

	lsp.config('rust_analyzer', {
		-- cmd = { "rustup run stable rust-analyzer" },
		cmd = { "/home/david/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rust-analyzer" },
		-- cmd = { "rust-analyzer" },
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			["rust-analyzer"] = {
				assist = {
					importMergeBehavior = "module",
					importGranularity = "module",
				},
				cargo = {
					loadOutDirsFromCheck = true,
				},
				procMacro = {
					enable = true,
				},
			},
		},
	})

	lsp.config('pylsp', {
		on_attach = on_attach,
		settings = {
			pylsp = {
				plugins = {
					flake8 = { enabled = true },
					mypy = { enabled = true }
				}
			}
		}
	})
	lsp.config('gopls', {}) -- go lang, let meson-lspconfig configure
	lsp.config('texlab', {}) -- latex, let meson-lspconfig configure
	lsp.config('jsonls', {}) --json, let meson-lspconfig configure
	lsp.config('bashls', {}) -- bash, let meson-lspconfig configure
	lsp.config('ltex', {
		-- default with `mail` without `markdown` and `text
		-- those are now done by vale-ls
		filetypes = {
			"bib",
			"gitcommit",
			-- "markdown",
			-- "text",
			"org",
			"plaintext",
			"rst",
			"rnoweb",
			"tex",
			"mail",
			"adoc",
		}
	})
	lsp.config('lua_ls', {}) -- let meson-lspconfig do everything

	-- needs a compile_commands.json file; easiest to generate
	-- using bear; `make clean; bear -- make`
	lsp.config('clangd', { -- c++ and c
		on_attach = on_attach,
		filetypes = { "c", "cpp", "hpp", "cc" },
	})
	lsp.config('harper_ls', {
		settings = {
			["harper-ls"] = {
				userDictPath = "~/.config/nvim/harper_dict.txt",
				diagnosticSeverity = "hint",
				linters = {
					sentence_capitalization = false,
				},
			}
		},
	})
end

setup()
