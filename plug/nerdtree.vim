" NERDTree file browser plug-ing {
    Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle' }
    nmap <F2> :NERDTreeToggle<CR>
    imap <F2> <C-O>:NERDTreeToggle<CR>
    omap <F2> <C-C>:NERDTreeToggle<CR>
    nmap <leader>r :NERDTreeFind<cr>

    let g:NERDTreeLimitedSyntax = 1
    " let g:NERDTreeHighlightCursorline = 0
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" }
"
