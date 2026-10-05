return {
	{
		"goolord/alpha-nvim",
		-- dependencies = { 'echasnovski/mini.icons' },
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			local startify = require("alpha.themes.startify")
			startify.file_icons.provider = "devicons"
			local dashboard = require("alpha.themes.dashboard")
			-- add today's date in the footer
			local today = os.date("%a, %b %d, %Y")

			local header_hl = {
				{ { "AlphaHeader_N_shadow", 0, -1 } }, -- Line 1: date
				{ { "AlphaBorder", 0, -1 } },    -- Line 2: top border
				{ -- Start of logo
					{ "AlphaBorder", 0, 48 },
					{ "AlphaHeader_i_0", 48, 72 },
					{ "AlphaBorder", 72, -1 }
				},
				{
					{ "AlphaBorder", 0, 1 },
					{ "AlphaHeader_N_0", 1, 54 },
					{ "AlphaHeader_V_0", 54, 88 },
					{ "AlphaHeader_i_0", 88, 120 },
					{ "AlphaBorder", 120, -1 }
				},
				{
					{ "AlphaBorder", 0, 1 },
					{ "AlphaHeader_N_1", 1, 54 },
					{ "AlphaHeader_V_1", 54, 120 },
					{ "AlphaBorder", 120, -1 }
				},
				{
					{ "AlphaBorder", 0, 1 },
					{ "AlphaHeader_N_2", 1, 47 },
					{ "AlphaHeader_N_shadow", 47, 49 },
					{ "AlphaHeader_e_0", 49, 79 },
					{ "AlphaHeader_o_0", 79, 92 },
					{ "AlphaHeader_V_2", 92, 122 },
					{ "AlphaHeader_i_0", 122, 135 },
					{ "AlphaHeader_m_0", 135, 177 },
					{ "AlphaBorder", 177, -1 }
				},
				{
					{ "AlphaBorder", 0, 1 },
					{ "AlphaHeader_N_3", 1, 46 },
					{ "AlphaHeader_e_1", 46, 79 },
					{ "AlphaHeader_o_1", 79, 98 },
					{ "AlphaHeader_V_3", 98, 126 },
					{ "AlphaHeader_i_1", 126, 142 },
					{ "AlphaHeader_m_1", 142, 194 },
					{ "AlphaBorder", 194, -1 }
				},
				{
					{ "AlphaBorder", 0, 1 },
					{ "AlphaHeader_N_4", 1, 46 },
					{ "AlphaHeader_e_2", 46, 79 },
					{ "AlphaHeader_o_2", 79, 104 },
					{ "AlphaHeader_V_4", 104, 128 },
					{ "AlphaHeader_i_2", 128, 144 },
					{ "AlphaHeader_m_2", 144, 194 },
					{ "AlphaBorder", 194, -1 }
				},
				{
					{ "AlphaBorder", 0, 1 },
					{ "AlphaHeader_N_5", 1, 48 },
					{ "AlphaHeader_e_3", 48, 80 },
					{ "AlphaHeader_o_3", 80, 112 },
					{ "AlphaHeader_V_5", 112, 134 },
					{ "AlphaHeader_i_3", 134, 148 },
					{ "AlphaHeader_m_3", 148, 198 },
					{ "AlphaBorder", 198, -1 }
				},
				{
					{ "AlphaBorder", 0, 1 },
					{ "AlphaHeader_N_6", 1, 46 },
					{ "AlphaHeader_e_4", 46, 74 },
					{ "AlphaHeader_o_4", 74, 108 },
					{ "AlphaHeader_V_6", 108, 128 },
					{ "AlphaHeader_i_4", 128, 144 },
					{ "AlphaHeader_m_4", 144, 194 },
					{ "AlphaBorder", 194, -1 }
				},
				{ -- End of flogo
					{ "AlphaBorder", 0, 1 },
					{ "AlphaHeader_N_shadow", 1, 44 },
					{ "AlphaHeader_e_shadow", 44, 74 },
					{ "AlphaHeader_o_shadow", 74, 104 },
					{ "AlphaHeader_V_shadow", 104, 116 },
					{ "AlphaHeader_i_shadow", 116, 136 },
					{ "AlphaHeader_m_shadow", 136, 194 },
					{ "AlphaBorder", 194, -1 }
				},
				{ { "AlphaBorder", 0, -1 } }, -- Line 12: empty
				{ { "AlphaBorder", 0, -1 } }, -- Line 13: bottom border
				{ { "AlphaBorder", 0, -1 } }, -- Empty
				{ { "AlphaBorder", 0, -1 } }, -- Empty
				{ { "AlphaBorder", 0, 16 } }, -- New File
				{ { "AlphaBorder", 0, -1 } }, -- Empty
				{ { "AlphaBorder", 0, 16 } }, -- Find File
				{ { "AlphaBorder", 0, -1 } }, -- Empty
				{ { "AlphaBorder", 0, 16 } }, -- Recent Files
				{ { "AlphaBorder", 0, -1 } }, -- Empty
				{ { "AlphaBorder", 0, 16 } }, -- Recent Projects
				{ { "AlphaBorder", 0, -1 } }, -- Empty
				{ { "AlphaBorder", 0, 16 } }, -- Help Pages
				{ { "AlphaBorder", 0, -1 } }, -- Empty
				{ { "AlphaBorder", 0, 16 } }, -- Quit NVIM
			}
			dashboard.section.header.opts.position = "center"
			dashboard.section.header.opts.hl = header_hl
			dashboard.section.header.val = {
				today,
				[[╭───────────────────────────────────────────────────────────────────────╮]],
				[[│                                                                     │]],
				[[│       ███████████           █████      ██                     │]],
				[[│      ███████████             █████                             │]],
				[[│      ████████████████ ███████████ ███   ███████     │]],
				[[│     ████████████████ ████████████ █████ ██████████████   │]],
				[[│    █████████████████████████████ █████ █████ ████ █████   │]],
				[[│  ██████████████████████████████████ █████ █████ ████ █████  │]],
				[[│ ██████  ███ █████████████████ ████ █████ █████ ████ ██████ │]],
				[[│ ██████   ██  ███████████████   ██ █████████████████ │]],
				[[│                                                                       │]],
				[[╰───────────────────────────────────────────────────────────────────────╯]]
			}

			dashboard.section.buttons.val = {
				dashboard.button( "n", "  New file" , ":ene <BAR> startinsert <CR>"),
				dashboard.button( "f", "  Find file" , ":Telescope find_files<CR>"),
				dashboard.button( "r", "  Recent files" , ":Telescope oldfiles<CR>"),
				dashboard.button( "p", "  Recent projects", ":Telescope project<CR>"),
				dashboard.button( "h", "  Help pages" , ":Telescope help_tags<CR>"),
				dashboard.button( "q", "  Quit NVIM" , ":qa<CR>"),
			}

			dashboard.section.footer.opts.hl = "AlphaHeader_N_shadow"
			dashboard.section.footer.val = {
					"Version: " .. vim.fn.system("cd ~/.config/nvim && git rev-parse --short HEAD"):gsub("\n", "")
			}
			require("alpha").setup(
				dashboard.config
			)
		end,
	},
	-- {
	-- 	"startup-nvim/startup.nvim",
	-- 	dependencies = {
	-- 		"nvim-telescope/telescope.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-telescope/telescope-file-browser.nvim"
	-- 	},
	-- 	config = function()
	-- 		require "startup".setup({
	-- 			section_1 = {
	-- 				type = "text",
	-- 				align = "center",
	-- 				title = "Welcome to Neovim",
	-- 				margin = 5,
	-- 				content = {
	--
	-- 				},
	-- 				highlight = "Structure",
	-- 				default_color = "#61afef",
	-- 			},
	-- 			options = {
	-- 				mapping_keys = true,
	-- 				cursor_column = 0.5,
	-- 				empty_lines_between_mappings = true,
	-- 				disable_statusline = true,
	-- 				padding = {1,2}
	-- 			},
	-- 			mappings = {
	-- 				execute_command = "<CR>",
	-- 				open_file = "o",
	-- 				open_file_split = "<c-o>",
	-- 				open_section = "<TAB>",
	-- 				open_help = "?",
	-- 			},
	-- 			colors = {
	-- 				background = "#282c34",
	-- 				folded_section = "#3e4451",
	-- 			},
	-- 			parts = {
	-- 				"section_1",
	-- 			}
	-- 		})
	-- 	end
	-- }
}
