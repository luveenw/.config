return {
  "APZelos/blamer.nvim",
  config = function()
    vim.g.blamer_enabled = 1
    vim.g.blamer_delay = 300
    vim.g.blamer_date_format = "%y/%m/%d %I:%M %p"
  end,
}
