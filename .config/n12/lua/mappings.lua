vim.g.mapleader = " " -- space for leader
vim.g.maplocalleader = " " -- space for localleader

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzv")
vim.keymap.set("n", "N", "Nzzv")

vim.keymap.set("n", "<C-q>", ":q<CR>")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("v", "p", '"_dp', { desc="Paste without yanking" })
vim.keymap.set("v", "P", '"_dP', { desc="Paste without yanking" })

-- better movement in wrapped text
vim.keymap.set("n", "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc="Move to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc="Move to below split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc="Move to above split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc="Move to right split" })

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })

vim.keymap.set("n", "<C-Up>",    "<Cmd>resize -2<CR>",          { desc="Resize split up" })
vim.keymap.set("n", "<C-Down>",  "<Cmd>resize +2<CR>",          { desc="Resize split down" })
vim.keymap.set("n", "<C-Left>",  "<Cmd>vertical resize -2<CR>", { desc="Resize split left" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize -2<CR>", { desc="Resize split right" })

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

vim.keymap.set("n", "<leader>pap", function()
  local path = vim.fn.expand "%:p"
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, { desc="Copy absolute file path"})

vim.keymap.set("n", "<leader>prp", function()
  local path = vim.fn.fnamemodify(vim.fn.expand "%", ":.")
  vim.fn.setreg("+", path)
  vim.notify('Copied "' .. path .. '" to the clipboard!')
end, { desc="Copy relative file path"})


vim.keymap.set("n", "<leader>rr", "<cmd>restart<cr>", { desc="Restart Neovim"})


-- vim.keymap.set('n', '<leader>uw', function() 
--   vim.opt.wrap = not vim.opt.wrap:get() 
--   print('wrap: ' .. tostring(vim.opt.wrap:get()))
-- end, { desc = 'Toggle wrap' })
