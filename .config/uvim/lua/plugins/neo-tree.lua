return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			close_if_last_window = true,
			popup_border_style = "single",
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_by_name = {
						".git",
					},
					always_show = {
						".env",
					},
				},
				window = {
					mappings = {
						["\\"] = "close_window",
					},
				},
			},
		},
		keys = {
			{ "<leader>e", "<cmd>Neotree float reveal<CR>", desc = "Show file exlorer" },
			{ "<leader>ge", "<cmd>Neotree float git_status<CR>", desc = "Git status explorer" },
		},
	},
}
