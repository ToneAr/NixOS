return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	ft = "markdown",
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "~/Documents/Personal",
			},
			{
				name = "work",
				path = "~/Documents/WREL",
			},
		},
	},
	config = function(opts)
		require"obsidian".setup(opts)
	end
}
