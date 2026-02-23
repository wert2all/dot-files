vim.pack.add({
	{
		src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
		version = vim.version.range("3"),
	},
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",

	"https://github.com/Koalhack/darcubox-nvim",
	"https://www.github.com/ibhagwan/fzf-lua",

	"https://github.com/j-hui/fidget.nvim",
        "https://github.com/rcarriga/nvim-notify",
	
        "https://www.github.com/lewis6991/gitsigns.nvim",

	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
})

require("plugins.colorscheme")
require("plugins.neo-tree")
require("plugins.fzf")
require("plugins.notify")
require("plugins.git")
require("plugins.treesitter")
require("plugins.lsp")
