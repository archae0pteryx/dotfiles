syntax enable
set rnu
set mouse=a
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set smarttab
set autoindent
set showmatch
set splitright
colorscheme habamax



let g:NetrwIsOpen=0
let g:netrw_winsize=20
function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction

" Add your own mapping. For example:
noremap <silent> <leader>e :call ToggleNetrw()<CR>
