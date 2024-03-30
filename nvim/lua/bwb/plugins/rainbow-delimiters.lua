return {
  "HiPhish/rainbow-delimiters.nvim",
  dependencies = {},
  config = function()
    local rainbow_delimiters = require('rainbow-delimiters.setup')
    rainbow_delimiters.setup({
        strategy = {},
        query = {},
        highlight = {},
    })
  end,
}
