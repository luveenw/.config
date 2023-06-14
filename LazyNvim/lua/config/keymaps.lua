-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "Go to right window", remap = true })
vim.keymap.set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "Go to down window", remap = true })
vim.keymap.set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "Go to up window", remap = true })

-- telescope.nvim
vim.keymap.set(
  "n",
  "<leader>sx",
  require("telescope.builtin").resume,
  { desc = "Resume last Telescope search", noremap = true, silent = true }
)

-- trouble.nvim
vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })

-- easier command mode
vim.keymap.set("n", ";", ":", { noremap = true })

-- spectre.nvim
vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").open()<CR>', {
  desc = "Open Spectre",
})
vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
  desc = "Search current word",
})
vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = "Search current word",
})
vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
  desc = "Search on current file",
})

-- move line(s) up/down
vim.keymap.set("n", "<C-A-Up>", "<cmd>m .-2<CR>==", { noremap = true })
vim.keymap.set("n", "<C-A-Down>", "<cmd>m .+1<CR>==", { noremap = true })
vim.keymap.set("i", "<C-A-Up>", "<Esc><cmd>m .-2<CR>==gi", { noremap = true })
vim.keymap.set("i", "<C-A-Down>", "<Esc><cmd>m .+1<CR>==gi", { noremap = true })
vim.keymap.set("v", "<C-A-Up>", "<cmd>m '<-2<CR>gv=gv", { noremap = true })
vim.keymap.set("v", "<C-A-Down>", "<cmd>m '>+1<CR>gv=gv", { noremap = true })
