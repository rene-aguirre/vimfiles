" Startify plug-in {
    Plug 'mhinz/vim-startify'
    let s:padding_left = repeat(' ', 3)
    let g:startify_list_order = [
        \ [s:padding_left .'MRU '. getcwd()], 'dir',
        \ [s:padding_left .'MRU'],            'files',
        \ [s:padding_left .'Sessions'],       'sessions',
        \ [s:padding_left .'Bookmarks'],      'bookmarks',
        \ [s:padding_left .'Commands'],       'commands',
        \ ]

    let g:ascii = [
            \ '        __',
            \ '.--.--.|==|.--------.',
            \ '|  |  ||  ||  .  .  |',
            \ ' \___/ |__|.__|__|__.',
            \]

    " always keep my current dir
    let g:startify_change_to_dir = 0
"
