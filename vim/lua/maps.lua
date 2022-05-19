local func = require("functions")

vim.g.mapleader = " "

-- switch to prev buffer
vim.keymap.set('n', "<leader><leader>", "<C-^>")
vim.keymap.set({'n','v'}, ";", ":", {noremap = true})
vim.keymap.set({'n','v'}, ":", ";", {noremap = true})

-- yank till end of line
vim.keymap.set('n', "Y", "y$")

-- make escape in terminal mode go to normal mode
-- note this does make us get stuck in terminal
-- apps which use esc
vim.keymap.set('n', "<ESC>", "<C-\\><C-n>" )

-- Signature help
vim.keymap.set({'i','n'}, "<A-3>", vim.lsp.buf.signature_help)

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
vim.keymap.set('n', "<leader>p", vim.lsp.diagnostic.goto_prev)
-- go to next issue
vim.keymap.set('n', "<leader>n", vim.lsp.diagnostic.goto_next)
-- show issues for the current line
vim.keymap.set('n', "<leader>l", function() vim.diagnostic.open_float({scope="line"}) end)


--Lightspeed (movement)
vim.keymap.set('n', "r", [[<Plug>Lightspeed_s]])
vim.keymap.set('n', "R", [[<Plug>Lightspeed_S]])


-- Harpoon 
for i = 1,5,1 do
	local fn = function() require("harpoon.ui").nav_file(i) end
	vim.keymap.set('n', "<C-"..tostring(i+5)..">", fn)
end
vim.keymap.set('n', "<C><C>", require"harpoon.mark".add_file)
vim.keymap.set('n', "<leader>hh", require"harpoon.ui".toggle_quick_menu)


-- auto format the curren buffer
vim.keymap.set('n', "<leader>f", vim.lsp.buf.formatting)
-- rename token under cursor
vim.keymap.set('n', "cr", vim.lsp.buf.rename)
-- show lsp code actions
vim.keymap.set('n', "<leader>a", vim.lsp.buf.code_action)

-- git diff at cursor
vim.keymap.set('n', "<leader>hp", require'gitsigns'.preview_hunk)


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
vim.keymap.set('n', "<leader>E", function() builtin.diagnostics({bufnr=0}) end)
-- list lsp references for word under cursor
vim.keymap.set('n', "gr", builtin.lsp_references)

--  pick a function definition
vim.keymap.set('n', "<leader>u", require'functions'.func_def_scope)

-- toggle terminal
--  open terminal in split 
vim.keymap.set('n', "<leader>t", ":ToggleTerm<CR>")

-- lua snip (rest is in cmp)
local silent = { noremap = true, silent = true }
vim.api.nvim_set_keymap("i", "^[2", "<Plug>luasnip-next-choice<CR>", silent)

local move_magic = "<C-\\><C-N><C-w>"
local resize_magic = "<C-\\><C-N><C-w>"
for dir, resize_str in pairs({up="-", down="+", left=">", right="<"}) do
	-- move one window 
	vim.keymap.set({'n','i','t'}, "<C-"..dir..">", move_magic .. "<"..dir..">")
	vim.keymap.set({'n','i','t'}, "<A-"..dir..">", resize_magic .. resize_str)
end

local ls = require("luasnip")
local function choice_node()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end

--  go to next snippet choice
vim.keymap.set({'i', 's'}, "A-2", choice_node)

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

