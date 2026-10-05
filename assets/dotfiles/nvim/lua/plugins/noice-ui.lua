return {
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					-- ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			routes = {
				{
					filter = {
						event = "notify",
						find = "NO_RESULT_CALLBACK_FOUND",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "notify",
						min_height = 1,
					},
					view = "notify",
				},
			},
			views = {
				notify = {
					backend = "notify",
				},
			},
			cmdline = {
			enabled = true,
			view = "cmdline_popup",
			opts = {},
				format = {
				cmdline = { pattern = "^:", icon = "", lang = "vim" },
				search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
				search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
				filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
				lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
				help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
				input = { view = "cmdline_input", icon = "󰥻 " },
			},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				opts = {
					background_color = "#000000"
				},
				-- branch = "fix/fix_index_value",
			},
		}
	}
}
