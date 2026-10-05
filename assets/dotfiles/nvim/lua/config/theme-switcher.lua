-- Theme Switcher Module
local M = {}

-- List of available themes
M.themes = {
	{ name = "System (Dynamic)", value = "system-accent", custom = true },
	{ name = "ToneWL", value = "tonewl", custom = true },
	{ name = "Catppuccin Mocha", value = "catppuccin-mocha" },
	{ name = "Catppuccin Macchiato", value = "catppuccin-macchiato" },
	{ name = "Catppuccin Frappe", value = "catppuccin-frappe" },
	{ name = "Catppuccin Latte", value = "catppuccin-latte" },
	{ name = "Tokyo Night", value = "tokyonight" },
	{ name = "Tokyo Night Storm", value = "tokyonight-storm" },
	{ name = "Tokyo Night Moon", value = "tokyonight-moon" },
	{ name = "Tokyo Night Day", value = "tokyonight-day" },
	{ name = "Rose Pine", value = "rose-pine" },
	{ name = "Rose Pine Moon", value = "rose-pine-moon" },
	{ name = "Rose Pine Dawn", value = "rose-pine-dawn" },
	{ name = "Gruvbox Dark", value = "gruvbox" },
	{ name = "Kanagawa Wave", value = "kanagawa-wave" },
	{ name = "Kanagawa Dragon", value = "kanagawa-dragon" },
	{ name = "Kanagawa Lotus", value = "kanagawa-lotus" },
	{ name = "Nightfox", value = "nightfox" },
	{ name = "Dayfox", value = "dayfox" },
	{ name = "Dawnfox", value = "dawnfox" },
	{ name = "Duskfox", value = "duskfox" },
	{ name = "Nordfox", value = "nordfox" },
	{ name = "Terafox", value = "terafox" },
	{ name = "Carbonfox", value = "carbonfox" },
}

-- File to store the current theme preference
local theme_file = vim.fn.stdpath("data") .. "/current_theme.txt"

-- Save the current theme to file
local function save_theme(theme)
	local file = io.open(theme_file, "w")
	if file then
		file:write(theme)
		file:close()
	end
end

-- Load the saved theme from file
local function load_saved_theme()
	local file = io.open(theme_file, "r")
	if file then
		local theme = file:read("*all")
		file:close()
		return theme
	end
	return "tonewl" -- Default to custom theme
end

-- Clear all highlight groups to ensure clean theme switching
local function clear_highlights()
	-- Clear syntax highlighting
	vim.cmd("syntax reset")

	-- Clear all highlight groups
	local all_groups = vim.fn.getcompletion("", "highlight")
	for _, group in ipairs(all_groups) do
		vim.cmd("highlight clear " .. group)
	end

	-- Explicitly clear indent line highlights to prevent persistence
	pcall(vim.api.nvim_set_hl, 0, "IblIndent", {})
	pcall(vim.api.nvim_set_hl, 0, "IblWhitespace", {})
	pcall(vim.api.nvim_set_hl, 0, "IblScope", {})
	pcall(vim.api.nvim_set_hl, 0, "VirtColumn", {})
end

-- Refresh UI components after theme change
local function refresh_ui()
	-- Refresh lualine
	if _G.refresh_lualine then
		pcall(_G.refresh_lualine)
	end

	-- Refresh barbar (tab bar)
	if _G.refresh_barbar then
		pcall(_G.refresh_barbar)
	end

	-- Refresh indent-blankline
	local ok_ibl, ibl = pcall(require, 'ibl')
	if ok_ibl then
		pcall(function()
			ibl.update({ enabled = true })
		end)
	end

	-- Force redraw
	vim.cmd("redraw!")
end

-- Apply a theme
function M.apply_theme(theme_value)
	-- Clear existing highlights for clean switching
	clear_highlights()

	-- Handle system accent theme
	if theme_value == "system-accent" then
		require("config.system-theme").setup()
		save_theme(theme_value)
		refresh_ui()
		local accent = vim.g.system_accent_color or "detected"
		vim.notify("Applied theme: System Accent (" .. accent .. ")", vim.log.levels.INFO)
		return
	end

	-- Handle custom ToneWL theme
	if theme_value == "tonewl" then
		require("config.theme").setup()
		save_theme(theme_value)
		refresh_ui()
		vim.notify("Applied theme: ToneWL (Custom)", vim.log.levels.INFO)
		return
	end

	-- Clear custom theme autocmds when switching to other themes
	local ok_augroup = pcall(function()
		vim.api.nvim_create_augroup("ToneWLTheme", { clear = true })
		vim.api.nvim_create_augroup("SystemAccentTheme", { clear = true })
	end)

	-- Stop system accent watcher if it's running
	local ok_stop = pcall(function()
		require("config.system-theme").stop_watching()
	end)

	-- Apply other themes
	local ok, err = pcall(function()
		vim.cmd.colorscheme(theme_value)
	end)

	if ok then
		save_theme(theme_value)
		refresh_ui()
		vim.notify("Applied theme: " .. theme_value, vim.log.levels.INFO)
	else
		vim.notify("Failed to apply theme: " .. theme_value .. "\n" .. tostring(err), vim.log.levels.ERROR)
	end
end

-- Show theme picker using vim.ui.select
function M.pick_theme()
	-- Create display names
	local display_items = {}
	for _, theme in ipairs(M.themes) do
		table.insert(display_items, theme.name)
	end

	vim.ui.select(display_items, {
		prompt = "Select a colorscheme:",
		format_item = function(item)
			return "  " .. item
		end,
	}, function(choice, idx)
		if choice and idx then
			M.apply_theme(M.themes[idx].value)
		end
	end)
end

-- Initialize and load the saved theme
function M.init()
	local saved_theme = load_saved_theme()

	-- Small delay to ensure plugins are loaded
	vim.defer_fn(function()
		M.apply_theme(saved_theme)
	end, 50)
end

-- Cycle to next theme
function M.next_theme()
	local current = load_saved_theme()
	local current_idx = 1

	-- Find current theme index
	for i, theme in ipairs(M.themes) do
		if theme.value == current then
			current_idx = i
			break
		end
	end

	-- Get next theme (wrap around)
	local next_idx = current_idx % #M.themes + 1
	M.apply_theme(M.themes[next_idx].value)
end

-- Cycle to previous theme
function M.prev_theme()
	local current = load_saved_theme()
	local current_idx = 1

	-- Find current theme index
	for i, theme in ipairs(M.themes) do
		if theme.value == current then
			current_idx = i
			break
		end
	end

	-- Get previous theme (wrap around)
	local prev_idx = current_idx == 1 and #M.themes or current_idx - 1
	M.apply_theme(M.themes[prev_idx].value)
end

return M
