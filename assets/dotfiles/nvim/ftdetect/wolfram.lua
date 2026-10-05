vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.wl", "*.m", "*.wls", "*.mt" },
	callback = function()
		vim.bo.filetype = "wolfram"
	end,
})
