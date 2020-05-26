" NERDTree file browser plug-ing {
    Plug 'scrooloose/nerdtree', {'on': ['NERDTreeFind', 'NERDTreeToggleVCS'] }
    nmap <F2> :NERDTreeToggleVCS<CR>
    imap <F2> <C-O>:NERDTreeToggleVCS<CR>
    omap <F2> <C-C>:NERDTreeToggleVCS<CR>
    nmap <leader>r :NERDTreeFind<CR>

    let g:NERDTreeLimitedSyntax = 1
    " let g:NERDTreeHighlightCursorline = 0
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" }
"
