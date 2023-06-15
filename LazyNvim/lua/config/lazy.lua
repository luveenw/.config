local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- import any extras modules here
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require("catppuccin").setup({
  flavour = "frappe",
})

-- neovim-session-manager toggle to show neo-tree explorer pane after loading a session
-- local config_group = vim.api.nvim_create_augroup("MyConfigGroup", {}) -- A global group for all your config autocommands

-- vim.api.nvim_create_autocmd({ "User" }, {
--   pattern = "SessionLoadPost",
--   group = config_group,
--   callback = function()
--     vim.cmd([[NeoTreeShow]])
--   end,
-- })
--
-- bookmarks default setup
require("bookmarks").setup({
  sign_priority = 8, --set bookmark sign priority to cover other sign
  save_file = vim.fn.expand("$HOME/.bookmarks"), -- bookmarks save file path
  keywords = {
    ["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
    ["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
    ["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
    ["@n"] = "📗", -- mark annotation startswith @n ,signs this icon as `Note`
  },
  on_attach = function()
    local bm = require("bookmarks")
    local map = vim.keymap.set
    map("n", "mm", bm.bookmark_toggle, { desc = "Toggle bookmark" }) -- add or remove bookmark at current line
    map("n", "mi", bm.bookmark_ann, { desc = "Edit bookmark annotation" }) -- add or edit mark annotation at current line
    map("n", "mc", bm.bookmark_clean, { desc = "Clear all bookmarks in current buffer" }) -- clean all marks in local buffer
    map("n", "mn", bm.bookmark_next, { desc = "Go to next bookmark in buffer" }) -- jump to next mark in local buffer
    map("n", "mp", bm.bookmark_prev, { desc = "Go to previous bookmark in buffer" }) -- jump to previous mark in local buffer
    -- map("n", "ml", bm.bookmark_list) -- show marked file list in quickfix window
  end,
})

-- enable git blamer on startup
vim.g.blamer_enabled = 1
