" cmake/makefiles build project helper
function! s:s_build(...)
	execute ":wall"
	try
	    let makeprg_bak = &g:makeprg
        if (! empty(glob('./build.sh~'))) " local build helper
            execute ':set makeprg=source\ ./build.sh~'
        elseif (! empty(glob('./CMakeLists.txt')))
            execute ':set makeprg=' . g:CFG_PATH . '/makeprg.sh'
        else
            " use default makeprg
        endif
        execute 'echo "using ' . &g:makeprg . '"'
        " [!] doesn't jump to first error
        execute "make! " . join(a:000, ' ')
    finally
        let &g:makeprg = makeprg_bak
    endtry
endfunction
command! -nargs=* Build call s:s_build(<f-args>)

function! s:s_build_edit(...)
	execute ":wall"
    if (! empty(glob('./build.sh~')))
        execute ':edit ./build.sh~'
    elseif (! empty(glob('./CMakeLists.txt')))
        execute ':edit ./CMakeLists.txt'
    elseif (! empty(glob('./Makefile')))
        execute ':edit ./Makefile'
    else
        execute ':edit ./build.sh~'
    endif
endfunction
command! -nargs=* BuildEdit call s:s_build_edit(<f-args>)

function! s:s_test(...)
    call s:s_build()
    call call('s:s_build', ['test'] + a:000)
endfunction

command! -nargs=* Test call s:s_test(<f-args>)

