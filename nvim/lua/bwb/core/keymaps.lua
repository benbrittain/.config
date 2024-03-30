vim.g.mapleader = " "

local keymap = vim.keymap

-- clear search highlights
keymap.set("n", "<CR>", ":nohlsearch<CR><CR>", { desc = "Clear search highlights" })

-- increment/decrement
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })
