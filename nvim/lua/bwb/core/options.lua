local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- search settings
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- cursor line
opt.cursorline = true

-- disable cursor
opt.mouse = ''

-- appearance

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "no"

-- backspace
opt.backspace = "indent,eol,start"

-- use system clipboard as default register
opt.clipboard:append("unnamedplus")

-- turn off swapfile
opt.swapfile = false

-- Enable spell check
opt.spelllang = 'en_us'
opt.spell = true
