" Tagbar plug-in {
    " better than taglist
    Plug 'majutsushi/tagbar'

	if (!empty(glob('/usr/local/opt/universal-ctags/bin/ctags')))
	    " brew install universal-ctags
	    " brew install --HEAD universal-ctags/universal-ctags/universal-ctags
	    let g:tagbar_ctags_bin = "/usr/local/opt/universal-ctags/bin/ctags"
	elseif has("win32") || has("win64")
        let g:tagbar_ctags_bin = '~/vimfiles/ctags.exe'
    endif

    let g:tagbar_type_cpp = {
        \ 'kinds' : [
            \ 'd:macros:1:0',
            \ 'g:enums:1:0',
            \ 'e:enumerators:1:0',
            \ 't:typedefs:1:0',
            \ 's:structs:1:0',
            \ 'u:unions:1:0',
            \ 'v:variables:1:0',
            \ 'm:members:0:0',
            \ 'p:prototypes',
            \ 'f:functions',
            \ 'n:namespaces',
            \ 'c:classes',
        \ ],
    \ }

    let g:tagbar_type_c = {
        \ 'kinds' : [
            \ 'd:macros:1:0',
            \ 'g:enums:1:0',
            \ 'e:enumerators:1:0',
            \ 't:typedefs:1:0',
            \ 's:structs:1:0',
            \ 'u:unions:1:0',
            \ 'v:variables:1:0',
            \ 'm:members:0:0',
            \ 'p:prototypes',
            \ 'f:functions',
        \ ],
    \ }

    " Sort by file order
    let g:tagbar_sort = 0
    nmap <F3> :TagbarToggle<CR>
    imap <F3> <C-O>:TagbarToggle<CR>
    omap <F3> <C-C>:TagbarToggle<CR>
" }
