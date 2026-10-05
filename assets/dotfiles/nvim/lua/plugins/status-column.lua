return {
	'luukvbaal/statuscol.nvim',
	opts = function()
		local builtin = require('statuscol.builtin')
		return {
			setopt = true,
			relculright = true,
			ft_ignore = { 'NvimTree', 'Trouble', 'Outline', 'help', 'alpha', 'neo-tree' },
			bt_ignore = { 'nofile', 'terminal', 'help' },
			-- override the default list of segments with:
			-- number-less fold indicator, then signs, then line number & separator
			segments = {
				{ text = { '%s' }, click = 'v:lua.ScSa', hl = "LineColumn" },
				{
					text = { builtin.lnumfunc, ' ' },
					condition = { true, builtin.not_empty },
					click = 'v:lua.ScLa',
					hl = "LineColumn",
				},
				{ text = { ' ', builtin.foldfunc }, click = 'v:lua.ScFa', hl = "FoldColumn" },
				{ text = { ' ' }, hl = "FoldColumn" },
			},
		}
	end,
}
