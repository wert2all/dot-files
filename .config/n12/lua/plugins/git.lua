vim.cmd("packadd gitsigns.nvim")
require("gitsigns").setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signcolumn = true,
	current_line_blame = false,
})

vim.keymap.set("n", "]g", function()
	require("gitsigns").nav_hunk("next")
end, { desc = "Next git hunk" })
vim.keymap.set("n", "[g", function()
	require("gitsigns").nav_hunk("prev")
end, { desc = "Prev git hunk" })

vim.keymap.set("n", "]G", function()
	require("gitsigns").nav_hunk("last")
end, { desc = "Last Git hunk" })
vim.keymap.set("n", "[G", function()
	require("gitsigns").nav_hunk("first")
end, { desc = "First Git hunk" })

vim.keymap.set("n", "<leader>gp", function()
	require("gitsigns").preview_hunk()
end, { desc = "Preview git hunk" })
vim.keymap.set("n", "<leader>gr", function()
	require("gitsigns").reset_hunk()
end, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gR", function()
	require("gitsigns").reset_buffer()
end, { desc = "Reset git buffer" })
vim.keymap.set("v", "<leader>gr", function()
	require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>gl", function()
	require("fzf-lua").git_commits()
end, { desc = "Git log" })
vim.keymap.set("n", "<leader>gt", function()
	require("fzf-lua").git_status()
end, { desc = "Git status" })
vim.keymap.set("n", "<leader>gd", function()
	require("gitsigns").diffthis()
end, { desc = "Diff this" })
