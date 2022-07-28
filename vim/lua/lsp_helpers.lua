M = {}

function M.open_rustdoc()
	local callback = function(err, url)
		if err then
			error(tostring(err))
		else
			vim.fn['netrw#BrowseX'](url, 0)
		end
	end

	vim.lsp.buf_request(
		vim.api.nvim_get_current_buf(),
		'experimental/externalDocs',
		vim.lsp.util.make_position_params(),
		callback)
end

return M
