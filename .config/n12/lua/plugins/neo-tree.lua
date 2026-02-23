vim.cmd("packadd neo-tree.nvim")
require("neo-tree").setup({
	disable_netrw = true,
	enable_git_status = true,
	enable_diagnostics = true,
	sync_root_with_cwd = true,
	source_selector = { sources = { { source = "filesystem" } } },
	popup_border_style = "",
	filesystem = {
		filtered_items = {
			hide_dotfiles = false,
			hide_by_name = { ".git" },
			always_show = { ".env" },
			visible = true,
		},
	},
	follow_current_file = {
		enabled = true,
	},
	close_if_last_window = true,
})

vim.keymap.set({ "v", "n" }, "<leader>e", "<cmd>Neotree float reveal<cr>", { desc = "Toggle Explorer" })
