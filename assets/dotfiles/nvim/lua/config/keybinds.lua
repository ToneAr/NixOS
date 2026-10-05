vim.g.leader = " "

-- Editor
vim.keymap.set("v",                       -- Copy to Clipboard
	"<C-c>",
	"\"+y",
	{ noremap = true, silent = true }
)
vim.keymap.set("v",                       -- Copy to Clipboard
	"<C-x>",
	"\"+d",
	{ noremap = true, silent = true }
)
vim.keymap.set({"n", "i", "v"},           -- Save file
	"<C-s>",
	function() vim.cmd("w") end,
	{ noremap = true, silent = true }
)
vim.keymap.set("n",                       -- Quit Buffer
	"<leader>q",
	function () vim.cmd("q") end
)
vim.keymap.set({"n", "i", "v"},           -- Quit Nvim
	"<C-q>",
	function() vim.cmd("qa") end,
	{ noremap = true, silent = true }
)
vim.keymap.set({"n", "i", "v"},           -- Force Quit Nvim
	"<M-q>",
	function () vim.cmd("qa!") end,
	{ noremap = true, silent = true }
)
vim.keymap.set("n",
	"<leader>d",
	":bd<CR>",
	{ noremap = true, silent = true }
)
vim.keymap.set("n",
	"<leader>h",          -- Horizontal Split
	function() vim.cmd("split") end
)
vim.keymap.set("n",       -- Vertical Split
	"<leader>l",
	function() vim.cmd("vsplit") end
)
vim.keymap.set("n",
	"<leader><BS>",
	function() vim.cmd("noh") end
)
vim.keymap.set("n",       -- Code Actions
	"<leader>.",
	function() vim.lsp.buf.code_action() end
)
vim.keymap.set("n",
	"<C-BS>",
	"daw",
	{ noremap = true, silent = true }
)
vim.keymap.set("n",
	"<M-BS>",
	"caw",
	{ noremap = true, silent = true }
)
vim.keymap.set("n",
	"<C-S-f>",
	":%s@@@g",
	{ noremap = true }
)

-- Tab Bar
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)

vim.keymap.set('n', '<A-h>', '<Cmd>BufferPrevious<CR>', opts)
vim.keymap.set('n', '<A-l>', '<Cmd>BufferNext<CR>', opts)

vim.keymap.set('n', '<A-k>', '<Cmd>BufferMovePrevious<CR>', opts)
vim.keymap.set('n', '<A-j>', '<Cmd>BufferMoveNext<CR>', opts)

vim.keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
vim.keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
vim.keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
vim.keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
vim.keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
vim.keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
vim.keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
vim.keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
vim.keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
vim.keymap.set('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)


-- Session Manager
local persistence = require("persistence")
vim.keymap.set("n", "<leader>qs", function() persistence.load() end)
vim.keymap.set("n", "<leader>qS", function() persistence.select() end)
vim.keymap.set("n", "<leader>ql", function() persistence.load({ last = true }) end)
vim.keymap.set("n", "<leader>qd", function() persistence.stop() end)

-- Docker
vim.keymap.set({ 'n', 't' },
	'<leader>ld',
	'<Cmd>lua LazyDocker.toggle()<CR>'
)

-- Telescope
local tscopeBuiltin = require'telescope.builtin'
local telescope = require('telescope')
vim.keymap.set({"n", "i", "v"}, "<C-e>", tscopeBuiltin.find_files , { noremap = true, silent = true })
vim.keymap.set({"n", "i", "v"}, "<C-f>", tscopeBuiltin.live_grep , { noremap = true, silent = true })
vim.keymap.set({"n", "i", "v"}, "<C-o>", tscopeBuiltin.buffers , { noremap = true, silent = true })
vim.keymap.set({"n", "i", "v"}, "<C-t>", tscopeBuiltin.oldfiles, { noremap = true, silent = true })
vim.keymap.set({"n", "i", "v"}, "<C-h>", tscopeBuiltin.help_tags , { noremap = true, silent = true })
vim.keymap.set("n", "<C-p>", function() telescope.extensions.project.project{} end, { noremap = true, silent = true })

-- File Explorer
vim.keymap.set("n", "<C-b>", ":Oil<CR>")

-- AI Chat
vim.keymap.set("n", "<leader>i", ":CodeCompanionActions<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-i>", ":CodeCompanion<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-M-I>", ":CodeCompanionChat Toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<C-i>", ":'<,'>CodeCompanion<CR>", { noremap = true, silent = true })

-- Prettier
vim.keymap.set("n", "<leader>kf", ":Prettier<CR>", { remap = true, silent = true })

-- Theme Switcher
local theme_switcher = require("config.theme-switcher")
vim.keymap.set("n", "<leader>th", theme_switcher.pick_theme, { noremap = true, silent = true, desc = "Pick theme" })
vim.keymap.set("n", "<leader>tn", theme_switcher.next_theme, { noremap = true, silent = true, desc = "Next theme" })
vim.keymap.set("n", "<leader>tp", theme_switcher.prev_theme, { noremap = true, silent = true, desc = "Previous theme" })
vim.keymap.set("n", "<leader>tr", function()
	if vim.g.colors_name == "system-accent" then
		require("config.system-theme").refresh()
	else
		vim.notify("System accent refresh only works with System Accent theme", vim.log.levels.WARN)
	end
end, { noremap = true, silent = true, desc = "Refresh system accent" })
