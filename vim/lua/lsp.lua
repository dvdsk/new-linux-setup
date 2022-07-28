-- list of installable lang-servers
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md
--
local lsp = require("lspconfig")

local null_ls = require("null-ls")
null_ls.setup({
	sources = { null_ls.builtins.diagnostics.vale }
})

local function lua_lsp(lsp, on_attach)
	local lsp_root = vim.fn.system("echo -n $HOME/.local/share/lua-language-server")
	local lsp_binary = lsp_root .. "/bin/lua-language-server"
	lsp.sumneko_lua.setup({
		on_attach = on_attach,
		cmd = { lsp_binary, "-E", lsp_root .. "/main.lua" },
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					globals = { "vim" }, -- Get the language server to recognize the `vim` global
				},
				workspace = {
					library = { -- Make the server aware of Neovim runtime files
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					},
				},
				telemetry = {
					enable = false,
				},
			},
		},
	})
end

-- on attach is not used right now but could be used by other
-- plugins in the future
local function setup(on_attach)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
	-- capabilities.textDocument.completion.completionItem.snippetSupport = true

	lsp.rust_analyzer.setup({
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

	lsp.pylsp.setup({ on_attach = on_attach }) -- python
	lsp.texlab.setup({ on_attach = on_attach }) -- latex
	lsp.jsonls.setup({ capabilities = capabilities }) --json
	lsp.bashls.setup({ on_attach = on_attach }) -- bash
	lsp.ltex.setup({ filetypes = { -- default + `mail`
		"bib",
		"gitcommit",
		"markdown",
		"org",
		"plaintext",
		"text",
		"rst",
		"rnoweb",
		"tex",
		"mail"
	}
	})
	lua_lsp(lsp, on_attach)
	-- needs a compile_commands.json file; easiest to generate
	-- using bear; `make clean; bear -- make`
	lsp.clangd.setup({ -- c++ and c
		on_attach = on_attach,
		filetypes = { "c", "cpp", "hpp", "cc" },
	})
end

setup()
