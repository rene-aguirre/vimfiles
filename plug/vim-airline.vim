" airline plugin
"
Plug 'vim-airline/vim-airline'
let g:airline#extensions#whitespace#enabled = 0
" fugitive
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#empty_message = ''
" only branch name tail
let g:airline#extensions#branch#format = 1
let g:airline#extensions#branch#displayed_head_limit = 16
" don't show empty changes items
let g:airline#extensions#hunks#non_zero_only = 1
" disable syntastic integration
let g:airline#extensions#syntastic#enabled = 0

let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_right_alt_sep = ''

" remove percentage
" let g:airline_section_x = (filetype, virtualenv)

function! MyFF()
    return printf('%s%s', &fenc, strlen(&ff) > 0 ? '['.&ff[0].']' : '')
endfunction
call airline#parts#define_function('myff', 'MyFF')
let g:airline_section_y = airline#section#create_right(['myff'])
" let g:airline_section_z = airline#section#create_right(['%2v', '%2p%%'])
let g:airline_section_z = airline#section#create_right(['%2v %2p%%'])

