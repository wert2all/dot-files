require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>") -- save
map({ "n", "i", "v" }, "<C-q>", "<cmd> q <cr>") -- close

map("n", "x", '"_x') -- delete single charasters without yanking

map("n", "<C-d>", "<C-d>zz") -- vertical scroll
map("n", "<C-u>", "<C-u>zz") --

map("n", "n", "nzzzv") -- find and center
map("n", "N", "Nzzzv") --

map("v", "<", "<gv") -- stay in visual mode
map("v", ">", ">gv")
