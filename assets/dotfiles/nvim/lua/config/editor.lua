-- Nvim Setup

vim.diagnostic.config({
	-- virtual_lines = true,
	virtual_text = true,
})
vim.opt.termguicolors = true
-- vim.o.colorcolumn = '80,100'                 -- Highlight columns 80 and 100

vim.o.list = true                            -- Show whitespace characters
vim.o.listchars = 'tab: ,lead:·,trail:·'    -- Whitespace character markers
vim.opt.shell = 'fish'                       -- Set default terminal shell
vim.wo.relativenumber = true                 -- Relative Line numbers
vim.wo.number = true                         -- Absolute Line number
vim.o.laststatus = 3                         -- Global statusline
vim.o.foldcolumn = '1'                       -- Show one fold column in the margin
vim.o.foldtext = ""
vim.o.foldlevel = 99                         -- Show all fold buttons at one level
vim.o.foldlevelstart = 99                    -- Start with all folds open
vim.o.foldnestmax = 10                       -- Maximum fold nesting level
vim.o.foldenable = true                      -- Enable folding


vim.opt.fillchars:append {
	foldsep = ' ',     -- Separator between folds
}
vim.o.laststatus = 3
