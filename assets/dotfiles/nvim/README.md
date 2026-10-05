# WREL.vim
Neovim configuration for developing Wolfram language programsm integrating
with the Wolfram LSP, Wolfram Vim Syntax and Wolfram code snippets, among
many other features.

## Features
- **Wolfram LSP, Syntax and Snippets**
	The Wolfram language is fully supported with Wolfram LSP integration, vim
	syntax highlighting, auto-completion and code snippets.
- **Auto-Completion**
	Auto-Completion has been set up using the rust based `blink.cmp` for quick
	autocompletion and function information retrieval.
- **AI Auto-Completion**
	Auto-Completion has been set up with `supermaven` and should work out of the
	box and has been integrated with the `blink.cmp` autocompletion menu.
- **AI Companion**
	A full copilot-style AI companion has been included which can use your own API
	keys to provide:
	- `<C-M-i>` - Side chat (with tool and file access)
	- `<C-i>`   - Inline chat (editing and questions)
- **Telescope navigaiton**
	Efficient navigation using telescope which allows you to quickly search
	through file names, contents, help pages and much more.
	- `<C-e>` - Search through project files.
	- `<C-f>` - Live grep through all project files (find text).
	- `<C-h>` - Search through the help pages.
	- `<C-p>` - Search through known project workspaces.
- **IDE-style terminal**
	An IDE-style terminal has been included and can be accessed using
	`<C-j>` and `<C-/>`.
- **Git integration**
	A git companion plugin called LazyGit has been included allowing for
	very easy git repo management and can be accessed using `<leader>lg`.
	Inline git blame and git history have also added.
- **Docker plugin**
	A docker companion plugin called LazyDocker has been included for easy
	container management and can be accessed using `<leader>ld`.
- **Prettier support**
	The 'Prettier' linter is integrated in WREL.vim for code formatting and
	can be used by using `<leader>kf` to format the currently selected buffer.
- **LSP manager**
	LSPs can be managed using the `Mason` LSP manager, with many LSPs including
	a very handy typo LSP or color LSP to highlight colors in all languages.
	Example: touble
- **Color Picker**
	A GUI color picker to choose the current color.Can be accessed with
	`<leader>v`.
	Example: rgb(217 86 195)
- **Tab bar**
	A tab bar and custom keybinds have been added to aid with tab navigation.
	Navigate the tabs using `<M-h>` and `<M-l>` to move between different tabs.
- **Better file explorer**
	Two file explorers are included with WREL.vim. Oil.vim treats directories
	as any other buffer, allowing very easy editing, while yazy.vim is a more
	graphical interface. Access Oil using `<C-b>` and yazi with `<leader>-`.
- **Visual improvements**
	- Improved UI
	- Markdown Renderer
	- Rainbow brackets
	- Code Folding
- **Various other integrations**
	- Obsidian notes
	- Jira & Stash (WIP)


