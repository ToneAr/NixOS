return {
	{
		"saghen/blink.compat",
		optional = true,
		opts = {},
	},
	{
		'saghen/blink.cmp',
		build = function() require('blink.cmp').build():pwait() end,
		dependencies = {
			'saghen/blink.lib',
			'rafamadriz/friendly-snippets',
			-- 'frankroeder/parrot.nvim',
			{
				'supermaven-inc/supermaven-nvim',
				opts = {
					disable_inline_completion = true,
					disable_keymaps = true,
				}
			},
			'huijiro/blink-cmp-supermaven',
			'saghen/blink.compat',
			'giuxtaposition/blink-cmp-copilot'
		},
		preload = {

		},
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
			"sources.default",
		},
		opts = {
			keymap = {
				preset = 'default',
				['<C-Space>'] = { 'show', 'fallback' },
				['<M-Right>'] = { 'show_documentation', 'fallback' },
				['<M-Left>']  = { 'hide_documentation', 'fallback' },
				['<Tab>']     = { 'select_and_accept', 'fallback'},
				['<Esc>']     = { 'cancel', 'fallback'},
				['<Down>']    = { 'select_next', 'fallback' },
				['<Up>']      = { 'select_prev', 'fallback' },
				['<M-Down>']  = { 'scroll_documentation_down', 'fallback_to_mappings', 'fallback' },
				['<M-Up>']    = { 'scroll_documentation_up', 'fallback_to_mappings', 'fallback' }
			},
			appearance = {
				nerd_font_variant = 'mono',
				use_nvim_cmp_as_default = true,
			},
			signature = {
				enabled = true,
				window = { border = 'rounded' }
			},
			completion = {
				list = {
					selection = {
						preselect = true,
						auto_insert = false
					}
				},
				accept = {
					auto_brackets = {
						enabled = true,
						override_brackets_for_filetypes = {
							-- blocked filetypes (no auto brackets)
							sql = {}, ruby = {}, perl = {}, lisp = {}, scheme = {},
							clojure = {}, prolog = {}, vb = {}, elixir = {}, smalltalk = {},
							applescript = {}, elm = {}, rust = {}, nu = {}, cpp = {},
							fennel = {}, janet = {}, ps1 = {}, racket = {},

							-- languages with a space
							haskell = { ' ', '' },
							fsharp = { ' ', '' },
							ocaml = { ' ', '' },
							erlang = { ' ', '' },
							tcl = { ' ', '' },
							nix = { ' ', '' },
							helm = { ' ', '' },
							lean = { ' ', '' },
							shell = { ' ', '' },
							sh = { ' ', '' },
							bash = { ' ', '' },
							fish = { ' ', '' },
							zsh = { ' ', '' },
							powershell = { ' ', '' },
							make = { ' ', '' },

							-- languages with square brackets
							wl = { '[', ']' },
							wolfram = { '[', ']' },
							context = { '[', ']' },

							-- languages with curly brackets
							tex = { '{', '}' },
							plaintex = { '{', '}' },
						}
					},
				},
				menu = {
					draw = {
						treesitter = { "lsp" }
					},
					border = 'rounded',
				},
				documentation = {
					auto_show = true,
					window = { border = 'rounded' }
				},
				ghost_text = {
					enabled = true,
					show_without_selection = false
				},
			},
			sources = {
				default = {
					'lsp', 'path', 'snippets', 'buffer', 'supermaven'
				},
				-- compat = { 'supermaven'},
				providers = {
					-- parrot = {
					-- 	module = "parrot.completion.blink",
					-- 	name = "parrot",
					-- 	score_offset = 20,
					-- 	opts = {
					-- 		show_hidden_files = false,
					-- 		max_items = 50,
					-- 	},
					-- },
					supermaven = {
						module = "blink-cmp-supermaven",
						name = "supermaven",
						score_offset = 20,
						async = true,
					},
				},
			},
			-- fuzzy = { implementation = "rust" }
		},
	},
	config = function(_, opts)
		local enabled = opts.sources.default
		for _, source in ipairs(opts.sources.compat or {}) do
			opts.sources.providers[source] = vim.tbl_deep_extend(
				"force",
				{
					name = source,
					module = "blink.compat.source"
				},
				opts.sources.providers[source] or {}
			)
			if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
				table.insert(enabled, source)
			end
		end
		opts.sources.compat = nil
	end,
	highlight = {
		CompletionMenu = { fg = "#c0caf5", bg = "#1a1b26" },
		CompletionMenuSelected = { fg = "#7aa2f7", bg = "#283457", bold = true },
		CompletionMenuBorder = { fg = "#7aa2f7", bg = "#1a1b26" },
	},
}
