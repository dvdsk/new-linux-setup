vim.g['oceanic_next_terminal_bold'] = 1
vim.g['oceanic_next_terminal_italic'] = 1

local theme = {}
theme.is_set = false

function theme:set_light()
	if vim.g.background ~= 'light' or not self.is_set
	then
		self.is_set = true
		vim.g.background = 'light'
		vim.cmd [[colorscheme evening]]
		--[[ require('colorbuddy').colorscheme('solarized')
		vim.cmd [[colorscheme solarized]]
	end
end

function theme:set_dark()
	if vim.g.background ~= 'dark' or not self.is_set
	then
		self.is_set = true
		vim.g.background = 'dark'
		vim.cmd [[colorscheme OceanicNext]]
	end
end

function theme:set()
	local hour = os.date("*t").hour
	if hour >= 5 and hour < 21 
	then
		self:set_light()
	else
		self:set_dark()
	end
end

-- theme:set()
theme:set_dark()
