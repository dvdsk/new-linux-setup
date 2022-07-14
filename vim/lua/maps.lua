local func = require("functions")

vim.g.mapleader = " "

-- apply "controversial" remaps such as
-- specific remaps to work without arrow keys on colemak
-- and switch : and ;
func.apply_custom_remaps()

-- switch to prev buffer
vim.keymap.set('n', "<leader><leader>", "<C-^>")

-- yank till end of line
vim.keymap.set('n', "Y", "y$")

-- make escape in terminal mode go to normal mode
-- note this does make us get stuck in terminal
-- apps which use esc
vim.keymap.set('t', "<ESC>", "<C-\\><C-n>")

-- Signature help
vim.keymap.set({ 'i', 'n' }, "<A-3>", vim.lsp.buf.signature_help)
-- Code navigation
-- go to definition
vim.keymap.set('n', "gd", vim.lsp.buf.definition)
-- go to declaration
vim.keymap.set('n', "gD", vim.lsp.buf.declaration)
-- go to implementation
vim.keymap.set('n', "gi", vim.lsp.buf.implementation)
-- show hover doc
vim.keymap.set('n', "k", vim.lsp.buf.hover)
-- go to next issue
vim.keymap.set('n', "<leader>p", vim.diagnostic.goto_prev)
-- go to next issue
vim.keymap.set('n', "<leader>n", vim.diagnostic.goto_next)
-- show issues for the current line
vim.keymap.set('n', "<leader>l", function() vim.diagnostic.open_float({ scope = "line" }) end)


--Lightspeed (movement)
vim.keymap.set('n', "r", [[<Plug>Lightspeed_s]])
vim.keymap.set('n', "R", [[<Plug>Lightspeed_S]])


-- Harpoon
for i = 1, 5, 1 do
	local fn = function() require("harpoon.ui").nav_file(i) end
	vim.keymap.set('n', "<C-" .. tostring(i + 5) .. ">", fn)
end
vim.keymap.set({ 'n', 'i' }, "<A-7>", require "harpoon.mark".add_file)
vim.keymap.set({ 'n', 'i' }, "<A-5>", require "harpoon.ui".toggle_quick_menu)

vim.keymap.set({ 'n', 'i' }, "<A-6>", func.open_terminal)

-- save button
vim.keymap.set('n', "<A-4>", ":w<CR>")
-- auto format the curren buffer
vim.keymap.set('n', "<leader>f", vim.lsp.buf.format)
-- rename token under cursor
vim.keymap.set('n', "cr", vim.lsp.buf.rename)
-- show lsp code actions
vim.keymap.set('n', "<leader>a", vim.lsp.buf.code_action)

-- git diff at cursor
vim.keymap.set('n', "<leader>hp", require 'gitsigns'.preview_hunk)


local builtin = require("telescope.builtin")
--  resume previous picker
vim.keymap.set('n', "\\\\", builtin.resume)
--  live grep over files
vim.keymap.set('n', "<leader>o", builtin.find_files)
--  live grep through all files
vim.keymap.set('n', "<leader>r", builtin.live_grep)
--  pick a buffer
vim.keymap.set('n', "<leader>b", builtin.buffers)
--  list symbols in the current workspace
vim.keymap.set('n', "<leader>s", builtin.lsp_workspace_symbols)
--  list all lsp issues
vim.keymap.set('n', "<leader>e", builtin.diagnostics)
-- list lsp issues for current buffer
vim.keymap.set('n', "<leader>E", function() builtin.diagnostics({ bufnr = 0 }) end)
-- list lsp references for word under cursor
vim.keymap.set('n', "gr", builtin.lsp_references)

--  pick a function definition
vim.keymap.set('n', "<leader>u", func.func_def_scope)

-- make item more public
vim.keymap.set({'n','i'}, "<A-0>", func.more_pub)


local move_magic = "<C-\\><C-N><C-w>"
local resize_magic = "<C-\\><C-N><C-w>"
for dir, resize_str in pairs({ up = "-", down = "+", left = ">", right = "<" }) do
	-- move one window
	vim.keymap.set({ 'n', 'i', 't' }, "<C-" .. dir .. ">", move_magic .. "<" .. dir .. ">")
	vim.keymap.set({ 'n', 'i', 't' }, "<A-" .. dir .. ">", resize_magic .. resize_str)
end

local ls = require("luasnip")
local function choice_node()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end

--  go to next snippet choice
vim.keymap.set({ 'i', 's' }, "<A-2>", choice_node)
