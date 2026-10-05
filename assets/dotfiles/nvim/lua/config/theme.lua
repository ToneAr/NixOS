-- ToneWL Neovim Colorscheme
-- A port of the ToneWL VS Code theme
-- Author: GitHub Copilot (based on ToneWL by Tone)

local M = {}

-- Color palette
local colors = {
	-- Base UI colors
	bg = "none",
	-- bg = "#1E1D22",
	dark_bg = "#151515",
	lighter_bg = "#1F1E23",
	menu_bg = "#1E1D22",
	selection = "#2a2a3a",
	highlight = "#252535",
	fg = "#d4d4d8",
	fg_dark = "#a8a8b0",
	comment = "#706374",
	line_numbers = "#888888",
	active_line_nr = "#9a7fc4",

	-- Syntax colors
	black = "#000000",
	gray = "#999999",
	purple = "#b088d9",
	bright_purple = "#c49ae6",
	teal = "#5db89f",
	cyan = "#74c7cc",
	pink = "#d97aa3",
	yellow = "#d9c991",
	soft_yellow = "#a5a47a",
	orange = "#d18860",
	green = "#88c870",
	bright_green = "#74b89f",
	red = "#d46d6d",
	error = "#d46d6d",
	warning = "#c4a05a",
	info = "#7799cc",
	operator = "#8db899",
	status = "#3B3442",
	tabline = "#302B36",
	tabline_fill = "#1F1E21",
	menu = "#29262F",
	menu_select = "#393344",

	wolfram = {
		module = "#6db05a",
		block = "#5db89f",
		with = "#5db89f",
		shadowed = "#c47a5a",
		error = "#d46d6d",
		unused = "#777777",
		declaration = "#5db89f",
		type = "#d97aa3",
		parameter = "#c49ae6",
		parameter_shadowed = "#d18860",
		parameter_error = "#d46d6d",
		parameter_unused = "#777777",
		type_error = "#706374"
	},

	-- Bracket colors (more subtle, cohesive palette)
	bracket1 = "#74b89f",
	bracket2 = "#74c7cc",
	bracket3 = "#7799cc",
	bracket4 = "#9a7fc4",
	bracket5 = "#b088d9",
	bracket6 = "#c49ae6",

	-- Other
	border = "#6A6385",
	indent_guide = "#282828",
	active_indent = "#3a3a3a",
	find_match = "#6449d2",
	find_highlight = "#5338be",
}

-- Terminal colors
local terminal_colors = {
	black = "#333333",
	bright_black = "#666666",
	red = "#C4265E",
	bright_red = colors.purple,
	green = "#79DD6E",
	bright_green = "#5FD4AF",
	yellow = "#B3B42B",
	bright_yellow = "#E2E22E",
	blue = "#6C7EC8",
	bright_blue = "#819AFF",
	magenta = "#8C6BC8",
	bright_magenta = "#b888e6",
	cyan = "#49ADBC",
	bright_cyan = "#69BBFD",
	white = "#E3E3DD",
	bright_white = "#F8F8F2",
}

-- Define highlight groups
local highlights = {
	-- UI elements
	Normal = { fg = colors.fg, bg = colors.bg },
	NormalFloat = { fg = colors.fg, bg = colors.menu_bg },
	ColorColumn = { bg = colors.gray },
	Cursor = { fg = colors.bg, bg = colors.fg },
	CursorColumn = { bg = colors.gray },
	CursorLine = { bg = colors.highlight },
	CursorLineNr = { fg = colors.active_line_nr },
	LineNr = { fg = colors.active_line_nr },
	LineNrAbove = { fg = colors.line_numbers },
	LineNrBelow = { fg = colors.line_numbers },
	LineColumn = { bg = colors.menu_bg },
	SignColumn = { bg = colors.bg },
	VertSplit = { fg = colors.border },
	VertiColumn = { fg = colors.red },
	Folded = { fg = colors.comment, bg = colors.selection },
	FoldColumn = { fg = colors.border, bg = colors.tabline },
	MatchParent = { fg = colors.cyan, bold = true },
	-- Search
	IncSearch = { bg = colors.find_match, fg = colors.fg },
	Search = { bg = colors.find_highlight, fg = colors.fg },
	-- Tabs and statusline
	StatusLine = { fg = colors.fg, bg = colors.status },
	StatusLineNC = { fg = colors.comment, bg = colors.status },
	TabLine = { fg = colors.fg_dark, bg = colors.tabline },
	TabLineFill = { bg = colors.tabline_fill },
	TabLineSel = { fg = colors.fg, bg = colors.bg },
	Title = { fg = colors.teal },
	Visual = { bg = colors.selection },
	VisualNOS = { bg = colors.selection },
	-- Messages
	ErrorMsg = { fg = colors.error },
	WarningMsg = { fg = colors.warning },
	MoreMsg = { fg = colors.info },
	Question = { fg = colors.teal },
	-- Popup menus
	Pmenu = { fg = colors.fg, bg = colors.menu },
	PmenuSel = { fg = colors.fg, bg = colors.menu_select },
	PmenuSbar = { bg = colors.status },
	PmenuThumb = { bg = colors.border },
	-- DiagnosticWarn
	DiagnosticError = { fg = colors.error },
	DiagnosticWarn = { fg = colors.warning },
	DiagnosticInfo = { fg = colors.info },
	DiagnosticHint = { fg = colors.border },
	-- Syntax groups
	Comment = { fg = colors.comment, italic = true },
	Constant = { fg = terminal_colors.bright_magenta },
	String = { fg = colors.yellow },
	Character = { fg = terminal_colors.bright_magenta },
	Number = { fg = terminal_colors.bright_magenta },
	Boolean = { fg = terminal_colors.bright_magenta },
	Float = { fg = terminal_colors.bright_magenta },

	Identifier = { fg = colors.fg },
	Function = { fg = colors.cyan },

	Statement = { fg = colors.purple },
	Conditional = { fg = colors.purple },
	Repeat = { fg = colors.purple },
	Label = { fg = colors.purple },
	Operator = { fg = colors.operator },
	Keyword = { fg = colors.purple },
	Exception = { fg = colors.purple },

	PreProc = { fg = colors.purple },
	Include = { fg = colors.purple },
	Define = { fg = colors.purple },
	Macro = { fg = colors.purple },
	PreCondit = { fg = colors.purple },

	Type = { fg = colors.cyan, italic = true },
	StorageClass = { fg = colors.cyan, italic = true },
	Structure = { fg = colors.teal },
	Typedef = { fg = colors.cyan, italic = true },

	Special = { fg = colors.active_line_nr },
	SpecialChar = { fg = colors.bright_purple },
	Tag = { fg = colors.purple },
	Delimiter = { fg = colors.fg },
	SpecialComment = { fg = colors.comment, italic = true },
	Debug = { fg = colors.error },

	Underlined = { underline = true },
	Ignore = { fg = colors.comment },
	Error = { fg = colors.error },
	Todo = { fg = colors.bright_yellow, bg = colors.bg, bold = true },

	-- Indent Blankline
	IblIndent = { fg = colors.indent_guide, bg = "NONE", nocombine = true },
	IblWhitespace = { fg = colors.indent_guide, bg = "NONE", nocombine = true },
	IblScope = { fg = colors.indent_guide, bg = "NONE", nocombine = true },
	Parameter = { fg = colors.pink },
	NotifyBackground = { bg = colors.black },

	-- Render Markdown
	-- Base markdown elements
	MarkdownH1 = { fg = colors.bright_purple, bold = true },
	MarkdownH2 = { fg = colors.teal, bold = true },
	MarkdownH3 = { fg = colors.cyan, bold = true },
	MarkdownH4 = { fg = colors.yellow, bold = true },
	MarkdownH5 = { fg = colors.green },
	MarkdownH6 = { fg = colors.pink },
	MarkdownCode = { fg = colors.bright_purple, bg = colors.dark_bg },
	MarkdownCodeBlock = { bg = colors.dark_bg },
	MarkdownUrl = { fg = colors.teal, underline = true },
	MarkdownLinkText = { fg = colors.purple, bold = true },
	MarkdownListMarker = { fg = colors.purple },
	MarkdownBold = { fg = colors.bright_purple, bold = true },
	MarkdownItalic = { italic = true },
	MarkdownStrike = { fg = colors.comment, strikethrough = true },

	-- Render Markdown plugin (minimal style - backgrounds only on underline)
	RenderMarkdownH1 = { fg = colors.bright_purple, bold = true },
	RenderMarkdownH2 = { fg = colors.teal, bold = true },
	RenderMarkdownH3 = { fg = colors.cyan, bold = true },
	RenderMarkdownH4 = { fg = colors.yellow, bold = true },
	RenderMarkdownH5 = { fg = colors.green },
	RenderMarkdownH6 = { fg = colors.pink },

	-- Heading underline backgrounds (lighter/more transparent for subtle effect)
	RenderMarkdownH1Bg = { bg = "#1a1419", fg = colors.bright_purple },
	RenderMarkdownH2Bg = { bg = "#14191a", fg = colors.teal },
	RenderMarkdownH3Bg = { bg = "#14181a", fg = colors.cyan },
	RenderMarkdownH4Bg = { bg = "#1a1814", fg = colors.yellow },
	RenderMarkdownH5Bg = { bg = "#141a14", fg = colors.green },
	RenderMarkdownH6Bg = { bg = "#1a1419", fg = colors.pink },

	-- Code styling
	RenderMarkdownCode = { link = "MarkdownCodeBlock" },
	RenderMarkdownCodeInline = { fg = colors.bright_purple, bg = colors.highlight },
	RenderMarkdownBullet = { fg = colors.purple },

	-- Table styling
	RenderMarkdownTableHead = { fg = colors.purple, bold = true },
	RenderMarkdownTableRow = { fg = colors.indent_guide },

	-- Quote blocks
	RenderMarkdownQuote = { fg = colors.yellow, italic = true },

	-- Horizontal rules
	RenderMarkdownDash = { fg = colors.teal },

	-- Checkboxes
	RenderMarkdownChecked = { fg = colors.green },
	RenderMarkdownUnchecked = { fg = colors.comment },

	-- Links
	RenderMarkdownLink = { fg = colors.teal, underline = true },
	RenderMarkdownLinkText = { fg = colors.purple, bold = true },

	-- TreeSitter markdown groups
	["@markup.heading.1.markdown"] = { fg = colors.bright_purple, bold = true },
	["@markup.heading.2.markdown"] = { fg = colors.teal, bold = true },
	["@markup.heading.3.markdown"] = { fg = colors.cyan, bold = true },
	["@markup.heading.4.markdown"] = { fg = colors.yellow, bold = true },
	["@markup.heading.5.markdown"] = { fg = colors.green },
	["@markup.heading.6.markdown"] = { fg = colors.pink },
	["@markup.quote.markdown"] = { fg = colors.yellow, italic = true },
	["@markup.heading.markdown"] = { fg = colors.purple },
	["@markup.list.markdown"] = { fg = colors.purple, bg = "none" },
	["@markup.list.unchecked.markdown"] = { fg = colors.comment, bg = "none" },
	["@markup.list.checked.markdown"] = { fg = colors.green, bg = "none" },
	["@markup.link.label.markdown"] = { fg = colors.purple, bold = true },
	["@markup.link.url.markdown"] = { fg = colors.teal, underline = true },
	["@markup.raw.markdown_inline"] = { fg = colors.bright_purple, bg = colors.highlight },
	["@markup.raw.block.markdown"] = { fg = colors.bright_purple, bg = colors.dark_bg },

	-- TreeSitter
	["@parameter"] = { fg = colors.bright_purple, italic = true },
	["@function"] = { fg = colors.teal },
	["@method"] = { fg = colors.teal },
	["@keyword"] = { fg = colors.purple },
	["@keyword.function"] = { fg = colors.purple },
	["@keyword.operator"] = { fg = colors.purple },
	["@operator"] = { fg = colors.operator },
	["@property"] = { fg = colors.teal },
	["@field"] = { fg = colors.fg },
	["@variable"] = { fg = colors.fg },
	["@variable.builtin"] = { fg = colors.bright_purple },
	["@type"] = { fg = colors.cyan, italic = true },
	["@type.builtin"] = { fg = colors.cyan, italic = true },
	["@class"] = { fg = colors.teal, underline = true },
	["@constructor"] = { fg = colors.teal },
	["@namespace"] = { fg = colors.teal },
	["@string"] = { fg = colors.yellow },
	["@string.escape"] = { fg = colors.bright_purple },
	["@number"] = { fg = terminal_colors.bright_magenta },
	["@boolean"] = { fg = terminal_colors.bright_magenta },
	["@constant"] = { fg = terminal_colors.bright_magenta },
	["@constant.builtin"] = { fg = terminal_colors.bright_magenta },
	["@tag"] = { fg = colors.purple },
	["@tag.attribute"] = { fg = colors.teal },
	["@comment"] = { fg = colors.comment, italic = true },

	-- Generic LSP semantic tokens (language-agnostic)
	["@lsp.type.namespace"] = { fg = colors.teal },
	["@lsp.type.type"] = { fg = colors.cyan, italic = true },
	["@lsp.type.class"] = { fg = colors.teal, underline = true },
	["@lsp.type.enum"] = { fg = colors.cyan, italic = true },
	["@lsp.type.interface"] = { fg = colors.cyan, italic = true },
	["@lsp.type.struct"] = { fg = colors.cyan, italic = true },
	["@lsp.type.parameter"] = { fg = colors.bright_purple, italic = true },
	["@lsp.type.variable"] = { fg = colors.fg },
	["@lsp.type.property"] = { fg = colors.teal },
	["@lsp.type.enumMember"] = { fg = terminal_colors.bright_magenta },
	["@lsp.type.function"] = { fg = colors.teal },
	["@lsp.type.method"] = { fg = colors.teal },
	["@lsp.type.macro"] = { fg = colors.purple },
	["@lsp.type.keyword"] = { fg = colors.purple },
	["@lsp.type.comment"] = { fg = colors.comment, italic = true },
	["@lsp.type.string"] = { fg = colors.yellow },
	["@lsp.type.number"] = { fg = terminal_colors.bright_magenta },
	["@lsp.type.regexp"] = { fg = colors.bright_purple },
	["@lsp.type.operator"] = { fg = colors.operator },
	["@lsp.type.decorator"] = { fg = colors.bright_purple },

	-- Generic LSP modifiers (language-agnostic)
	["@lsp.mod.deprecated"] = { strikethrough = true },
	["@lsp.mod.readonly"] = { italic = true },
	["@lsp.mod.modification"] = { bold = true },
	["@lsp.mod.documentation"] = { fg = colors.comment, italic = true },

	-- Rainbow Brackets
	["@rainbow.bracket.level1"] = { fg = colors.bracket1 },
	["@rainbow.bracket.level2"] = { fg = colors.bracket2 },
	["@rainbow.bracket.level3"] = { fg = colors.bracket3 },
	["@rainbow.bracket.level4"] = { fg = colors.bracket4 },
	["@rainbow.bracket.level5"] = { fg = colors.bracket5 },
	["@rainbow.bracket.level6"] = { fg = colors.bracket6 },

	-- LSP Syntax Highlights
	["@lsp.mod.Module.wolfram"] = { fg = colors.wolfram.module },
	["@lsp.mod.Block.wolfram"] = { fg = colors.wolfram.block },
	["@lsp.mod.With.wolfram"] = { fg = colors.wolfram.with },
	["@lsp.mod.shadowed.wolfram"] = { fg = colors.wolfram.shadowed },
	["@lsp.mod.error.wolfram"] = { fg = colors.wolfram.error },
	["@lsp.mod.unused.wolfram"] = { fg = colors.wolfram.unused, italic = true },
	["@lsp.mod.declaration.wolfram"] = { fg = colors.wolfram.declaration, italic = true },
	["@lsp.type.type.wolfram"] = { fg = colors.wolfram.type, italic = true },
	["@lsp.type.parameter.wolfram"] = { fg = colors.wolfram.parameter, italic = true },
	["@lsp.type.parameter.shadowed.wolfram"] = { fg = colors.wolfram.parameter_shadowed, italic = true },
	["@lsp.type.parameter.error.wolfram"] = { fg = colors.wolfram.parameter_error },
	["@lsp.type.parameter.unused.wolfram"] = { fg = colors.wolfram.parameter_unused, italic = true },
	["@lsp.typemod.type.error.wolfram"] = { fg = colors.wolfram.type_error, italic = true},
}

function M.setup(opts)
	opts = opts or {}

	-- Clear any existing ToneWL autocmds
	vim.api.nvim_create_augroup("ToneWLTheme", { clear = true })

	-- Set colorscheme name
	vim.g.colors_name = "tonewl"

	-- Set WL filetype on appropriate files
	vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
		group = "ToneWLTheme",
		pattern = {"*.wl", "*.wls", "*.m", "*.nb", "*.wlt", "*.tr", "*.mt", "*.cdf"},
		callback = function()
			vim.bo.filetype = "wolfram"
		end,
	})

	-- Set up semantic tokens when LSP attaches
	vim.api.nvim_create_autocmd("LspAttach", {
		group = "ToneWLTheme",
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
					group = "ToneWLTheme",
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

	-- Apply highlight groups
	for g, o in pairs(highlights) do
		vim.api.nvim_set_hl(0, g, o)
	end
end

return M

