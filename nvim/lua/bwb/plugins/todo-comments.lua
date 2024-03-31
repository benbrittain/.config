return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local todo= require('todo-comments')
    todo.setup({
        colors = {
        error = { "DiagnosticError", "ErrorMsg", "#E67E80" },
        warning = { "DiagnosticWarn", "WarningMsg", "#E69975" },
        info = { "DiagnosticInfo", "#DBBC75" },
        hint = { "DiagnosticHint", "#7FBBB3" },
        default = { "Identifier", "#A7C080" },
        test = { "Identifier", "#D699B6" }
      },
      search = {
        command = "rg",
        args = {
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--no-require-git",
        },
        pattern = [[\b(KEYWORDS):]], -- ripgrep regex
      },
    })
  end,
}
