return {
  {
    "sainnhe/everforest",
    priority = 1000,
    config = function()
      vim.cmd([[let g:everforest_background = 'hard']])
      vim.cmd([[let g:everforest_better_performance = 1]])
      vim.cmd([[colorscheme everforest]])
    end,
  },
}
