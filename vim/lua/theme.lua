vim.g['oceanic_next_terminal_bold'] = 1
vim.g['oceanic_next_terminal_italic'] = 1

local theme = {}
theme.is_set = false

function theme:set_light()
	if vim.g.background ~= 'light' or not self.is_set
	then
		self.is_set = true
		vim.g.background = 'light'
		vim.api.nvim_command("colors edge")
		-- let g:clap_theme = 'solarized_dark'
		-- let g:airline_solarized_bg='light'
		-- set background=light
		-- AirlineTheme solarized
	end
end

function theme:set_dark()
	if vim.g.background ~= 'dark' or not self.is_set
	then
		self.is_set = true
		vim.g.background = 'dark'
		vim.api.nvim_command("colors OceanicNext")
		-- let g:clap_theme = 'nord'
		-- -- zenburn overwrites this so we need to reset it
		-- highlight Comment cterm=italic gui=italic
		-- AirlineTheme zenburn
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
