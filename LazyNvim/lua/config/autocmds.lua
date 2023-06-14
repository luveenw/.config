-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- neovim-session-manager save session every time a buffer is written
local config_group = vim.api.nvim_create_augroup("MyConfigGroup", {})
local session_manager = require("session_manager")

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  group = config_group,
  callback = function()
    if vim.bo.filetype ~= "git" and not vim.bo.filetype ~= "gitcommit" and not vim.bo.filetype ~= "gitrebase" then
      session_manager.autosave_session()
    end
  end,
})
