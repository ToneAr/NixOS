return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = {
			'nvim-tree/nvim-web-devicons',
			'franco-ruggeri/codecompanion-lualine.nvim'
		},
		config = function()
			-- Use shared color utilities for complementary colors
			local color_utils = require('config.color-utils')

			-- Create solid color theme
			local function create_solid_theme()
				local accent = color_utils.get_accent_color()
				local fg = color_utils.get_fg_color()
				
				-- Generate complementary colors from the accent
				local colors = color_utils.generate_complementary_colors(accent)
				
				-- Create semi-transparent backgrounds for statusline
				local status_bg = color_utils.adjust_opacity(accent, 0.5, "#1a1a1a")
				local status_bg_inactive = color_utils.adjust_opacity(accent, 0.25, "#151515")

				return {
					normal = {
						a = { fg = fg, bg = status_bg },
						b = { fg = fg, bg = status_bg },
						c = { fg = fg, bg = status_bg },
						x = { fg = fg, bg = status_bg },
						y = { fg = fg, bg = status_bg, gui = 'bold' },
						z = { fg = fg, bg = status_bg, gui = 'bold' },
					},
					insert = { z = { bg = colors.success, fg = fg } },
					visual = { z = { bg = colors.info, fg = fg } },
					replace = { z = { bg = colors.error, fg = fg } },
					terminal = { z = { bg = colors.info, fg = fg } },
					command = { z = { bg = colors.warning, fg = fg } },
					inactive = {
						a = { fg = colors.fg_inactive, bg = status_bg_inactive },
						b = { fg = colors.fg_inactive, bg = status_bg_inactive },
						c = { fg = colors.fg_inactive, bg = status_bg_inactive },
						x = { fg = colors.fg_inactive, bg = status_bg_inactive },
						y = { fg = colors.fg_inactive, bg = status_bg_inactive },
						z = { fg = colors.fg_inactive, bg = status_bg_inactive },
					},
				}
			 end

			require('lualine').setup({
				options = {
					icons_enabled = true,
					theme = create_solid_theme(),
					-- use rounded bubble-type separators
					component_separators = "",
					section_separators = { left = '', right = '' },
				},
				sections = {
					lualine_a = {
						{
							'branch',
							icon = '',
						},
						'filename',
					},
					lualine_b = {
						{
							function()
								return "%="
							end,
						},
					},
					lualine_c = {
					},
					lualine_x = {
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = { error = " ", warn = " ", info = " " },
						},
						'codecompanion',
					},
					lualine_y = {
						'filetype',
					},
					lualine_z = {
						{
							'mode',
							separator = { right = '' },
							right_padding = 0,
						}
					},
				},
				inactive_sections = {
					lualine_a = { 'filename' },
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { 'location' },
				},
				tabline = {},
				extensions = {}
			})

			-- Expose a function to refresh lualine theme
			_G.refresh_lualine = function()
				local lualine = require('lualine')
				local config = lualine.get_config()
				config.options.theme = create_solid_theme()
				lualine.setup(config)
			end
		end
	}
}
