return {
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/mcphub.nvim"
		},
		opts = {
			strategies = {
				chat = {
					adapter = {
						name = "openai",
						model = "gpt-5.6-sol"
					}
				},
			inline = {
					adapter = {
						name = "anthropic",
						model = "claude-haiku-4-5",
					}

				}
			},
			extensions = {
				mcphub = {
					callback = "mcphub.extensions.codecompanion",
					opts = {
						make_vars = true,
						make_slash_commands = true,
						show_result_in_chat = true
					}
				}
			},
			opts = {
				log_level = "DEBUG",
			},
		},
	},
	-- {
	-- 	"frankroeder/parrot.nvim",
	-- 	dependencies = {
	-- 		'ibhagwan/fzf-lua',
	-- 		'nvim-lua/plenary.nvim',
	-- 		'folke/noice.nvim',
	-- 	},
	-- 	config = function()
	-- 		require("parrot").setup {
	-- 			providers = {
	-- 				anthropic = {
	-- 					name = "anthropic",
	-- 					api_key = os.getenv("ANTHROPIC_API_KEY"),
	-- 					endpoint = "https://api.anthropic.com/v1/messages",
	-- 					params = {
	-- 						chat = { max_tokens = 4096 },
	-- 						command = { max_tokens = 4096 },
	-- 					},
	-- 					headers = function(self)
	-- 						return {
	-- 							["Content-Type"] = "application/json",
	-- 							["x-api-key"] = self.api_key,
	-- 							["anthropic-version"] = "2023-06-01",
	-- 						}
	-- 					end,
	-- 					models = {
	-- 						"claude-opus-4-20250514", "claude-sonnet-4-20250514",
	-- 						"claude-3-7-sonnet-20250219", "claude-3-5-sonnet-20241022",
	-- 						"claude-3-5-haiku-20241022", "claude-3-5-sonnet-20240620",
	-- 					},
	-- 					preprocess_payload = function(payload)
	-- 						for _, message in ipairs(payload.messages) do
	-- 							message.content =
	-- 								message.content:gsub("^%s*(.-)%s*$", "%1")
	-- 						end
	-- 						if payload.messages[1] and payload.messages[1].role == "system" then
	-- 							payload.system = payload.messages[1].content
	-- 							table.remove(payload.messages, 1)
	-- 						end
	-- 						return payload
	-- 					end,
	-- 				},
	-- 				openai = {
	-- 					name = "openai",
	-- 					api_key = os.getenv("OPENAI_API_KEY"),
	-- 					endpoint = "https://api.openai.com/v1/chat/completions",
	-- 					params = {
	-- 						chat = { temperature = 1, top_p = 1 },
	-- 						command = { temperature = 1, top_p = 1 },
	-- 					},
	-- 					topic = {
	-- 						model = "gpt-4.1-nano",
	-- 						params = { max_completion_tokens = 64 },
	-- 					},
	-- 					models ={
	-- 						"gpt-5",
	-- 						"gpt-5-mini",
	-- 						"gpt-4.1",
	-- 						"gpt-4o",
	-- 						"o4-mini",
	-- 						"gpt-4.1-nano",
	-- 					}
	-- 				},
	-- 			},
	-- 		}
	-- 	end,
	-- },
	{
		"folke/edgy.nvim",
		optional = true,
		opts = function(_, opts)
			opts.right = opts.right or {}
			table.insert(opts.right, {
				ft = "copilot-chat",
				title = "Copilot Chat",
				size = { width = 50 },
			})
		end,
	}
}
