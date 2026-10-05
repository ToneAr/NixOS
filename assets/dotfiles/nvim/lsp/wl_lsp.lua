--- @type vim.lsp.Config
return {
	name = "wl_lsp",
	cmd = {
		"wolframscript",
		"-noinit",
		"-noprompt",
		"-nopaclet",
		"-noicon",
		"-nostartuppaclets",
		"-run",
		"'Needs[\"LSPServer`\"];LSPServer`StartServer[]'"
	},
	filetypes = { "wl", "wolfram" },
	root_markers = { 'PacletInfo.wl', 'PacletInfo.m', '.git' },
	single_file_support = true,
	-- root_dir = function(fname)
	-- 	if type(fname) ~= "string" then
	-- 		return nil
	-- 	end
	-- 	return vim.fs.root(fname, { "PacletInfo.wl", "PacletInfo.m", ".git" }) or vim.fs.dirname(fname)
	-- end,
}
