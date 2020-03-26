" bwb's init.vim
"
" CHANGELOG
"
" 2020-3-18
"   * Migrate to neovim 0.5 from .vimrc config
"   * Setup gruvbox instead of solarized
"   * LSP support for rust-analyzer

set termguicolors
set encoding=utf8

" plugins
call plug#begin(stdpath('data') . '/plugged')
Plug 'morhetz/gruvbox'
Plug 'rust-lang/rust.vim'
Plug 'neovim/nvim-lsp'
Plug 'tpope/vim-fugitive'
call plug#end()

" color scheme
colorscheme gruvbox
set background=dark
syntax on

" indents
filetype plugin indent on
set expandtab
set shiftwidth=2
set softtabstop=2

" highlight whitespace
" change #cc241dd to red if not using gruvbox
highlight ExtraWhitespace ctermbg=red guibg=#cc241d
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" search
set ignorecase
set smartcase
set incsearch

" search highlight, disable on enter
set hlsearch
nnoremap <CR> :nohlsearch<CR><CR>

" disable error bar on left
set signcolumn=no

" cursor positioning
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" lsp support
lua << EOF

local nvim_lsp = require'nvim_lsp'
local util = require 'nvim_lsp/util'

require'nvim_lsp'.rust_analyzer.setup({
  root_dir = util.root_pattern("rust-project.json", "Cargo.toml");
  log_level = vim.lsp.protocol.MessageType.Log;
  message_level = vim.lsp.protocol.MessageType.Log;
  settings = {
    rust_analyzer = {
      cargo_watch = {
        enable = false;
        AllTargets = false;
      }
    }
  };
})

-- TODO
-- require'nvim_lsp'.clangd.setup()

EOF

" autocomplete
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc

" lsp key mappings
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
