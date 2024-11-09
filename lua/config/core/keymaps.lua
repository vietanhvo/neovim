-- set leader key to space
local g = vim.g
g.mapleader = " "

local keymap = vim.keymap

-- window management
keymap.set("n", "<Leader>v", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>s", "<C-w>s", { desc = "Split window horizontally" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

keymap.set("n", "<M-h>", "<C-W>h", { desc = "Navigate to left window" })
keymap.set("n", "<M-l>", "<C-W>l", { desc = "Navigate to right window" })
keymap.set("n", "<M-j>", "<C-W>j", { desc = "Navigate to down window" })
keymap.set("n", "<M-k>", "<C-W>k", { desc = "Navigate to up window" })

keymap.set("n", "<Right>", "<cmd>vertical resize +3<CR>", { desc = "Resize window to right" })
keymap.set("n", "<Left>", "<cmd>vertical resize -3<CR>", { desc = "Resize window to left" })
keymap.set("n", "<Up>", "<cmd>resize +3<CR>", { desc = "Resize window to up" })
keymap.set("n", "<Down>", "<cmd>resize -3<CR>", { desc = "Resize window to down" })

-- line management
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
keymap.set("v", "K", ":m '>-2<CR>gv=gv", { desc = "Move line up" })
