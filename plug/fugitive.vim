" Fugitive plug-in {
    " git helpers
    Plug 'tpope/vim-fugitive'
    " Plug 'airblade/vim-gitgutter'
    " Extradite for fugitive
    " Plug 'grota/vim-extradite'

    " toggles the Fugitive status window.
    function! s:GS_toggle()
        for i in range(1, winnr('$'))
            let bnum = winbufnr(i)
            if getbufvar(bnum, '&filetype') == 'gitcommit'
                execute "bdelete".bnum
                execute "normal \<C-W>="
                return
            endif
        endfor
        execute "Gstatus"
        execute "normal \<C-W>K"
    endfunction

    nnoremap <Leader>gb :Gblame -w<cr>
    nnoremap <Leader>gc :Gcommit<cr>
    nnoremap <Leader>gd :Gdiff<cr>
    nnoremap <Leader>gs :Gstatus<cr>
    " nnoremap <Leader>gp :Git push<cr>
    " nnoremap <Leader>gr :Gremove<cr>
    " nnoremap <Leader>gw :Gwrite<cr>

    command! GSToggle call s:GS_toggle()
    nmap <F9> :GSToggle<CR>
    autocmd filetype gitcommit setlocal spell spelllang=en_us
    " autocmd filetype gitcommit noremap <buffer> <ESC> <C-W>c
" }
