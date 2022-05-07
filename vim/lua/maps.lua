local func = require("functions")
local map = vim.api.nvim_set_keymap
local silent = { noremap = true, silent = true }

vim.g.mapleader = " "
local keymaps = {}

keymaps[#keymaps+1] = {"<leader><leader>", "<C-^>", description="switch to prev buffer"}
vim.keymap.set('n', ";", ":", {noremap = true})
vim.keymap.set('n', ":", ";", {noremap = true})

-- yank till end of line
keymaps[#keymaps+1] = {"Y", "y$", description="yank till end of line"}

-- make escape in terminal mode go to normal mode
-- note this does make us get stuck in terminal
-- apps which use esc
keymaps[#keymaps+1] = {"<ESC>", "<C-\\><C-n>"}

-- Signature help
-- for _, mode in pairs(modes) do
	-- map(mode, "<A-3>", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], options)
-- end

-- map("i", "<C-k>", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], options) -- control + k

-- Code navigation
keymaps[#keymaps+1] = {"gd", vim.lsp.buf.definition, description="go to definition"}
keymaps[#keymaps+1] = {"gD", vim.lsp.buf.declaration, description="go to declaration"}
keymaps[#keymaps+1] = {"gi", vim.lsp.buf.implementation, description="go to implementation"}
keymaps[#keymaps+1] = {"k", vim.lsp.buf.hover, description="show hover doc"}
keymaps[#keymaps+1] = {"<leader>p", vim.lsp.diagnostic.goto_prev, description="go to next issue"}
keymaps[#keymaps+1] = {"<leader>n", vim.lsp.diagnostic.goto_next, description="go to next issue"}
keymaps[#keymaps+1] = {"<leader>l", function() vim.diagnostic.open_float({scope="line"}) end,
description="show issues for the current line"}

--Lightspeed (movement)
keymaps[#keymaps+1] = {"r", [[<Plug>Lightspeed_s]]}
keymaps[#keymaps+1] = {"R", [[<Plug>Lightspeed_S]]}

-- auto format
keymaps[#keymaps+1] = {"<leader>f", vim.lsp.buf.formatting, description="auto format the curren buffer"}
keymaps[#keymaps+1] = {"cr", vim.lsp.buf.rename, "rename token under cursor"}
keymaps[#keymaps+1] = {"<leader>a", vim.lsp.buf.code_action, "show lsp code actions"}

-- gui tools
keymaps[#keymaps+1] = {"<leader>d", ":NvimTreeToggle<CR>"}

-- Gitsigns
keymaps[#keymaps+1] = {"<leader>hp", require'gitsigns'.preview_hunk, decription ="git diff at cursor"}


local builtin = require("telescope.builtin")
keymaps[#keymaps+1] = {"\\\\", builtin.resume, description = "resume previous picker"}
keymaps[#keymaps+1] = {"<leader>o", builtin.find_files, description = "live grep over files"}
keymaps[#keymaps+1] = {"<leader>r", builtin.live_grep, description = "live grep through all files"}
keymaps[#keymaps+1] = {"<leader>b", builtin.buffers, description = "pick a buffer"}
keymaps[#keymaps+1] = {"<leader>s", builtin.lsp_workspace_symbols, description = "list symbols in the current workspace"}
keymaps[#keymaps+1] = {"<leader>e", builtin.diagnostics, description = "list all lsp issues"}
keymaps[#keymaps+1] = {"<leader>E", function() builtin.diagnostics({bufnr=0}) end, description="list lsp issues for current buffer"}
keymaps[#keymaps+1] = {"gr", builtin.lsp_references, description="list lsp references for word under cursor"}

keymaps[#keymaps+1] = {"<leader>u", require'functions'.func_def_scope, description = "pick a function definition"}

-- toggle terminal
keymaps[#keymaps+1] = {"<leader>t", ":ToggleTerm<CR>", description = "open terminal in split" }

-- lua snip (rest is in cmp)
map("i", "^[2", "<Plug>luasnip-next-choice<CR>", silent)

local move_magic = "<C-\\><C-N><C-w>"
local resize_magic = "<C-\\><C-N><C-w>"
for dir, resize_str in pairs({up="-", down="+", left=">", right="<"}) do
	keymaps[#keymaps+1] = {"<C-"..dir..">", move_magic .. "<"..dir..">",
	description = "move one window "..dir, mode = { 'n', 'i', 't' }}

	keymaps[#keymaps+1] = {"<A-"..dir..">", resize_magic .. resize_str,
	description = "change window size "..dir, mode = { 'n', 'i', 't' }}
end

local ls = require("luasnip")
local function choice_node()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end
keymaps[#keymaps+1] = {"A-2", choice_node, mode = { 'i', 's' }, description = "go to next snippet choice"}

require("legendary").setup()
require("legendary").bind_keymaps(keymaps)
require("which-key").setup {}









-- attempt to map cmp here, not yet easy/possible
-- local cmp = require('cmp')
-- local function next()
-- 	if cmp.visible() then
-- 		cmp.select_next_item()
-- 	else
-- 		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
-- 		pcall(vim.api.nvim_win_set_cursor, 0, {row+1, col})
-- 	end
-- end
-- keymaps[#keymaps+1] = {"<down>", next, description = "test", mode = { 'n', 'i' }}

-- local function select()
-- 	if ls.expand_or_locally_jumpable() then
-- 		ls.expand_or_jump()
-- 	elseif func.has_words_before() then
-- 		cmp.complete()
-- 	else
-- 		cmp.confirm()
-- 	end
-- end
-- keymaps[#keymaps+1] = {"<Tab>", select, description = "test", mode = { 'n', 'i' }}

-- -- Prosesitter
-- local opt = { noremap = true, silent = true, nowait = true }
-- function Hover()
-- 	if not require('prosesitter').popup() then
-- 		vim.lsp.buf.hover()
-- 	end
-- end

-- local cmd = ":lua Hover()<CR>"
-- vim.api.nvim_set_keymap("n", ",", cmd, opt)

