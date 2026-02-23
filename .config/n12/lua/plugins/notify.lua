vim.cmd("packadd fidget.nvim")
vim.cmd("packadd nvim-notify")

require("fidget").setup({
	progress = {
		display = {
			render_limit = 16,
			done_ttl = 3,
		},
	},
})
require("notify").setup({
	render = "compact",
	stages = "fade",
	-- on_open = function(win)
	--          vim.api.nvim_win_set_config(win, { border = "none" })
	-- end,
})

vim.notify = require("notify")
