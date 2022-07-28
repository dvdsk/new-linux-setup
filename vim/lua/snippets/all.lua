-- https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua
local ls = require("luasnip")

local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local fmt = require("luasnip.extras.fmt").fmt
local util = require("util")

local GREEK_ALPHABET = {
	{upper = "Α", lower = "α", name = "alpha" },
	{upper = "Β", lower = "β", name = "beta" },
	{upper = "Γ", lower = "γ", name = "gamma" },
	{upper = "Δ", lower = "δ", name = "delta" },
	{upper = "Ε", lower = "ε", name = "epsilon" },
	{upper = "Ζ", lower = "ζ", name = "zeta" },
	{upper = "Η", lower = "η", name = "eta" },
	{upper = "Θ", lower = "θ", name = "theta" },
	{upper = "Ι", lower = "ι", name = "iota" },
	{upper = "Κ", lower = "κ", name = "kappa" },
	{upper = "Λ", lower = "λ", name = "lambda" },
	{upper = "Μ", lower = "μ", name = "mu" },
	{upper = "Ν", lower = "ν", name = "nu" },
	{upper = "Ξ", lower = "ξ", name = "xi" },
	{upper = "Ο", lower = "ο", name = "omicron" },
	{upper = "Π", lower = "π", name = "pi" },
	{upper = "Ρ", lower = "ρ", name = "rho" },
	{upper = "Σ", lower = "σ", name = "sigma" },
	{upper = "Τ", lower = "τ", name = "tau" },
	{upper = "Υ", lower = "υ", name = "upsilon" },
	{upper = "Φ", lower = "φ", name = "phi" },
	{upper = "Χ", lower = "χ", name = "chi" },
	{upper = "Ψ", lower = "ψ", name = "psi" },
}

local function add_greek_alphabet_snips(list)
	for _, letter in ipairs(GREEK_ALPHABET) do
		list[#list+1] = s({trig=letter.name}, t(letter.lower))
		list[#list+1] = s({trig=util.uppercase_first(letter.name)}, t(letter.upper))
	end
end

local snips = {}
add_greek_alphabet_snips(snips)
require("snippets/helpers_all/todo")(snips)

return snips, {}
