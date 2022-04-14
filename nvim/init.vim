" bwb's init.vim
"
" CHANGELOG
"
" 2020-3-18
"   * Migrate to neovim 0.5 from .vimrc config
"   * Setup gruvbox instead of solarized
"   * LSP support for rust-analyzer

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set termguicolors
set encoding=utf8

" plugins
call plug#begin(stdpath('data') . '/plugged')
" LSP for Rust
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'
" Completion framework used by LSP
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'

Plug 'morhetz/gruvbox'
Plug 'rust-lang/rust.vim'
Plug 'luochen1990/rainbow'
call plug#end()

let g:rainbow_active = 1
let g:gruvbox_contrast_dark = 'hard'

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
" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- -- enable clippy on save
                -- checkOnSave = {
                --     command = "clippy"
                -- },
            }
        }
    },
}

require('rust-tools').setup(opts)
EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF





























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

" syntax highlighting for wisp
autocmd BufNewFile,BufRead *.wisp set syntax=clojure
autocmd BufNewFile,BufRead *.wisp set filetype=clojure

" autocomplete
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
autocmd Filetype rust setlocal omnifunc=v:lua.vim.lsp.omnifunc

" lsp key mappings
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>

" because makefiles
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
