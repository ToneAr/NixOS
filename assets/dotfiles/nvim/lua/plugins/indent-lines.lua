return {
	{ "lukas-reineke/virt-column.nvim",
		opts = {
			char = "│",
			virtcolumn = "80,100",
			exclude = {
				filetypes = {
					"alpha", "oil", "markdown", "codecompanion"
				},
			}
		}
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "▎",
				tab_char = "▎",
				highlight = "IblIndent",
			},
			whitespace = {
				highlight = "IblWhitespace",
			},
			scope = {
				enabled = false,
			}
		},
		config = function (_, opts)
			require"ibl".setup(opts)
		end
	}
}
