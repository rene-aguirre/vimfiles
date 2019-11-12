" Clang_complete {
if has("macunix")
    let g:clang_use_library = 1
    let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
    if (empty(glob(g:clang_library_path)))
        let g:clang_library_path='/Applications/Xcode.app/Contents/Frameworks/libclang.dylib'
    endif
    let g:clang_user_options = '-std=c++17'
    let g:clang_complete_auto = 1
    if g:ultisnips_enabled && !g:tab_manager_enabled
        let g:clang_snippets = 1
        let g:clang_snippets_engine = 'ultisnips'
    endif
	Plug 'xavierd/clang_complete', { 'for': ['c', 'cpp', 'objc', 'objcpp'] }
endif
" }
"
