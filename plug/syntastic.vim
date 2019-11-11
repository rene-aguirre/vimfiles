" Syntastic plug-in {
    " pylint slows down on write, I run it manually with :make
    let g:syntastic_mode_map = {
        \ "mode": "active",
        \ "passive_filetypes": ["python"]
        \ }
    " default all are active_filetypes
    if executable('clang++')
        let g:syntastic_cpp_compiler = 'clang++'
        let g:syntastic_cpp_compiler_options = ' -std=c++17 -Wall -Wextra -Wno-c++98-compat'
    else
        let g:syntastic_cpp_compiler = 'g++'
        let g:syntastic_cpp_compiler_options = ' -std=c++17 -Wall -Wextra'
    endif
    " let g:syntastic_cpp_compiler_options = ' -std=c++1z -stdlib=libc++ -Wall -Wextra'
    " -stdlib=libc++ not supported on gcc (implicit?)
    " Use compilation databases (generate with Cmake of Build EAR)
    let g:syntastic_cpp_clang_tidy_post_args = ""
    let g:syntastic_c_clang_tidy_post_args = ""
" }

Plug 'scrooloose/syntastic'

