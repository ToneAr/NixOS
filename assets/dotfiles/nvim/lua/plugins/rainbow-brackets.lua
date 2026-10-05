return {
	{
		'HiPhish/rainbow-delimiters.nvim',

		event = { 'BufReadPre', 'BufNewFile' },
		config = function()
			local rainbow_delimiters = require 'rainbow-delimiters'
			vim.g.rainbow_delimiters = {
				strategy = {
					[''] = rainbow_delimiters.strategy['global'],
					vim = rainbow_delimiters.strategy['local'],
				},
				query = {
					[''] = 'rainbow-delimiters',
					lua = 'rainbow-blocks',
				},
				priority = {
					[''] = 110,
					lua = 210,
				},
				highlight = {
					'RainbowDelimiterOne',
					'RainbowDelimiterTwo',
					'RainbowDelimiterThree',
					'RainbowDelimiterFour',
					'RainbowDelimiterFive',
					'RainbowDelimiterSix',
				},
				blacklist = {},
			}
		end,
	},
	{
		'luochen1990/rainbow',
		event = { 'BufReadPre', 'BufNewFile' },
		init = function()
			vim.g.rainbow_active = 1
		end,
		config = function()
			vim.g.rainbow_conf = {
				separately = {
					wolfram = {
						parentheses = {
							'start=/\\[/ end=/\\]/ fold',
							'start=/{/ end=/}/ fold',
							'start=/<|/ end=/|>/ fold',
							'start=/(\\(\\*\\)\\@!/ end=/\\(\\*\\)\\@!)/ fold'
						}
					}
				},
				guifgs = {
					'RainbowDelimiterOne',
					'RainbowDelimiterTwo',
					'RainbowDelimiterThree',
					'RainbowDelimiterFour',
					'RainbowDelimiterFive',
					'RainbowDelimiterSix',
				},
				strict = true,
				tailwind = true,
				transparency = 0.5,
				show_in_active_only = true,
				max_file_lines = 10000,
			}
			vim.cmd('RainbowToggleOn')
		end,
	},
}
