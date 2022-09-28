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
"let g:auto_save_events = ["InsertLeave", "TextChanged", "CompleteDone"]
"let g:auto_save = 1

inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
filetype plugin indent on
