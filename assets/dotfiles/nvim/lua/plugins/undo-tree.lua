return {
	"jiaoshijie/undotree",
	opts = {
		keymaps = {
			j = "move_next",
			k = "move_prev",
			gj = "move2parent",
			J = "move_change_next",
			K = "move_change_prev",
			['<cr>'] = "action_enter",
			p = "enter_diffbuf",
			q = "quit",
		},
	},
	keys = { -- load the plugin only when using it's keybinding:
		{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
	 },
}
