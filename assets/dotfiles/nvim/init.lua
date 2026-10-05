-- Neovim Configuration

-- Load configuration files
require("config.lazy")
require("config.editor")
require("config.keybinds")
require("config.python")

-- Set up Wolfram Language semantic highlighting (works with all themes)
require("config.wolfram-highlights").setup()

-- Initialize theme switcher (will load saved theme)
require("config.theme-switcher").init()
