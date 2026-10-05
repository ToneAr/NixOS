return {
	{'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		init = function() vim.g.barbar_auto_setup = false end,
		config = function()
			-- Use shared color utilities for complementary colors
			local color_utils = require('config.color-utils')

			-- Function to apply barbar highlights
			local function apply_barbar_highlights()
				local accent = color_utils.get_accent_color()
				local fg = color_utils.get_fg_color()
				local bg = color_utils.get_bg_color()

				-- Generate complementary colors from the accent
				local colors = color_utils.generate_complementary_colors(accent)

				-- Use semi-transparent accent for current buffer
				local current_bg = color_utils.adjust_opacity(accent, 0.5, "#1a1a1a")

				-- Current buffer (active) - uses main accent
				vim.api.nvim_set_hl(0, 'BufferCurrent', { fg = fg, bg = current_bg, bold = true })
				vim.api.nvim_set_hl(0, 'BufferCurrentIndex', { fg = fg, bg = current_bg })
				vim.api.nvim_set_hl(0, 'BufferCurrentMod', { fg = colors.modified, bg = current_bg, bold = true })
				vim.api.nvim_set_hl(0, 'BufferCurrentSign', { fg = current_bg, bg = current_bg })
				vim.api.nvim_set_hl(0, 'BufferCurrentTarget', { fg = colors.error, bg = current_bg, bold = true })
				vim.api.nvim_set_hl(0, 'BufferCurrentIcon', { fg = fg, bg = current_bg })
				vim.api.nvim_set_hl(0, 'BufferCurrentPINNED', { fg = fg, bg = current_bg })
				vim.api.nvim_set_hl(0, 'BufferCurrentADDED', { fg = colors.success, bg = current_bg })
				vim.api.nvim_set_hl(0, 'BufferCurrentCHANGED', { fg = colors.warning, bg = current_bg })
				vim.api.nvim_set_hl(0, 'BufferCurrentDELETED', { fg = colors.error, bg = current_bg })
				vim.api.nvim_set_hl(0, 'BufferCurrentERROR', { fg = colors.error, bg = current_bg })
				vim.api.nvim_set_hl(0, 'BufferCurrentWARN', { fg = colors.warning, bg = current_bg })
				vim.api.nvim_set_hl(0, 'BufferCurrentINFO', { fg = colors.info, bg = current_bg })
				vim.api.nvim_set_hl(0, 'BufferCurrentHINT', { fg = colors.info, bg = current_bg })

				-- Visible buffer (not current, but visible in another window)
				vim.api.nvim_set_hl(0, 'BufferVisible', { fg = fg, bg = colors.bg_visible })
				vim.api.nvim_set_hl(0, 'BufferVisibleIndex', { fg = fg, bg = colors.bg_visible })
				vim.api.nvim_set_hl(0, 'BufferVisibleMod', { fg = colors.modified, bg = colors.bg_visible })
				vim.api.nvim_set_hl(0, 'BufferVisibleSign', { fg = colors.accent_dim, bg = colors.bg_visible })
				vim.api.nvim_set_hl(0, 'BufferVisibleTarget', { fg = colors.error, bg = colors.bg_visible, bold = true })
				vim.api.nvim_set_hl(0, 'BufferVisibleIcon', { fg = fg, bg = colors.bg_visible })
				vim.api.nvim_set_hl(0, 'BufferVisiblePINNED', { fg = fg, bg = colors.bg_visible })
				vim.api.nvim_set_hl(0, 'BufferVisibleADDED', { fg = colors.success, bg = colors.bg_visible })
				vim.api.nvim_set_hl(0, 'BufferVisibleCHANGED', { fg = colors.warning, bg = colors.bg_visible })
				vim.api.nvim_set_hl(0, 'BufferVisibleDELETED', { fg = colors.error, bg = colors.bg_visible })
				vim.api.nvim_set_hl(0, 'BufferVisibleERROR', { fg = colors.error, bg = colors.bg_visible })
				vim.api.nvim_set_hl(0, 'BufferVisibleWARN', { fg = colors.warning, bg = colors.bg_visible })
				vim.api.nvim_set_hl(0, 'BufferVisibleINFO', { fg = colors.info, bg = colors.bg_visible })
				vim.api.nvim_set_hl(0, 'BufferVisibleHINT', { fg = colors.info, bg = colors.bg_visible })

				-- Inactive buffer
				vim.api.nvim_set_hl(0, 'BufferInactive', { fg = colors.fg_inactive, bg = colors.bg_inactive })
				vim.api.nvim_set_hl(0, 'BufferInactiveIndex', { fg = colors.fg_inactive, bg = colors.bg_inactive })
				vim.api.nvim_set_hl(0, 'BufferInactiveMod', { fg = color_utils.adjust_saturation(colors.modified, -0.3), bg = colors.bg_inactive })
				vim.api.nvim_set_hl(0, 'BufferInactiveSign', { fg = colors.fg_inactive, bg = colors.bg_inactive })
				vim.api.nvim_set_hl(0, 'BufferInactiveTarget', { fg = color_utils.adjust_lightness(colors.error, -0.15), bg = colors.bg_inactive, bold = true })
				vim.api.nvim_set_hl(0, 'BufferInactiveIcon', { fg = colors.fg_inactive, bg = colors.bg_inactive })
				vim.api.nvim_set_hl(0, 'BufferInactivePINNED', { fg = colors.fg_inactive, bg = colors.bg_inactive })
				vim.api.nvim_set_hl(0, 'BufferInactiveADDED', { fg = color_utils.adjust_lightness(colors.success, -0.2), bg = colors.bg_inactive })
				vim.api.nvim_set_hl(0, 'BufferInactiveCHANGED', { fg = color_utils.adjust_lightness(colors.warning, -0.2), bg = colors.bg_inactive })
				vim.api.nvim_set_hl(0, 'BufferInactiveDELETED', { fg = color_utils.adjust_lightness(colors.error, -0.2), bg = colors.bg_inactive })
				vim.api.nvim_set_hl(0, 'BufferInactiveERROR', { fg = color_utils.adjust_lightness(colors.error, -0.2), bg = colors.bg_inactive })
				vim.api.nvim_set_hl(0, 'BufferInactiveWARN', { fg = color_utils.adjust_lightness(colors.warning, -0.2), bg = colors.bg_inactive })
				vim.api.nvim_set_hl(0, 'BufferInactiveINFO', { fg = color_utils.adjust_lightness(colors.info, -0.2), bg = colors.bg_inactive })
				vim.api.nvim_set_hl(0, 'BufferInactiveHINT', { fg = color_utils.adjust_lightness(colors.info, -0.2), bg = colors.bg_inactive })

				-- Tab line fill
				vim.api.nvim_set_hl(0, 'BufferTabpageFill', { bg = color_utils.adjust_opacity(colors.accent, 0.15, "#0f0f0f") })
				vim.api.nvim_set_hl(0, 'BufferTabpages', { fg = accent, bg = bg, bold = true })

				-- Offset (for file explorer)
				vim.api.nvim_set_hl(0, 'BufferOffset', { fg = accent, bg = bg })

				-- Override nvim-web-devicons to prevent blue backgrounds
				-- Get all loaded devicon highlight groups and update their backgrounds
				local ok, devicons = pcall(require, 'nvim-web-devicons')
				if ok then
					-- First, override all base DevIcon highlights to remove backgrounds
					local all_devicon_hl = vim.fn.getcompletion('DevIcon', 'highlight')
					for _, hl_name in ipairs(all_devicon_hl) do
						local hl = vim.api.nvim_get_hl(0, { name = hl_name })
						if hl.fg then
							-- Remove background from base devicon
							vim.api.nvim_set_hl(0, hl_name, { fg = hl.fg, bg = 'NONE' })

							-- Also override barbar-specific variants
							vim.api.nvim_set_hl(0, 'BufferCurrent' .. hl_name, { fg = hl.fg, bg = current_bg })
							vim.api.nvim_set_hl(0, 'BufferVisible' .. hl_name, { fg = hl.fg, bg = colors.bg_visible })
							vim.api.nvim_set_hl(0, 'BufferInactive' .. hl_name, { fg = hl.fg, bg = colors.bg_inactive })
						end
					end

					-- Also get devicons from the plugin directly
					local all_icons = devicons.get_icons()
					for _, icon_data in pairs(all_icons) do
						if icon_data.name then
							local hl_name = 'DevIcon' .. icon_data.name
							-- Get existing highlight and only update background
							local hl = vim.api.nvim_get_hl(0, { name = hl_name })
							if hl.fg then
								-- Keep the icon's foreground color, remove background
								vim.api.nvim_set_hl(0, hl_name, { fg = hl.fg, bg = 'NONE' })

								-- Also override barbar-specific variants
								vim.api.nvim_set_hl(0, 'BufferCurrent' .. hl_name, { fg = hl.fg, bg = current_bg })
								vim.api.nvim_set_hl(0, 'BufferVisible' .. hl_name, { fg = hl.fg, bg = colors.bg_visible })
								vim.api.nvim_set_hl(0, 'BufferInactive' .. hl_name, { fg = hl.fg, bg = colors.bg_inactive })
							end
						end
					end

					-- Also directly override any stray BufferCurrentDevIcon highlights
					for i = 0, 255 do
						local hl_groups = vim.fn.getcompletion('BufferCurrentDevIcon', 'highlight')
						for _, group in ipairs(hl_groups) do
							local hl = vim.api.nvim_get_hl(0, { name = group })
							if hl.fg then
								vim.api.nvim_set_hl(0, group, { fg = hl.fg, bg = current_bg })
							end
						end
						break  -- Only need to run once
					end
				end
			end

			-- Setup barbar with basic options
			require('barbar').setup({
				animation = true,
				auto_hide = false,
				tabpages = true,
				clickable = true,
				focus_on_close = 'previous',
				icons = {
					enabled = true,
					custom_colors = true,
					button = '',
					modified = {button = '●'},
					pinned = {button = '᯽', filename = true, insert_at_end = false },
					filetype = { enabled = true },
				},
				insert_at_end = false,
				maximum_padding = 1,
				minimum_padding = 1,
				maximum_length = 30,
				semantic_letters = true,
				no_name_title = '[No Name]',
			})

			-- Apply initial highlights
			apply_barbar_highlights()

			-- Aggressive fix: override ALL BufferCurrent highlights after a delay
			vim.defer_fn(function()
				local accent = color_utils.get_accent_color()
				local current_bg = color_utils.adjust_opacity(accent, 0.5, "#1a1a1a")

				-- Get ALL highlights starting with BufferCurrent
				local all_hl_groups = vim.fn.getcompletion('BufferCurrent', 'highlight')
				for _, group in ipairs(all_hl_groups) do
					local hl = vim.api.nvim_get_hl(0, { name = group })
					-- If it has a foreground, keep it but force our background
					if hl.fg or hl.link then
						local new_hl = vim.tbl_extend('force', hl, { bg = current_bg, link = nil })
						vim.api.nvim_set_hl(0, group, new_hl)
					end
				end
			end, 300)

			-- Expose a global function to refresh barbar highlights
			_G.refresh_barbar = function()
				apply_barbar_highlights()
				-- Force barbar to re-render
				local ok, barbar_ui = pcall(require, 'barbar.ui')
				if ok and barbar_ui.refresh then
					pcall(barbar_ui.refresh)
				end
			end

			-- Debug function to check highlight under cursor
			_G.debug_barbar_highlight = function()
				local line = vim.fn.line('.')
				local col = vim.fn.col('.')
				local hl_id = vim.fn.synID(line, col, 1)
				local hl_name = vim.fn.synIDattr(hl_id, 'name')
				local trans_id = vim.fn.synIDtrans(hl_id)
				local trans_name = vim.fn.synIDattr(trans_id, 'name')

				local hl = vim.api.nvim_get_hl(0, { name = hl_name })
				print(string.format("Highlight: %s (trans: %s)", hl_name, trans_name))
				print(string.format("FG: %s, BG: %s", hl.fg or "none", hl.bg or "none"))

				-- Also check all BufferCurrent DevIcon highlights
				local all_hl = vim.fn.getcompletion('BufferCurrentDevIcon', 'highlight')
				print("\nAll BufferCurrentDevIcon highlights:")
				for _, name in ipairs(all_hl) do
					local h = vim.api.nvim_get_hl(0, { name = name })
					if h.bg then
						print(string.format("  %s: bg=%s", name, string.format("#%06x", h.bg)))
					end
				end
			end

			-- Create user command for easier debugging
			vim.api.nvim_create_user_command('BarbarDebugHighlight', function()
				local output = {}
				table.insert(output, "=== All BufferCurrent Highlights ===")
				local buffer_hl = vim.fn.getcompletion('BufferCurrent', 'highlight')
				if #buffer_hl == 0 then
					table.insert(output, "No BufferCurrent highlights found")
				else
					for _, name in ipairs(buffer_hl) do
						local h = vim.api.nvim_get_hl(0, { name = name })
						if h.bg then
							table.insert(output, string.format("%s: bg=#%06x", name, h.bg))
						end
					end
				end

				table.insert(output, "\n=== All DevIcon Highlights ===")
				local devicon_hl = vim.fn.getcompletion('DevIcon', 'highlight')
				if #devicon_hl == 0 then
					table.insert(output, "No DevIcon highlights found")
				else
					for _, name in ipairs(devicon_hl) do
						local h = vim.api.nvim_get_hl(0, { name = name })
						if h.bg then
							table.insert(output, string.format("%s: bg=#%06x", name, h.bg))
						end
					end
				end

				local result = table.concat(output, "\n")

				-- Write to file
				local file = io.open('/tmp/barbar_debug.txt', 'w')
				if file then
					file:write(result)
					file:close()
					vim.notify("Debug info written to /tmp/barbar_debug.txt", vim.log.levels.INFO)
				else
					vim.notify("Failed to write debug file", vim.log.levels.ERROR)
				end

				print(result)
			end, {})

			-- Auto-refresh barbar when colorscheme changes
			vim.api.nvim_create_autocmd('ColorScheme', {
				pattern = '*',
				callback = function()
					vim.defer_fn(function()
						if _G.refresh_barbar then
							_G.refresh_barbar()
						end
					end, 100)
				end,
			})

			-- Fix devicon backgrounds on buffer enter (barbar creates them dynamically)
			vim.api.nvim_create_autocmd('BufEnter', {
				pattern = '*',
				callback = function()
					vim.defer_fn(function()
						local accent = color_utils.get_accent_color()
						local current_bg = color_utils.adjust_opacity(accent, 0.5, "#1a1a1a")
						local colors = color_utils.generate_complementary_colors(accent)

						-- Fix DevIcon{Type}Current pattern (e.g., DevIconReadmeCurrent)
						local all_devicons = vim.fn.getcompletion('DevIcon', 'highlight')
						for _, group in ipairs(all_devicons) do
							if group:match('Current$') then
								local hl = vim.api.nvim_get_hl(0, { name = group })
								if hl.fg then
									vim.api.nvim_set_hl(0, group, { fg = hl.fg, bg = current_bg })
								else
									vim.api.nvim_set_hl(0, group, { bg = current_bg })
								end
							elseif group:match('Visible$') then
								local hl = vim.api.nvim_get_hl(0, { name = group })
								if hl.fg then
									vim.api.nvim_set_hl(0, group, { fg = hl.fg, bg = colors.bg_visible })
								else
									vim.api.nvim_set_hl(0, group, { bg = colors.bg_visible })
								end
							elseif group:match('Inactive$') then
								local hl = vim.api.nvim_get_hl(0, { name = group })
								if hl.fg then
									vim.api.nvim_set_hl(0, group, { fg = hl.fg, bg = colors.bg_inactive })
								else
									vim.api.nvim_set_hl(0, group, { bg = colors.bg_inactive })
								end
							end
						end

						-- Also fix BufferCurrent* variants
						local all_current = vim.fn.getcompletion('BufferCurrent', 'highlight')
						for _, group in ipairs(all_current) do
							if group:match('DevIcon') then
								local hl = vim.api.nvim_get_hl(0, { name = group })
								if hl.fg then
									vim.api.nvim_set_hl(0, group, { fg = hl.fg, bg = current_bg })
								else
									vim.api.nvim_set_hl(0, group, { bg = current_bg })
								end
							end
							if group == 'BufferCurrentIcon' then
								local fg = color_utils.get_fg_color()
								vim.api.nvim_set_hl(0, group, { fg = fg, bg = current_bg })
							end
						end
					end, 100)
				end,
			})
		end,
	},
}
