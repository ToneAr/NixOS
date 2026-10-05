-- Shared color utility functions for dynamic theming
local M = {}

-- Helper function to convert hex to RGB
local function hex_to_rgb(hex)
	hex = hex:gsub("#", "")
	return {
		r = tonumber(hex:sub(1, 2), 16) / 255,
		g = tonumber(hex:sub(3, 4), 16) / 255,
		b = tonumber(hex:sub(5, 6), 16) / 255,
	}
end

-- Helper function to convert RGB to hex
local function rgb_to_hex(rgb)
	return string.format("#%02x%02x%02x",
		math.floor(rgb.r * 255),
		math.floor(rgb.g * 255),
		math.floor(rgb.b * 255)
	)
end

-- Convert RGB to HSL
local function rgb_to_hsl(rgb)
	local max = math.max(rgb.r, rgb.g, rgb.b)
	local min = math.min(rgb.r, rgb.g, rgb.b)
	local h, s, l = 0, 0, (max + min) / 2

	if max ~= min then
		local d = max - min
		s = l > 0.5 and d / (2 - max - min) or d / (max + min)

		if max == rgb.r then
			h = (rgb.g - rgb.b) / d + (rgb.g < rgb.b and 6 or 0)
		elseif max == rgb.g then
			h = (rgb.b - rgb.r) / d + 2
		else
			h = (rgb.r - rgb.g) / d + 4
		end
		h = h / 6
	end

	return { h = h, s = s, l = l }
end

-- Convert HSL to RGB
local function hsl_to_rgb(hsl)
	local h, s, l = hsl.h, hsl.s, hsl.l
	local r, g, b

	if s == 0 then
		r, g, b = l, l, l
	else
		local function hue_to_rgb(p, q, t)
			if t < 0 then t = t + 1 end
			if t > 1 then t = t - 1 end
			if t < 1/6 then return p + (q - p) * 6 * t end
			if t < 1/2 then return q end
			if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
			return p
		end

		local q = l < 0.5 and l * (1 + s) or l + s - l * s
		local p = 2 * l - q
		r = hue_to_rgb(p, q, h + 1/3)
		g = hue_to_rgb(p, q, h)
		b = hue_to_rgb(p, q, h - 1/3)
	end

	return { r = r, g = g, b = b }
end

-- Blend foreground color with background at given opacity (simulates transparency)
function M.adjust_opacity(hex, alpha, bg_hex)
	bg_hex = bg_hex or "#000000" -- Default to black background

	local fg_rgb = hex_to_rgb(hex)
	local bg_rgb = hex_to_rgb(bg_hex)

	-- Alpha can be 0.0-1.0 (float) or 0-100 (percentage)
	local alpha_value = alpha
	if alpha > 1.0 then
		alpha_value = alpha / 100.0
	end
	alpha_value = math.max(0, math.min(1, alpha_value))

	-- Blend: result = fg * alpha + bg * (1 - alpha)
	local blended = {
		r = fg_rgb.r * alpha_value + bg_rgb.r * (1 - alpha_value),
		g = fg_rgb.g * alpha_value + bg_rgb.g * (1 - alpha_value),
		b = fg_rgb.b * alpha_value + bg_rgb.b * (1 - alpha_value),
	}

	return rgb_to_hex(blended)
end

-- Adjust lightness of a color
function M.adjust_lightness(hex, amount)
	local rgb = hex_to_rgb(hex)
	local hsl = rgb_to_hsl(rgb)
	hsl.l = math.max(0, math.min(1, hsl.l + amount))
	return rgb_to_hex(hsl_to_rgb(hsl))
end

-- Adjust saturation of a color
function M.adjust_saturation(hex, amount)
	local rgb = hex_to_rgb(hex)
	local hsl = rgb_to_hsl(rgb)
	hsl.s = math.max(0, math.min(1, hsl.s + amount))
	return rgb_to_hex(hsl_to_rgb(hsl))
end

-- Rotate hue
function M.rotate_hue(hex, degrees)
	local rgb = hex_to_rgb(hex)
	local hsl = rgb_to_hsl(rgb)
	hsl.h = (hsl.h + degrees / 360) % 1
	return rgb_to_hex(hsl_to_rgb(hsl))
end

-- Get accent color from current colorscheme
function M.get_accent_color()
	local colorscheme = vim.g.colors_name or "tonewl"

	-- Get a highlight group that typically has the theme's accent color
	local hl = vim.api.nvim_get_hl(0, { name = "Directory" })
	if hl.fg then
		return string.format("#%06x", hl.fg)
	end

	-- Fallback colors per theme
	local theme_colors = {
		tonewl = '#355a4e',
		["catppuccin-mocha"] = '#89b4fa',
		["catppuccin-macchiato"] = '#8aadf4',
		["catppuccin-frappe"] = '#8caaee',
		["catppuccin-latte"] = '#1e66f5',
		tokyonight = '#7aa2f7',
		["tokyonight-storm"] = '#7aa2f7',
		["tokyonight-moon"] = '#82aaff',
		["tokyonight-day"] = '#2e7de9',
		["rose-pine"] = '#31748f',
		["rose-pine-moon"] = '#3e8fb0',
		["rose-pine-dawn"] = '#286983',
		gruvbox = '#458588',
		["kanagawa-wave"] = '#7e9cd8',
		["kanagawa-dragon"] = '#8ba4b0',
		["kanagawa-lotus"] = '#7e9cd8',
		nightfox = '#719cd6',
		dayfox = '#4d688e',
		dawnfox = '#618774',
		duskfox = '#569fba',
		nordfox = '#81a1c1',
		terafox = '#7aa4a1',
		carbonfox = '#78a9ff',
		["system-accent"] = vim.g.system_accent_color or '#355a4e',
	}

	return theme_colors[colorscheme] or '#355a4e'
end

-- Get foreground color
function M.get_fg_color()
	local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
	if hl.fg then
		return string.format("#%06x", hl.fg)
	end
	return '#c6c6c6'
end

-- Get background color
function M.get_bg_color()
	local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
	if hl.bg then
		return string.format("#%06x", hl.bg)
	end
	return '#1a1a1a'
end

-- Generate complementary colors from base accent
function M.generate_complementary_colors(base_accent)
	base_accent = base_accent or M.get_accent_color()
	
	return {
		-- Base accent
		accent = base_accent,
		accent_dim = M.adjust_lightness(base_accent, -0.12),
		accent_bright = M.adjust_lightness(base_accent, 0.15),
		
		-- Complementary (opposite hue) - for contrast/errors
		error = M.adjust_lightness(M.rotate_hue(base_accent, 180), 0.1),
		
		-- Analogous (adjacent hues) - for warnings and info
		warning = M.adjust_lightness(M.rotate_hue(base_accent, 45), 0.08),
		info = M.adjust_lightness(M.rotate_hue(base_accent, -30), 0.05),
		
		-- Triadic (120 degrees) - for success states
		success = M.adjust_lightness(M.rotate_hue(base_accent, 120), 0.08),
		
		-- Modified state (slightly different hue, warmer)
		modified = M.adjust_lightness(M.rotate_hue(base_accent, 60), 0.12),
		
		-- Background variations
		bg_visible = M.adjust_lightness(base_accent, -0.38),
		bg_inactive = M.adjust_lightness(base_accent, -0.42),
		
		-- Foreground variations
		fg_inactive = M.adjust_saturation(M.adjust_lightness(base_accent, 0.15), -0.3),
	}
end

return M
