call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() }}
Plug 'junegunn/fzf.vim'
Plug 'morhetz/gruvbox'
Plug 'jiangmiao/auto-pairs'

"Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
"Plug '907th/vim-auto-save'

" Rust
Plug 'neoclide/coc.nvim', { 'branch': 'release'  }
Plug 'arzg/vim-rust-syntax-ext'
Plug 'rust-lang/rust.vim'
Plug 'dense-analysis/ale'

" Javascript / TS
Plug 'pangloss/vim-javascript'
Plug 'peitalin/vim-jsx-typescript'
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'jparise/vim-graphql'
Plug 'leafgarland/typescript-vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }

call plug#end()
