M = {}

-- the normal goto type def does nothing if its
-- not a user made type. This bypasses that by detecting
-- the type using the hoverdoc then calling either go to definition
-- or go to type definition
function M.goto_def()
	local callback = function(results)
		local breaks_gototype = {
			"fn",
			"async fn",
			"type ",
		}
		local modifiers = {
			"pub%(crate%) ",
			"pub%(super%) ",
			"pub ",
			"",
		}
		local patterns = {}
		for _, item in ipairs(breaks_gototype) do
			for _, modifier in ipairs(modifiers) do
				local pattern = "rust\n" .. modifier .. item
				table.insert(patterns, pattern)
			end
		end

		for _, result in pairs(results) do
			local response = result["result"]
			if response ~= nil then
				local typedescr = response["contents"]["value"]
				for _, pattern in ipairs(patterns) do
					if string.match(typedescr, pattern) then
						vim.lsp.buf.definition()
						return
					end
				end

				vim.lsp.buf.type_definition()
				return
			end
		end
	end

	vim.lsp.buf_request_all(
		vim.api.nvim_get_current_buf(),
		'textDocument/hover',
		vim.lsp.util.make_position_params(),
		callback)
end

function M.open_rustdoc()
	local callback = function(results)
		local errors = {}
		local urls = {}
		for _, lsp in pairs(results) do
			if lsp["result"] then
				table.insert(urls, lsp["result"])
			elseif lsp["error"] then
				table.insert(errors, lsp["error"])
			else
				-- no lsp response
			end
		end

		if #urls == 0 then
			error("no lsp set up that could provide an external doc url")
			return
		end
		if #urls > 1 then
			warn("got multiple urls, opening first")
		end

		vim.fn['netrw#BrowseX'](urls[1], 0)
	end

	vim.lsp.buf_request_all(
		vim.api.nvim_get_current_buf(),
		'experimental/externalDocs',
		vim.lsp.util.make_position_params(),
		callback)
end

return M
