-- System Accent Theme - Dynamically generates theme from system accent color
local M = {}

local utils = require("config.color-utils")

-- Module-level storage for timer (can't store in vim.g)
local accent_watcher_timer = nil

-- Get system accent color
local function get_system_accent()
	-- Try KDE Plasma accent color (most reliable)
	local handle = io.popen("kreadconfig6 --file kdeglobals --group General --key AccentColor 2>/dev/null")
	if handle then
		local result = handle:read("*a")
		handle:close()
		if result and result ~= "" then
			-- KDE format: "r,g,b" - convert to hex
			local r, g, b = result:match("(%d+),(%d+),(%d+)")
			if r and g and b then
				return string.format("#%02x%02x%02x", tonumber(r), tonumber(g), tonumber(b))
			end
		end
	end

	-- Try GNOME/GTK accent color from settings
	handle = io.popen("gsettings get org.gnome.desktop.interface accent-color 2>/dev/null")
	if handle then
		local result = handle:read("*a")
		handle:close()
		if result and result ~= "" then
			result = result:gsub("['\"]"  , ""):gsub("%s+", "")
			-- GNOME uses named colors like 'blue', 'green', etc.
			local gnome_colors = {
				blue = "#3584e4",
				green = "#33d17a",
				yellow = "#f6d32d",
				orange = "#ff7800",
				red = "#e01b24",
				purple = "#9141ac",
				brown = "#986a44",
				slate = "#99c1f1",
			}
			if gnome_colors[result] then
				return gnome_colors[result]
			end
		end
	end

	-- Try to read from GTK CSS
	local gtk_css_path = os.getenv("HOME") .. "/.config/gtk-3.0/gtk.css"
	local file = io.open(gtk_css_path, "r")
	if file then
		local content = file:read("*a")
		file:close()
		local color = content:match("@define%-color accent_color (#%x%x%x%x%x%x)")
		if color then
			return color
		end
	end

	-- Try GTK 4 colors
	local gtk4_css_path = os.getenv("HOME") .. "/.config/gtk-4.0/gtk.css"
	file = io.open(gtk4_css_path, "r")
	if file then
		local content = file:read("*a")
		file:close()
		local color = content:match("@define%-color accent_bg_color (#%x%x%x%x%x%x)")
		if color then
			return color
		end
	end

	-- Fallback: Try to detect from current terminal colors
	local term_color = vim.g.terminal_color_4 or vim.g.terminal_color_12
	if term_color and term_color:match("^#%x%x%x%x%x%x$") then
		return term_color
	end

	-- Default fallback
	return "#5B9BD5"
end

-- Generate complete color palette from base accent
local function generate_palette(base_accent)
	-- Keep accent vibrant, only slight adjustment
	local accent = utils.adjust_saturation(base_accent, 0.05)

	-- Create slightly adjust_ed versions for syntax (minimal changes)
	local function muted(color, sat_adjust, light_adjust)
		sat_adjust = sat_adjust or 0
		light_adjust = light_adjust or 0.05
		return utils.adjust_lightness(utils.adjust_saturation(color, sat_adjust), light_adjust)
	end

	local palette = {
		-- Base accent colors (bright and vibrant)
		accent = utils.adjust_lightness(accent, 0.05),
		accent_dim = utils.adjust_lightness(accent, -0.12),
		accent_bright = utils.adjust_lightness(accent, 0.15),
		accent_subtle = utils.adjust_saturation(utils.adjust_lightness(accent, -0.15), -0.15),

		-- Complementary colors (opposite hue) - vibrant
		complementary = muted(utils.rotate_hue(accent, 180), 0, 0.08),

		-- Analogous colors (adjacent hues) - vibrant
		analogous1 = muted(utils.rotate_hue(accent, 30), 0, 0.08),
		analogous2 = muted(utils.rotate_hue(accent, -30), 0, 0.08),

		-- Triadic colors - vibrant
		triadic1 = muted(utils.rotate_hue(accent, 120), -0.05, 0.05),
		triadic2 = muted(utils.rotate_hue(accent, 240), -0.05, 0.05),

		-- UI colors with better contrast for transparency
		bg = "none",
		dark_bg = "#0f0f0f",
		lighter_bg = "#1a1a1a",
		menu_bg = "#1a1a1a",
		selection = "#2d2d3d",
		highlight = "#28283a",
		fg = "#e8e8ec",
		fg_dark = "#b5b5bb",
		comment = "#8a8a94",
		line_numbers = "#6a6a6a",
		active_line_nr = utils.adjust_lightness(accent, 0.1),

		-- Functional colors derived from accent (vibrant!)
		keyword = utils.adjust_lightness(accent, 0.05),
		function_name = muted(utils.rotate_hue(accent, -35), 0, 0.1),
		type_name = muted(utils.rotate_hue(accent, 35), 0, 0.1),
		string = utils.adjust_lightness(utils.adjust_saturation(utils.rotate_hue(accent, -90), -0.2), 0.2),
		number = muted(utils.rotate_hue(accent, 280), -0.05, 0.08),
		constant = muted(utils.rotate_hue(accent, 280), 0, 0.1),
		operator = muted(utils.rotate_hue(accent, -60), -0.1, 0.05),
		variable = "#d5d5da",       -- Brighter variable color

		-- Status colors (vibrant)
		error = "#e88888",
		warning = "#d9b878",
		info = utils.adjust_lightness(accent, 0.1),
		hint = utils.adjust_lightness(accent, 0.05),
		success = "#88d888",

		-- Bracket colors (vibrant gradient based on accent)
		bracket1 = muted(utils.rotate_hue(accent, -75), 0, 0.08),
		bracket2 = muted(utils.rotate_hue(accent, -25), 0, 0.08),
		bracket3 = muted(utils.rotate_hue(accent, 0), 0, 0.08),
		bracket4 = muted(utils.rotate_hue(accent, 75), 0, 0.08),
		bracket5 = muted(utils.rotate_hue(accent, 100), 0, 0.08),
		bracket6 = muted(utils.rotate_hue(accent, 125), 0, 0.08),

		-- UI elements
		border = utils.adjust_saturation(utils.adjust_lightness(accent, -0.25), -0.1),
		indent_guide = "#1a1a1a",
		active_indent = "#252525",
		find_match = utils.adjust_lightness(accent, -0.05),
		find_highlight = utils.adjust_lightness(accent, -0.1),

		-- Status line
		status = utils.adjust_opacity(accent, 0.5, "#1a1a1a"),
		status_inactive = utils.adjust_opacity(accent, 0.25, "#151515"),

		-- Tab line
		tabline = "#252525",
		tabline_fill = "#1a1a1a",
		tabline_sel = utils.adjust_lightness(accent, -0.1),

		-- Wolfram Language specific colors (triadic/complementary with varied brightness)
		wolfram_module = muted(utils.rotate_hue(accent, -110), 0, 0),
		wolfram_block = muted(utils.rotate_hue(accent, -100), 0, 0.05),
		wolfram_with = muted(utils.rotate_hue(accent, -125), 0, 0.1),
		wolfram_builtin = utils.adjust_lightness(accent, 0.05),
	}

	return palette
end

function M.setup(opts)
	opts = opts or {}

	-- Get system accent color or use provided override
	local base_accent = opts.accent or get_system_accent()

	-- Generate full palette
	local colors = generate_palette(base_accent)

	-- Clear any existing augroup
	vim.api.nvim_create_augroup("SystemAccentTheme", { clear = true })

	-- Set colorscheme name
	vim.g.colors_name = "system-accent"

	-- Set up autocmd to ensure indent guides and column indicators stay dark
	vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter", "BufEnter"}, {
		group = "SystemAccentTheme",
		callback = function()
		if vim.g.colors_name == "system-accent" then
			-- Force indent guides and column indicators to be very dark (break links)
			vim.api.nvim_set_hl(0, "IblIndent", { fg = "#1a1a1a", bg = "NONE", default = false, nocombine = true })
			vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#1a1a1a", bg = "NONE", default = false, nocombine = true })
			vim.api.nvim_set_hl(0, "IblScope", { fg = "#252525", bg = "NONE", default = false, nocombine = true })
			vim.api.nvim_set_hl(0, "VirtColumn", { fg = "#1a1a1a", bg = "NONE", default = false, nocombine = true })
		end
	end,
	})

	-- Set WL filetype on appropriate files
	vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
		group = "SystemAccentTheme",
		pattern = {"*.wl", "*.wls", "*.m", "*.nb", "*.wlt", "*.tr", "*.mt", "*.cdf"},
		callback = function()
			vim.bo.filetype = "wolfram"
		end,
	})

	-- Set up semantic tokens when LSP attaches
	vim.api.nvim_create_autocmd("LspAttach", {
		group = "SystemAccentTheme",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if not client then
				return
			end

			-- Only configure specific semantic tokens for Wolfram Language
			if client.name == "wl_lsp" then
				-- Always ensure semantic tokens capability is set up for WL
				client.server_capabilities.semanticTokensProvider = {
					full = true,
					legend = {
						tokenTypes = {
							"namespace", "type", "class", "enum", "interface",
							"struct", "typeParameter", "parameter", "variable",
							"property", "enumMember", "event", "function", "method",
							"macro", "keyword", "modifier", "comment", "string",
							"number", "regexp", "operator", "decorator"
						},
						tokenModifiers = {
							"Module", "Block", "With", "shadowed", "error", "unused",
							"declaration", "definition", "readonly", "static",
							"deprecated", "abstract", "async", "modification",
							"documentation", "defaultLibrary"
						}
					}
				}

				-- Make sure semantic tokens are refreshed for WL files
				vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
					group = "SystemAccentTheme",
					pattern = {"*.wl", "*.wls", "*.wlt", "*.m", "*.mt", "*.tr", "*.nb", "*.cdf"},
					callback = function()
						if vim.lsp.semantic_tokens and vim.lsp.semantic_tokens.force_refresh then
							vim.lsp.semantic_tokens.force_refresh()
						end
					end
				})
			end

			-- For all language servers, refresh semantic tokens when available
			if vim.lsp.semantic_tokens and vim.lsp.semantic_tokens.force_refresh then
				vim.lsp.semantic_tokens.force_refresh()
			end
		end
	})

	-- Terminal colors
	local terminal_colors = {
		black = "#0f1419",
		bright_black = "#5c6570",
		red = "#e06c75",
		bright_red = "#ff7b72",
		green = "#98c379",
		bright_green = "#b6e3a1",
		yellow = "#e5c07b",
		bright_yellow = "#ffd580",
		blue = "#61afef",
		bright_blue = "#93d6ff",
		magenta = "#c678dd",
		bright_magenta = "#e3a3f5",
		cyan = "#56b6c2",
		bright_cyan = "#8fd8e8",
		white = "#dcdfe4",
		bright_white = "#ffffff",
	}

	local logo_base_colors = {
		N = colors.accent,
		e = colors.accent_bright,
		o = colors.accent_bright,
		V = utils.rotate_hue(colors.accent, -30),
		i = utils.rotate_hue(colors.accent_bright, -30),
		m = utils.rotate_hue(colors.accent_bright, -30),
	}

	-- Define highlight groups
	local highlights = {
		-- UI elements
		Normal = { fg = colors.fg, bg = colors.bg },
		NormalFloat = { fg = colors.fg, bg = colors.bg },
		NormalNC = { fg = colors.fg, bg = colors.bg },
		ColorColumn = { bg = colors.lighter_bg },
		Cursor = { fg = colors.bg, bg = colors.fg },
		CursorColumn = { bg = colors.highlight },
		CursorLine = { bg = colors.highlight },
		CursorLineNr = { fg = colors.active_line_nr, bold = true },
		LineNr = { fg = colors.line_numbers },
		LineNrAbove = { fg = colors.line_numbers },
		LineNrBelow = { fg = colors.line_numbers },
		LineColumn = { fg = colors.line_numbers, bg = utils.adjust_opacity(colors.accent, 0.15, "#0f0f0f") },
		SignColumn = { bg = utils.adjust_opacity(colors.accent, 0.15, "#0f0f0f"), fg = colors.line_numbers },
		VertSplit = { fg = colors.border },
		WinSeparator = { fg = colors.border },
		Folded = { fg = colors.comment, bg = colors.selection },
		FoldColumn = { fg = colors.border },
		EndOfBuffer = { fg = colors.line_numbers },

		AlphaBorder = { fg = colors.border },

		AlphaHeader_N_0 = { fg = logo_base_colors.N },
		AlphaHeader_N_1 = { fg = utils.adjust_lightness(logo_base_colors.N, 0.01) },
		AlphaHeader_N_2 = { fg = utils.adjust_lightness(logo_base_colors.N, 0.02) },
		AlphaHeader_N_3 = { fg = utils.adjust_lightness(logo_base_colors.N, 0.03) },
		AlphaHeader_N_4 = { fg = utils.adjust_lightness(logo_base_colors.N, 0.04) },
		AlphaHeader_N_5 = { fg = utils.adjust_lightness(logo_base_colors.N, 0.05) },
		AlphaHeader_N_6 = { fg = utils.adjust_lightness(logo_base_colors.N, 0.06) },
		AlphaHeader_N_shadow = { fg = utils.adjust_lightness(logo_base_colors.N, -0.3) },

		AlphaHeader_e_0 = { fg = logo_base_colors.e },
		AlphaHeader_e_1 = { fg = utils.adjust_lightness(logo_base_colors.e, 0.01) },
		AlphaHeader_e_2 = { fg = utils.adjust_lightness(logo_base_colors.e, 0.02) },
		AlphaHeader_e_3 = { fg = utils.adjust_lightness(logo_base_colors.e, 0.03) },
		AlphaHeader_e_4 = { fg = utils.adjust_lightness(logo_base_colors.e, 0.04) },
		AlphaHeader_e_shadow = { fg = utils.adjust_lightness(logo_base_colors.e, -0.3) },

		AlphaHeader_o_0 = { fg = logo_base_colors.o },
		AlphaHeader_o_1 = { fg = utils.adjust_lightness(logo_base_colors.o, 0.01) },
		AlphaHeader_o_2 = { fg = utils.adjust_lightness(logo_base_colors.o, 0.02) },
		AlphaHeader_o_3 = { fg = utils.adjust_lightness(logo_base_colors.o, 0.03) },
		AlphaHeader_o_4 = { fg = utils.adjust_lightness(logo_base_colors.o, 0.04) },
		AlphaHeader_o_shadow = { fg = utils.adjust_lightness(logo_base_colors.o, -0.3) },

		AlphaHeader_V_0 = { fg = logo_base_colors.V },
		AlphaHeader_V_1 = { fg = utils.adjust_lightness(logo_base_colors.V, 0.01) },
		AlphaHeader_V_2 = { fg = utils.adjust_lightness(logo_base_colors.V, 0.02) },
		AlphaHeader_V_3 = { fg = utils.adjust_lightness(logo_base_colors.V, 0.03) },
		AlphaHeader_V_4 = { fg = utils.adjust_lightness(logo_base_colors.V, 0.04) },
		AlphaHeader_V_5 = { fg = utils.adjust_lightness(logo_base_colors.V, 0.05) },
		AlphaHeader_V_6 = { fg = utils.adjust_lightness(logo_base_colors.V, 0.06) },
		AlphaHeader_V_shadow = { fg = utils.adjust_lightness(logo_base_colors.V, -0.3) },

		AlphaHeader_i_0 = { fg = logo_base_colors.i },
		AlphaHeader_i_1 = { fg = utils.adjust_lightness(logo_base_colors.i, 0.01) },
		AlphaHeader_i_2 = { fg = utils.adjust_lightness(logo_base_colors.i, 0.02) },
		AlphaHeader_i_3 = { fg = utils.adjust_lightness(logo_base_colors.i, 0.03) },
		AlphaHeader_i_4 = { fg = utils.adjust_lightness(logo_base_colors.i, 0.04) },
		AlphaHeader_i_shadow = { fg = utils.adjust_lightness(logo_base_colors.i, -0.3) },

		AlphaHeader_m_0 = { fg = logo_base_colors.m },
		AlphaHeader_m_1 = { fg = utils.adjust_lightness(logo_base_colors.m, 0.01) },
		AlphaHeader_m_2 = { fg = utils.adjust_lightness(logo_base_colors.m, 0.02) },
		AlphaHeader_m_3 = { fg = utils.adjust_lightness(logo_base_colors.m, 0.03) },
		AlphaHeader_m_4 = { fg = utils.adjust_lightness(logo_base_colors.m, 0.04) },
		AlphaHeader_m_shadow = { fg = utils.adjust_lightness(logo_base_colors.m, -0.3) },

		-- Status and tab lines
		StatusLine = { fg = colors.fg, bg = colors.status },
		StatusLineNC = { fg = colors.comment, bg = colors.status_inactive },
		TabLine = { fg = colors.fg_dark, bg = utils.adjust_opacity(colors.accent, 0.15, "#0f0f0f") },
		TabLineFill = { bg = utils.adjust_opacity(colors.accent, 0.15, "#0f0f0f") },
		TabLineSel = { fg = colors.fg, bg = colors.tabline_sel, bold = true },
		BufferTabpages = { bg = utils.adjust_opacity(colors.accent, 0.15, "#0f0f0f") },
		BufferTabpageFill = { bg = utils.adjust_opacity(colors.accent, 0.15, "#0f0f0f") },
		Title = { fg = colors.function_name, bold = true },

		-- Brackets
		RainbowDelimiterOne = { fg = colors.bracket1 },
		RainbowDelimiterTwo = { fg = colors.bracket2 },
		RainbowDelimiterThree = { fg = colors.bracket3 },
		RainbowDelimiterFour = { fg = colors.bracket4 },
		RainbowDelimiterFive = { fg = colors.bracket5 },
		RainbowDelimiterSix = { fg = colors.bracket6 },

		-- Search
		IncSearch = { bg = colors.find_match, fg = colors.fg, bold = true },
		Search = { bg = colors.find_highlight, fg = colors.fg },
		Substitute = { bg = colors.accent, fg = colors.bg },
		CurSearch = { bg = colors.accent, fg = colors.bg, bold = true },

		-- Visual
		Visual = { bg = colors.selection },
		VisualNOS = { bg = colors.selection },

		-- Popup menu
		Pmenu = { fg = colors.fg, bg = colors.menu_bg },
		PmenuSel = { fg = colors.fg, bg = colors.selection, bold = true },
		PmenuSbar = { bg = colors.dark_bg },
		PmenuThumb = { bg = colors.border },
		WildMenu = { fg = colors.fg, bg = colors.selection },

		-- Messages
		ErrorMsg = { fg = colors.error },
		WarningMsg = { fg = colors.warning },
		MoreMsg = { fg = colors.info },
		ModeMsg = { fg = colors.accent, bold = true },
		Question = { fg = colors.function_name },

		-- Spelling
		SpellBad = { sp = colors.error, undercurl = true },
		SpellCap = { sp = colors.warning, undercurl = true },
		SpellLocal = { sp = colors.info, undercurl = true },
		SpellRare = { sp = colors.hint, undercurl = true },

		-- Diff
		DiffAdd = { fg = colors.success, bg = "NONE" },
		DiffChange = { fg = colors.warning, bg = "NONE" },
		DiffDelete = { fg = colors.error, bg = "NONE" },
		DiffText = { fg = colors.accent, bg = colors.selection },

		-- Diagnostics
		DiagnosticError = { fg = colors.error },
		DiagnosticWarn = { fg = colors.warning },
		DiagnosticInfo = { fg = colors.info },
		DiagnosticHint = { fg = colors.hint },
		DiagnosticOk = { fg = colors.success },
		DiagnosticUnderlineError = { sp = colors.error, undercurl = true },
		DiagnosticUnderlineWarn = { sp = colors.warning, undercurl = true },
		DiagnosticUnderlineInfo = { sp = colors.info, undercurl = true },
		DiagnosticUnderlineHint = { sp = colors.hint, undercurl = true },

		-- Syntax
		Comment = { fg = colors.comment, italic = true },
		Constant = { fg = colors.constant },
		String = { fg = colors.string },
		Character = { fg = colors.constant },
		Number = { fg = colors.number },
		Boolean = { fg = colors.constant },
		Float = { fg = colors.number },

		Identifier = { fg = colors.fg },
		Function = { fg = colors.function_name },

		Statement = { fg = colors.keyword },
		Conditional = { fg = colors.keyword },
		Repeat = { fg = colors.keyword },
		Label = { fg = colors.keyword },
		Operator = { fg = colors.operator },
		Keyword = { fg = colors.keyword },
		Exception = { fg = colors.keyword },

		PreProc = { fg = colors.keyword },
		Include = { fg = colors.keyword },
		Define = { fg = colors.keyword },
		Macro = { fg = colors.keyword },
		PreCondit = { fg = colors.keyword },

		Type = { fg = colors.type_name },
		StorageClass = { fg = colors.type_name },
		Structure = { fg = colors.type_name },
		Typedef = { fg = colors.type_name },

		Special = { fg = colors.accent },
		SpecialChar = { fg = colors.accent_bright },
		Tag = { fg = colors.keyword },
		Delimiter = { fg = colors.fg },
		SpecialComment = { fg = colors.comment, italic = true },
		Debug = { fg = colors.error },

		Underlined = { underline = true },
		Ignore = { fg = colors.comment },
		Error = { fg = colors.error },
		Todo = { fg = colors.warning, bold = true },

		-- Indent Blankline
		IblIndent = { fg = colors.indent_guide, bg = "NONE", nocombine = true },
		IblWhitespace = { fg = colors.indent_guide, bg = "NONE", nocombine = true },
		IblScope = { fg = colors.indent_guide, bg = "NONE", nocombine = true },

		-- Virt Column (line length indicator)
		VirtColumn = { fg = colors.indent_guide, bg = "NONE", nocombine = true },

		-- Notify plugin
		NotifyBackground = { bg = colors.dark_bg },
		NotifyERRORBorder = { fg = colors.error },
		NotifyWARNBorder = { fg = colors.warning },
		NotifyINFOBorder = { fg = colors.info },
		NotifyDEBUGBorder = { fg = colors.hint },
		NotifyTRACEBorder = { fg = colors.accent },
		NotifyERRORIcon = { fg = colors.error },
		NotifyWARNIcon = { fg = colors.warning },
		NotifyINFOIcon = { fg = colors.info },
		NotifyDEBUGIcon = { fg = colors.hint },
		NotifyTRACEIcon = { fg = colors.accent },
		NotifyERRORTitle = { fg = colors.error },
		NotifyWARNTitle = { fg = colors.warning },
		NotifyINFOTitle = { fg = colors.info },
		NotifyDEBUGTitle = { fg = colors.hint },
		NotifyTRACETitle = { fg = colors.accent },

		-- Lazy
		lazyRainbow_lv0_r0 = { fg = colors.bg },

		-- Markdown / Render Markdown
		-- Base markdown elements
		MarkdownH1 = { fg = colors.accent_bright, bold = true },
		MarkdownH2 = { fg = colors.function_name, bold = true },
		MarkdownH3 = { fg = colors.type_name, bold = true },
		MarkdownH4 = { fg = colors.string, bold = true },
		MarkdownH5 = { fg = colors.analogous1 },
		MarkdownH6 = { fg = colors.analogous2 },
		MarkdownCode = { fg = colors.accent_bright, bg = colors.dark_bg },
		MarkdownCodeBlock = {  },
		MarkdownUrl = { fg = colors.function_name, underline = true },
		MarkdownLinkText = { fg = colors.accent, bold = true },
		MarkdownListMarker = { fg = colors.accent },
		MarkdownBold = { fg = colors.accent_bright, bold = true },
		MarkdownItalic = { italic = true },
		MarkdownStrike = { fg = colors.comment, strikethrough = true },

		-- Render Markdown plugin (minimal style - backgrounds only on underline)
		RenderMarkdownH1 = { fg = colors.accent_bright, bold = true },
		RenderMarkdownH2 = { fg = colors.function_name, bold = true },
		RenderMarkdownH3 = { fg = colors.type_name, bold = true },
		RenderMarkdownH4 = { fg = colors.string, bold = true },
		RenderMarkdownH5 = { fg = colors.analogous1 },
		RenderMarkdownH6 = { fg = colors.analogous2 },

		-- Heading underline backgrounds (much more subtle and transparent)
		RenderMarkdownH1Bg = { bg = utils.adjust_opacity(colors.accent, 0.3), fg = colors.accent_bright },
		RenderMarkdownH2Bg = { bg = utils.adjust_opacity(colors.function_name, 0.3), fg = colors.function_name },
		RenderMarkdownH3Bg = { bg = utils.adjust_opacity(colors.type_name, 0.3), fg = colors.type_name },
		RenderMarkdownH4Bg = { bg = utils.adjust_opacity(colors.string, 0.3), fg = colors.string },
		RenderMarkdownH5Bg = { bg = 'none', fg = colors.analogous1 },
		RenderMarkdownH6Bg = { bg = 'none', fg = colors.analogous2 },

		-- Code styling
		RenderMarkdownCode = { link = "MarkdownCodeBlock" },
		RenderMarkdownCodeInline = { fg = colors.accent_bright, bg = colors.highlight },
		RenderMarkdownBullet = { fg = colors.accent },

		-- Table styling
		RenderMarkdownTableHead = { fg = colors.accent, bold = true },
		RenderMarkdownTableRow = { fg = colors.border },

		-- Quote blocks
		RenderMarkdownQuote = { fg = colors.string, bg = utils.adjust_opacity(colors.string, 0.15, "#0f0f0f"), italic = true },

		-- Callout/Alert blocks (> [!TYPE])
		RenderMarkdownInfo = { fg = colors.info },
		RenderMarkdownSuccess = { fg = colors.success },
		RenderMarkdownHint = { fg = colors.hint },
		RenderMarkdownWarn = { fg = colors.warning },
		RenderMarkdownError = { fg = colors.error },
		RenderMarkdownNote = { fg = colors.accent },

		-- Quote markers and callout icons/labels
		RenderMarkdownQuoteIcon = { fg = colors.string, bg = utils.adjust_opacity(colors.string, 0.15, "#0f0f0f") },
		RenderMarkdownCalloutNote = { fg = colors.accent, bg = utils.adjust_opacity(colors.accent, 0.15, "#0f0f0f"), bold = true },
		RenderMarkdownCalloutTip = { fg = colors.success, bg = utils.adjust_opacity(colors.success, 0.15, "#0f0f0f"), bold = true },
		RenderMarkdownCalloutImportant = { fg = colors.hint, bg = utils.adjust_opacity(colors.hint, 0.15, "#0f0f0f"), bold = true },
		RenderMarkdownCalloutWarning = { fg = colors.warning, bg = utils.adjust_opacity(colors.warning, 0.15, "#0f0f0f"), bold = true },
		RenderMarkdownCalloutCaution = { fg = colors.error, bg = utils.adjust_opacity(colors.error, 0.15, "#0f0f0f"), bold = true },
		RenderMarkdownCalloutTodo = { fg = colors.warning, bg = utils.adjust_opacity(colors.warning, 0.15, "#0f0f0f"), bold = true },

		-- Horizontal rules
		RenderMarkdownDash = { fg = colors.accent },

		-- Checkboxes
		RenderMarkdownChecked = { fg = colors.success },
		RenderMarkdownUnchecked = { fg = colors.comment },

		-- Links
		RenderMarkdownLink = { fg = colors.function_name, underline = true },
		RenderMarkdownLinkText = { fg = colors.accent, bold = true },

		-- TreeSitter markdown groups
		["@markup.heading.1.markdown"] = { fg = colors.accent_bright, bold = true },
		["@markup.heading.2.markdown"] = { fg = colors.function_name, bold = true },
		["@markup.heading.3.markdown"] = { fg = colors.type_name, bold = true },
		["@markup.heading.4.markdown"] = { fg = colors.string, bold = true },
		["@markup.heading.5.markdown"] = { fg = colors.analogous1 },
		["@markup.heading.6.markdown"] = { fg = colors.analogous2 },
		["@markup.quote.markdown"] = { fg = colors.string, italic = true },
		["@markup.heading.markdown"] = { fg = colors.accent },
		["@markup.list.markdown"] = { fg = colors.accent, bg = "none" },
		["@markup.list.unchecked.markdown"] = { fg = colors.comment, bg = "none" },
		["@markup.list.checked.markdown"] = { fg = colors.success, bg = "none" },
		["@markup.link.label.markdown"] = { fg = colors.accent, bold = true },
		["@markup.link.url.markdown"] = { fg = colors.function_name, underline = true },
		["@markup.raw.markdown_inline"] = { fg = colors.accent_bright, bg = colors.highlight },
		["@markup.raw.block.markdown"] = { fg = colors.accent_bright },

		-- Markdown quote block background
		["@text.quote"] = { fg = colors.string, bg = utils.adjust_opacity(colors.string, 0.15, "#0f0f0f"), italic = true },
		markdownBlockquote = { fg = colors.string, bg = utils.adjust_opacity(colors.string, 0.15, "#0f0f0f"), italic = true },

		-- Git Signs
		GitSignsAdd = { fg = colors.success },
		GitSignsChange = { fg = colors.warning },
		GitSignsDelete = { fg = colors.error },
		GitSignsCurrentLineBlame = { fg = colors.comment, italic = true },

		-- TreeSitter
		["@parameter"] = { fg = colors.accent_bright, italic = true },
		["@function"] = { fg = colors.function_name },
		["@function.builtin"] = { fg = colors.function_name },
		["@function.call"] = { fg = colors.function_name },
		["@method"] = { fg = colors.function_name },
		["@method.call"] = { fg = colors.function_name },
		["@keyword"] = { fg = colors.keyword },
		["@keyword.function"] = { fg = colors.keyword },
		["@keyword.operator"] = { fg = colors.keyword },
		["@keyword.return"] = { fg = colors.keyword },
		["@keyword.import"] = { fg = colors.keyword },
		["@operator"] = { fg = colors.operator },
		["@property"] = { fg = colors.type_name },
		["@field"] = { fg = colors.variable },
		["@variable"] = { fg = colors.variable },
		["@variable.builtin"] = { fg = colors.accent },
		["@variable.parameter"] = { fg = colors.accent_bright, italic = true },
		["@type"] = { fg = colors.type_name },
		["@type.builtin"] = { fg = colors.type_name },
		["@type.definition"] = { fg = colors.type_name },
		["@class"] = { fg = colors.type_name },
		["@constructor"] = { fg = colors.type_name },
		["@namespace"] = { fg = colors.type_name },
		["@module"] = { fg = colors.type_name },
		["@string"] = { fg = colors.string },
		["@string.escape"] = { fg = colors.accent_bright },
		["@string.regexp"] = { fg = colors.accent_bright },
		["@number"] = { fg = colors.number },
		["@boolean"] = { fg = colors.constant },
		["@constant"] = { fg = colors.constant },
		["@constant.builtin"] = { fg = colors.constant },
		["@constant.macro"] = { fg = colors.constant },
		["@tag"] = { fg = colors.keyword },
		["@tag.attribute"] = { fg = colors.type_name },
		["@tag.delimiter"] = { fg = colors.operator },
		["@comment"] = { fg = colors.comment, italic = true },
		["@text.strong"] = { bold = true },
		["@text.emphasis"] = { italic = true },
		["@text.underline"] = { underline = true },
		["@text.strike"] = { strikethrough = true },
		["@text.uri"] = { fg = colors.info, underline = true },
		["@text.literal"] = { fg = colors.string },
		["@punctuation.delimiter"] = { fg = colors.operator },
		["@punctuation.bracket"] = { fg = colors.fg },
		["@punctuation.special"] = { fg = colors.accent },

		-- LSP
		["@lsp.type.namespace"] = { fg = colors.type_name },
		["@lsp.type.type"] = { fg = colors.type_name },
		["@lsp.type.class"] = { fg = colors.type_name },
		["@lsp.type.enum"] = { fg = colors.type_name },
		["@lsp.type.interface"] = { fg = colors.type_name },
		["@lsp.type.struct"] = { fg = colors.type_name },
		["@lsp.type.parameter"] = { fg = colors.accent_bright, italic = true },
		["@lsp.type.variable"] = { fg = colors.variable },
		["@lsp.type.property"] = { fg = colors.type_name },
		["@lsp.type.enumMember"] = { fg = colors.constant },
		["@lsp.type.function"] = { fg = colors.function_name },
		["@lsp.type.method"] = { fg = colors.function_name },
		["@lsp.type.macro"] = { fg = colors.keyword },
		["@lsp.type.decorator"] = { fg = colors.accent },
		["@lsp.type.keyword"] = { fg = colors.keyword },
		["@lsp.type.comment"] = { fg = colors.comment, italic = true },
		["@lsp.type.string"] = { fg = colors.string },
		["@lsp.type.number"] = { fg = colors.number },
		["@lsp.type.operator"] = { fg = colors.operator },
		["@lsp.mod.deprecated"] = { strikethrough = true },
		["@lsp.mod.readonly"] = { italic = true },

		-- Rainbow brackets
		["@rainbow.bracket.level1"] = { fg = colors.bracket1 },
		["@rainbow.bracket.level2"] = { fg = colors.bracket2 },
		["@rainbow.bracket.level3"] = { fg = colors.bracket3 },
		["@rainbow.bracket.level4"] = { fg = colors.bracket4 },
		["@rainbow.bracket.level5"] = { fg = colors.bracket5 },
		["@rainbow.bracket.level6"] = { fg = colors.bracket6 },

		-- Wolfram Language LSP semantic highlighting
		-- These colors are derived from the accent to maintain theme cohesiveness
		["@lsp.mod.Module.wolfram"] = { fg = colors.wolfram_module },
		["@lsp.mod.Block.wolfram"] = { fg = colors.wolfram_block },
		["@lsp.mod.With.wolfram"] = { fg = colors.wolfram_with },
		["@lsp.mod.shadowed.wolfram"] = { fg = colors.warning },
		["@lsp.mod.error.wolfram"] = { fg = colors.error },
		["@lsp.mod.unused.wolfram"] = { fg = colors.comment, italic = true },
		["@lsp.mod.declaration.wolfram"] = { fg = colors.function_name, italic = true },
		["@lsp.type.type.wolfram"] = { fg = utils.rotate_hue(colors.type_name, 50), italic = true },
		["@lsp.type.parameter.wolfram"] = { fg = colors.accent_bright, italic = true },
		["@lsp.type.parameter.shadowed.wolfram"] = { fg = colors.warning, italic = true },
		["@lsp.type.parameter.error.wolfram"] = { fg = colors.error },
		["@lsp.type.parameter.unused.wolfram"] = { fg = colors.comment, italic = true },
		["@lsp.typemod.type.error.wolfram"] = { fg = colors.comment, italic = true },

		-- Wolfram built-in functions (use keyword/accent color for thematic cohesion)
		["@lsp.type.function.wolfram"] = { fg = colors.keyword },
		["@lsp.type.method.wolfram"] = { fg = colors.keyword },
		["@lsp.mod.defaultLibrary.wolfram"] = { fg = colors.keyword },
		["@function.builtin.wolfram"] = { fg = colors.keyword },
		["@function.wolfram"] = { fg = colors.keyword },
	}

	-- Set terminal colors
	vim.g.terminal_color_0 = terminal_colors.black
	vim.g.terminal_color_1 = terminal_colors.red
	vim.g.terminal_color_2 = terminal_colors.green
	vim.g.terminal_color_3 = terminal_colors.yellow
	vim.g.terminal_color_4 = terminal_colors.blue
	vim.g.terminal_color_5 = terminal_colors.magenta
	vim.g.terminal_color_6 = terminal_colors.cyan
	vim.g.terminal_color_7 = terminal_colors.white
	vim.g.terminal_color_8 = terminal_colors.bright_black
	vim.g.terminal_color_9 = terminal_colors.bright_red
	vim.g.terminal_color_10 = terminal_colors.bright_green
	vim.g.terminal_color_11 = terminal_colors.bright_yellow
	vim.g.terminal_color_12 = terminal_colors.bright_blue
	vim.g.terminal_color_13 = terminal_colors.bright_magenta
	vim.g.terminal_color_14 = terminal_colors.bright_cyan
	vim.g.terminal_color_15 = terminal_colors.bright_white

	-- Clear any existing indent line highlights first
	pcall(vim.api.nvim_set_hl, 0, "IblIndent", {})
	pcall(vim.api.nvim_set_hl, 0, "IblWhitespace", {})
	pcall(vim.api.nvim_set_hl, 0, "IblScope", {})
	pcall(vim.api.nvim_set_hl, 0, "VirtColumn", {})

	-- Apply highlights
	for group, o in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, o)
	end

	-- Force re-apply indent guides to make sure they're dark (break any links)
	vim.api.nvim_set_hl(0, "IblIndent", { fg = "#1a1a1a", bg = "NONE", default = false, nocombine = true })
	vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#1a1a1a", bg = "NONE", default = false, nocombine = true })
	vim.api.nvim_set_hl(0, "IblScope", { fg = "#252525", bg = "NONE", default = false, nocombine = true })
	vim.api.nvim_set_hl(0, "VirtColumn", { fg = "#1a1a1a", bg = "NONE", default = false, nocombine = true })
	-- Also set NonText to be subtle in case something links to it
	vim.api.nvim_set_hl(0, "NonText", { fg = colors.line_numbers, bg = "NONE" })

	-- Store the current accent for reference
	vim.g.system_accent_color = base_accent

	-- Set up dynamic watching if enabled (default: true)
	if opts.watch ~= false then
		M.start_watching()
	end
end

-- Start watching for system accent changes
function M.start_watching()
	-- Check every 5 seconds for accent color changes
	local check_interval = 3000

	local timer = vim.loop.new_timer()
	if not timer then
		return
	end

	timer:start(check_interval, check_interval, vim.schedule_wrap(function()
		-- Only check if we're using system-accent theme
		if vim.g.colors_name ~= "system-accent" then
			return
		end

		local current_accent = vim.g.system_accent_color
		local new_accent = get_system_accent()

		if new_accent ~= current_accent then
			-- System accent has changed, reload theme
			vim.notify(
				"System accent changed: " .. current_accent .. " → " .. new_accent,
				vim.log.levels.INFO
			)
			M.setup({ watch = true })

			-- Refresh UI components
			if _G.refresh_lualine then
				pcall(_G.refresh_lualine)
			end
			if _G.refresh_barbar then
				pcall(_G.refresh_barbar)
			end
			vim.cmd("redraw!")
		end
	end))

	-- Store timer in module-level variable
	accent_watcher_timer = timer
end

-- Stop watching for changes
function M.stop_watching()
	if accent_watcher_timer then
		accent_watcher_timer:stop()
		accent_watcher_timer:close()
		accent_watcher_timer = nil
	end
end

-- Manual refresh function
function M.refresh()
	M.setup({ watch = true })
	if _G.refresh_lualine then
		pcall(_G.refresh_lualine)
	end
	if _G.refresh_barbar then
		pcall(_G.refresh_barbar)
	end
	vim.cmd("redraw!")
	vim.notify("System accent theme refreshed!", vim.log.levels.INFO)
end

-- Debug highlight at cursor
vim.api.nvim_create_user_command('ThemeDebugHighlight', function()
	local line = vim.fn.line('.')
	local col = vim.fn.col('.')
	local hl_id = vim.fn.synID(line, col, 1)
	local hl_name = vim.fn.synIDattr(hl_id, 'name')
	local trans_id = vim.fn.synIDtrans(hl_id)
	local trans_name = vim.fn.synIDattr(trans_id, 'name')

	local hl = vim.api.nvim_get_hl(0, { name = hl_name })
	local result = string.format(
		"Highlight: %s (trans: %s)\nFG: %s, BG: %s",
		hl_name,
		trans_name,
		hl.fg and string.format("#%06x", hl.fg) or "none",
		hl.bg and string.format("#%06x", hl.bg) or "none"
	)
	print(result)
	vim.notify(result, vim.log.levels.INFO)
end, {})

return M
