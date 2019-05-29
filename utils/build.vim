" cmake/makefiles build project helper
function! s:s_build(...)
	execute ":wall"
	try
	    let makeprg_bak = &g:makeprg
        if (! empty(glob('./build.sh~'))) " local build helper
            execute ':set makeprg=source\ ./build.sh~'
        elseif (! empty(glob('./CMakeLists.txt')))
            if (empty(glob('./build')))
                execute "!mkdir ./build"
            endif
            if (empty(glob('./build/Makefile')))
                execute "!cd ./build && cmake .. && cd .."
            endif
            execute ':set makeprg=make\ -C\ ./build'
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

function! s:s_test()
    if (! empty(glob('./CMakeLists.txt'))) && (! empty(glob('./build/Makefile')))
        execute "make test ARGS=--output-on-failure -C ./build"
    else
        execute "make test " . join(a:000, ' ')
    endif
endfunction
command! -nargs=* Test call s:s_test()

