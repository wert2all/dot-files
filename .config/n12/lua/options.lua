vim.opt.termguicolors = true
-- from kickstart.nvim
-- line numbers
vim.opt.number = true
-- relative line numbers
vim.o.relativenumber = true
-- Enable mouse mode
vim.o.mouse = 'a'
-- Don't show the mode, since it's already in the status line
vim.o.showmode = false
-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 1000

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- from https://github.com/adibhanna/nvim/blob/main/lua/config/options.lua

vim.g.loaded_netrw = 1                                  -- disable netrw
vim.g.loaded_netrwPlugin = 1                            -- disable netrw

vim.opt.incsearch = true                                -- make search act like search in modern browsers
vim.opt.backup = false                                  -- creates a backup file
vim.opt.cmdheight = 0                                   -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menu", "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0                                -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                          -- the encoding written to a file
vim.opt.hlsearch = true                                 -- highlight all matches on previous search pattern
vim.opt.pumheight = 10                                  -- pop up menu height
vim.opt.showtabline = 2                                 -- always show tabs
vim.opt.smartindent = true                              -- make indenting smarter again
vim.opt.swapfile = false                                -- creates a swapfile
vim.opt.expandtab = true                                -- convert tabs to spaces
vim.opt.shiftwidth = 2                                  -- the number of spaces inserted for each indentation
vim.opt.breakindent = true                              -- wrap lines with indent
vim.opt.signcolumn = "yes:1"                            --  show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                                    -- display lines as one long line
vim.opt.showcmd = false                                 -- Don't show the command in the last line
vim.opt.ruler = true                                    -- Don't show the ruler
vim.opt.autoread = true                                 -- automatically read the file when changed outside of vim

vim.opt.foldlevel = 99                                  -- sets a number that automatically closes any fold
vim.opt.foldlevelstart = 99                             -- sets the initial value of vim.opt.foldlevel

vim.opt.winborder = "none"                              -- https://neovim.io/doc/user/options.html#'winborder'
