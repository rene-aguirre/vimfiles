"
if has("virtualedit") && has("gui_running")
    " Pasting blockwise and linewise selections is not possible in Insert and
    " Visual mode without the +virtualedit feature.  They are pasted as if they
    " were characterwise instead.
    " Uses the paste.vim autoload script.
    exe 'inoremap <script> <S-Insert>' paste#paste_cmd['i']
    exe 'vnoremap <script> <S-Insert>' paste#paste_cmd['v']
endif

" Alt-Space is System menu
if has("gui_running")
  noremap <M-Space> :simalt ~<CR>
  inoremap <M-Space> <C-O>:simalt ~<CR>
endif

" gui options {
if has("gui_running")
    " set guioptions+=e   " tab bar displayed
    set guioptions-=m     " menu bar displayed
    set guioptions-=T     " disable toolbar
    " set showtabline=2
    set cursorline        " highlight current line
    set columns=99
    nmap <F10> :if &guioptions=~'m' \| set guioptions-=m \| else \| set guioptions+=m \| endif<cr>

    " set the cursor to a vertical line in insert mode and a solid block
    " in command mode
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
    inoremap <special> <Esc> <Esc>hl

    highlight Cursor guifg=black guibg=cyan
    highlight iCursor guifg=black guibg=red
    set guicursor=i:ver30-iCursor
    set guicursor=n-v-c:block-Cursor
    set guicursor+=n-v-c:blinkon0
endif

