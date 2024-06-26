local looks = require("looks")

local theme = {}
theme.is_set = false

local function solarized()
	vim.g.solarized_italic_comments = true
	vim.g.solarized_italic_keywords = true
	vim.g.solarized_italic_functions = true
	vim.g.solarized_italic_variables = false
	vim.g.solarized_contrast = true
	vim.g.solarized_borders = false
	vim.g.solarized_disable_background = false
	require("solarized").set()
end

function theme:set_light()
	if vim.o.background ~= "light" or not self.is_set then
		self.is_set = true
		vim.o.background = "light"
		solarized()
		looks:lualine( "solarized")
	end
end

function theme:set_dark()
	if vim.o.background ~= "dark" or not self.is_set then
		self.is_set = true
		vim.o.background = "dark"
		vim.g.tokyonight_style = "storm"
		vim.cmd("colorscheme tokyonight")
		looks:lualine( "tokyonight")
	end
end

function theme:set()
	local f = io.open("/tmp/darkmode", "r")
	if f ~= nil then
		self:set_dark()
		return
	end

	local hour = os.date("*t").hour
	if hour >= 5 and hour < 21 then
		self:set_light()
	else
		self:set_dark()
	end
end

theme:set()
-- vim.o.background="dark"
-- vim.g.gruvbox_material_background = "hard"
-- vim.g.gruvbox_material_enable_bold = true
-- vim.cmd("colorscheme gruvbox-material")
-- looks:lualine("gruvbox")
