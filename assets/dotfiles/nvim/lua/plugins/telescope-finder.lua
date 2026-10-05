return {
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = {
			defaults = {
				file_ignore_patterns = {
					"node_modules", "%.jpg", "%.png", "%.webp", "%.pdf",
					"%.odt", "%.ico"
				}
			}
		}
	},
	{
		'nvim-telescope/telescope-project.nvim',
		dependencies = {
			'nvim-telescope/telescope.nvim',
		},
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
	}
}
