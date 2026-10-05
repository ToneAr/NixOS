-- Wolfram Language Semantic Highlighting
-- This module provides fallback highlight groups for Wolfram Language
-- that work with any colorscheme

local M = {}

-- Set up Wolfram-specific highlight groups that respect the current colorscheme
function M.setup()
	-- Create augroup for Wolfram highlighting
	vim.api.nvim_create_augroup("WolframHighlighting", { clear = true })
	
	-- Apply Wolfram highlights after any colorscheme change
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = "WolframHighlighting",
		callback = function()
			M.apply_highlights()
		end
	})
	
	-- Apply immediately
	M.apply_highlights()
end

-- Apply highlight groups based on the current colorscheme
function M.apply_highlights()
	-- Skip if custom themes are active (they define their own)
	if vim.g.colors_name == "tonewl" or vim.g.colors_name == "system-accent" then
		return
	end
	
	-- Get some base colors from the current colorscheme
	local function get_hl_attr(group, attr)
		local hl = vim.api.nvim_get_hl(0, { name = group })
		return hl[attr]
	end
	
	-- Try to get colors from common highlight groups
	local function_fg = get_hl_attr("Function", "fg") or get_hl_attr("Identifier", "fg")
	local type_fg = get_hl_attr("Type", "fg")
	local keyword_fg = get_hl_attr("Keyword", "fg")
	local string_fg = get_hl_attr("String", "fg")
	local comment_fg = get_hl_attr("Comment", "fg")
	local error_fg = get_hl_attr("ErrorMsg", "fg") or get_hl_attr("Error", "fg")
	local warning_fg = get_hl_attr("WarningMsg", "fg") or get_hl_attr("DiagnosticWarn", "fg")
	local constant_fg = get_hl_attr("Constant", "fg")
	local special_fg = get_hl_attr("Special", "fg")
	
	-- Define Wolfram-specific highlight groups
	-- Module, Block, With scopes use different shades
	vim.api.nvim_set_hl(0, "@lsp.mod.Module.wolfram", { fg = keyword_fg })
	vim.api.nvim_set_hl(0, "@lsp.mod.Block.wolfram", { fg = special_fg or keyword_fg })
	vim.api.nvim_set_hl(0, "@lsp.mod.With.wolfram", { fg = constant_fg or keyword_fg })
	
	-- Shadowed variables (warning)
	vim.api.nvim_set_hl(0, "@lsp.mod.shadowed.wolfram", { fg = warning_fg, italic = true })
	
	-- Error highlighting
	vim.api.nvim_set_hl(0, "@lsp.mod.error.wolfram", { fg = error_fg })
	vim.api.nvim_set_hl(0, "@lsp.type.parameter.error.wolfram", { fg = error_fg })
	vim.api.nvim_set_hl(0, "@lsp.typemod.type.error.wolfram", { fg = error_fg, italic = true })
	
	-- Unused variables (dimmed)
	vim.api.nvim_set_hl(0, "@lsp.mod.unused.wolfram", { fg = comment_fg, italic = true })
	vim.api.nvim_set_hl(0, "@lsp.type.parameter.unused.wolfram", { fg = comment_fg, italic = true })
	
	-- Declaration highlighting
	vim.api.nvim_set_hl(0, "@lsp.mod.declaration.wolfram", { fg = function_fg, italic = true })
	
	-- Type highlighting
	vim.api.nvim_set_hl(0, "@lsp.type.type.wolfram", { fg = type_fg, italic = true })
	
	-- Parameter highlighting
	vim.api.nvim_set_hl(0, "@lsp.type.parameter.wolfram", { fg = string_fg or constant_fg, italic = true })
	vim.api.nvim_set_hl(0, "@lsp.type.parameter.shadowed.wolfram", { fg = warning_fg, italic = true })
	
	-- Built-in functions (use function color)
	vim.api.nvim_set_hl(0, "@lsp.type.function.wolfram", { fg = function_fg })
	vim.api.nvim_set_hl(0, "@lsp.type.method.wolfram", { fg = function_fg })
	vim.api.nvim_set_hl(0, "@lsp.mod.defaultLibrary.wolfram", { fg = function_fg })
	vim.api.nvim_set_hl(0, "@function.builtin.wolfram", { fg = function_fg })
	vim.api.nvim_set_hl(0, "@function.wolfram", { fg = function_fg })
end

return M
