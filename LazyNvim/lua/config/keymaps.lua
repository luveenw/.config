-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set

map("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>", { desc = "Go to left window", remap = true })
map("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>", { desc = "Go to right window", remap = true })
map("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>", { desc = "Go to down window", remap = true })
map("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>", { desc = "Go to up window", remap = true })

-- telescope.nvim
map(
  "n",
  "<leader>sx",
  require("telescope.builtin").resume,
  { desc = "Resume last Telescope search", noremap = true, silent = true }
)

-- trouble.nvim
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true, noremap = true })
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true, noremap = true })
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
map("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })

-- easier command mode
map("n", ";", ":", { noremap = true })

-- spectre.nvim
map("n", "<leader>S", '<cmd>lua require("spectre").open()<CR>', {
  desc = "Open Spectre",
})
map("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
  desc = "Search current word",
})
map("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = "Search current word",
})
map("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
  desc = "Search on current file",
})

-- move line(s) up/down
map("n", "<C-A-Up>", "<cmd>m .-2<CR>==", { desc = "Move line up", noremap = true })
map("n", "<C-A-Down>", "<cmd>m .+1<CR>==", { desc = "Move line down", noremap = true })
map("i", "<C-A-Up>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Move line up", noremap = true })
map("i", "<C-A-Down>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Move line down", noremap = true })
map("v", "<C-A-Up>", "<cmd>m '<-2<CR>gv=gv", { desc = "Move line up", noremap = true })
map("v", "<C-A-Down>", "<cmd>m '>+1<CR>gv=gv", { desc = "Move line down", noremap = true })

-- shortcut keys to add, remove, and search bookmarks
-- local bm = require("bookmarks")
-- map("n", "<leader>ma", bm.bookmark_toggle, { desc = "Toggle bookmark", noremap = true })
-- map("n", "<leader>mn", , { desc = "Go to next bookmark", noremap = true })
-- map("n", "<leader>mp", "mp<CR>", { desc = "Go to previous bookmark", noremap = true })
-- map("i", "<leader>ma", "<Esc><cmd>mm<CR>i", { desc = "Add bookmark", noremap = true })
-- map("i", "<leader>mn", "<Esc><cmd>mn<CR>i", { desc = "Go to next bookmark", noremap = true })
-- map("i", "<leader>mp", "<Esc><cmd>mp<CR>i", { desc = "Go to previous bookmark", noremap = true })
map("n", "<leader>fB", "<cmd>Telescope bookmarks list<CR>", { desc = "Find bookmarks", noremap = true })
