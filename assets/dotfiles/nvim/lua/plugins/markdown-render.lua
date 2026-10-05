return {
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' },
		ft = { "markdown", "codecompanion" },
		opts = {
			render_modes = { "n", "v" },

			heading = {
				enabled = true,
				sign = true,
				icons = { ' ', '> ', '>> ', '>>> ', '>>>> ', ' ' },
				border = false,
				below = '▁',
				width = 'full',
				left_pad = 0,
				right_pad = 0,
				backgrounds = {
					'RenderMarkdownH1Bg',
					'RenderMarkdownH2Bg',
					'RenderMarkdownH3Bg',
					'RenderMarkdownH4Bg',
					'RenderMarkdownH5Bg',
					'RenderMarkdownH6Bg',
				},
				foregrounds = {
					'RenderMarkdownH1',
					'RenderMarkdownH2',
					'RenderMarkdownH3',
					'RenderMarkdownH4',
					'RenderMarkdownH5',
					'RenderMarkdownH6',
				},
			},

			-- Code block styling
			code = {
				enabled = true,
				sign = true,
				-- Style of code block border
				style = 'full',
				-- Highlight language name
				language_name = true,
				language_border = ' ',
				language_left = '',
				language_right = '',
				language_pad = 0,
				width = 'block',
				min_width = 60,
				right_pad = 4,
				left_pad = 4,
				-- Add border above/below code blocks
				above = '▀',
				below = '▄',
			},

			-- Bullet list styling
			bullet = {
				enabled = true,
				-- Use different icons for different list levels
				icons = { '●', '○', '◆', '◇' },
				right_pad = 1,
			},

			-- Checkbox styling
			checkbox = {
				enabled = true,
				position = 'inline',
				unchecked = { icon = '󰄱 ' },
				checked = { icon = '󰄲 ' },
				-- Custom state support
				custom = {
					todo = { raw = '[-]', rendered = '󰥔 ', highlight = 'DiagnosticWarn' },
				},
			},

			-- Quote block styling
			quote = {
				enabled = true,
				icon = '▐',
				repeat_linebreak = true,
			},

			-- Table styling
			pipe_table = {
				enabled = true,
				preset = 'round',
				style = 'full',
				cell = 'padded',
				min_width = 0,
				alignment_indicator = '━',
				head = 'overlay',
				row = 'overlay',
			},

			-- Link styling
			link = {
				enabled = true,
				-- Show link icon
				image = '󰥶 ',
				email = '󰀓 ',
				hyperlink = '󰌹 ',
				wiki = { icon = '󰂺 ', highlight = 'RenderMarkdownLink' },
				-- Highlight custom links
				custom = {
					web = { pattern = '^http[s]?://', icon = '󰇧 ' },
				},
			},

			-- Sign column configuration
			sign = {
				enabled = true,
				-- Show signs in sign column
				highlight = 'RenderMarkdownSign',
			},

			-- Horizontal rule styling
			dash = {
				enabled = true,
				icon = '─',
				width = 'full',
			},

			-- Callout blocks (GitHub-style alerts)
			callout = {
				note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'DiagnosticInfo' },
				tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'DiagnosticOk' },
				important = { raw = '[!IMPORTANT]', rendered = '󰀪 Important', highlight = 'DiagnosticHint' },
				warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'DiagnosticWarn' },
				caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'DiagnosticError' },
				-- Add custom callout types
				todo = { raw = '[!TODO]', rendered = '󰄲 Todo', highlight = 'Todo' },
			},

			-- Window options for floating windows
			win_options = {
				concealcursor = {
					-- Conceal in normal mode, show in insert/visual
					default = vim.api.nvim_get_option_value('concealcursor', {}),
					rendered = 'nc',
				},
				conceallevel = {
					default = vim.api.nvim_get_option_value('conceallevel', {}),
					rendered = 3,
				},
			},
		},
	},
};
