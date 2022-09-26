" load linux and mac overrides
highlight Comment ctermfg=126
syntax enable

set guicursor=
set showcmd
set scrolloff=8
set number
set relativenumber
set softtabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent
set clipboard=unnamed
set undolevels=1000

" Remaps
let mapleader = " "
nnoremap <leader>pv :Vex<CR>
nnoremap <leader>ph :Seh<CR>
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>
inoremap jk <esc>
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>pf :Files<CR>
nmap <C-S-Up> :m -2<CR>
nmap <C-S-Down> :m +1<CR>

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'rust-lang/rust.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
Plug '907th/vim-auto-save'
Plug 'preservim/nerdtree'
Plug 'leafgarland/typescript-vim'

Plug 'pangloss/vim-javascript'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }

" Rust LSM Configs
Plug 'neoclide/coc.nvim', { 'branch': 'release'  }
Plug 'arzg/vim-rust-syntax-ext'
call plug#end()

"colorscheme ayu
"let ayucolor="dark" 
let g:coc_global_extensions = ['coc-tsserver']

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-\> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let NERDTreeShowHidden=1
let g:rustfmt_autosave = 1
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

filetype plugin indent on
"let g:auto_save_events = ["InsertLeave", "TextChanged", "CompleteDone"]
"let g:auto_save = 1
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0

set rtp+=~/.vim/plugged/fzf.vim

autocmd vimenter * ++nested colorscheme gruvbox
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
