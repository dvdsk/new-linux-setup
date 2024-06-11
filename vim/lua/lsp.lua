-- list of installable lang-servers
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md

require("mason").setup()
require("mason-lspconfig").setup {
	ensure_installed = {
		"lua_ls", "rust_analyzer",
		"jsonls", "bashls", "pylsp", "texlab", "ltex", "typos_lsp"
	},
}

local lsp = require("lspconfig")

-- local null_ls = require("null-ls")
-- null_ls.setup({
-- 	sources = { null_ls.builtins.diagnostics.vale }
-- })

-- on attach is not used right now but could be used by other
-- plugins in the future
local function setup(on_attach)
	local capabilities = require("cmp_nvim_lsp").default_capabilities()
	-- capabilities.textDocument.completion.completionItem.snippetSupport = true

	lsp.rust_analyzer.setup({
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

	lsp.pylsp.setup({
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
	lsp.gopls.setup {} -- go lang, let meson-lspconfig configure
	lsp.texlab.setup {} -- latex, let meson-lspconfig configure
	lsp.jsonls.setup {} --json, let meson-lspconfig configure
	lsp.bashls.setup {} -- bash, let meson-lspconfig configure
	lsp.ltex.setup({
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
	lsp.lua_ls.setup {} -- let meson-lspconfig do everything

	-- needs a compile_commands.json file; easiest to generate
	-- using bear; `make clean; bear -- make`
	lsp.clangd.setup({ -- c++ and c
		on_attach = on_attach,
		filetypes = { "c", "cpp", "hpp", "cc" },
	})
	lsp.typos_lsp.setup({
		filetypes = { "*" },
		config = "~/.config/nvim/typos.toml",
		init_options = {
			diagnosticSeverity = "Warning"
		}
	})
	lsp.vale_ls.setup {
		init_options = {
			configPath = "/home/david/.config/vale.ini",
			-- installVale = true,
		},
		root_dir = function () return vim.fn.expand('%:p:h') end,
		filetypes = {
			"markdown",
			"text",
			"mail",
		}
	}
end

setup()
