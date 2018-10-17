if executable("rg")
    " use ripgrep when available
    set grepprg=rg\ --vimgrep\ --no-heading\ --no-messages
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

function! GetRepoGrep()
    if (empty(glob('../.repo/')))
        set grepprg=rg\ --vimgrep\ --no-heading\ --no-messages
    else
        set grepprg=repo\ forall\ -c\ 'echo\ ../$REPO_PATH'\ \\\|\ xargs\ rg\ --vimgrep\ --no-heading\ --no-messages
    endif
    return "grep! "
endfunction

" This opens the results of 'grep -r' in a bottom window
" and uses 'git grep' when in a git repo and regular grep otherwise.
" :G <word> runs grep
" :Gi <word> runs grep as case-insensitive
function! Grep(args, ignorecase)
    let grepprg_bak=&grepprg
    let g:gitroot=system('git rev-parse --show-cdup')
    if v:shell_error
        if a:ignorecase
            let s:mygrepprg="findstr\\ /n\\ /r\\ /s\\ /i\\ /p"
        else
            let s:mygrepprg="findstr\\ /n\\ /r\\ /s\\ /p"
        endif
        let s:grepcmd="silent! grep " . a:args . " " . GetFtExtension(&filetype, bufname('%'), '', has("unix"))

    else
        if a:ignorecase
            let s:mygrepprg="git\\ grep\\ -ni"
        else
            let s:mygrepprg="git\\ grep\\ -n"
        endif
        let s:grepcmd="silent! grep " . a:args . " -- " . GetFtExtension(&filetype, bufname('%'), g:gitroot, has("unix"))
    endif
    exec "set grepprg=" . s:mygrepprg
    execute s:grepcmd
    if version < 700
        botright copen
    endif
    let &grepprg=grepprg_bak
    exec "redraw!"
endfunction

function! GetFtExtension(sFt, sFile, sRootPrefix, bIsUnix)
" sFt, given filetype
" sFile, reference filename
" sRootPrefix, top level path

if a:sFile == ''
    return
endif

python << endpython
import vim
import os.path
ft_map = {
    'c' :       ['c', 'h'],
    'asm':      ['asm', 'h'],
    'kalimba':  ['asm', 'h'],
    'cpp':      ['c', 'cpp', 'asm', 'h', 'hpp'],
}

default_ext = os.path.splitext(vim.eval("a:sFile"))[1].strip()

if default_ext and default_ext.startswith('.'):
    default_ext = default_ext[1:]

all_ext = ft_map.get(vim.eval("a:sFt"), [default_ext,])

if default_ext and default_ext not in all_ext:
# desirable to include current file ext
    all_ext.insert(0, default_ext)

if vim.eval("a:sRootPrefix").strip():
    if default_ext:
        if vim.eval("a:bIsUnix") == '1':
            if len(all_ext) == 1:
                result_str = os.path.join(vim.eval("a:sRootPrefix").strip(), "*." + all_ext[0].strip())
            else:
                result_str = os.path.join(vim.eval("a:sRootPrefix").strip(), "*.{" + ",".join([the_file.strip() for the_file in all_ext]) + "}")
        else:
            result_str = " ".join([os.path.join(vim.eval("a:sRootPrefix").strip(), '*.'+the_file.strip()) for the_file in all_ext])
    else:
        result_str = os.path.split( vim.eval("a:sFile") )[1]
elif default_ext:
    if vim.eval("a:bIsUnix") == '1':
        if len(all_ext) == 1:
            result_str = "*." + all_ext[0].strip()
        else:
            result_str = "*.{" + ",".join([the_file.strip() for the_file in all_ext]) + "}"
    else:
        result_str = " ".join(['*.' + the_file.strip() for the_file in all_ext])
else:
    result_str = os.path.split( vim.eval("a:sFile") )[1]

vim.command('return "{0}"'.format(result_str))

endpython
endfunction

function! GetRgExt(sFt, sFile)
" sFt, given filetype
" sFile, reference filename

if a:sFile == ''
    return
endif

python << endpython
import vim
import os.path
ft_map = {
    'asm':      '-t asm',
    'c' :       '-t c -t cpp -t h',
    'cpp':      '-t cpp -t c -t h',
    'kalimba':  '-t asm',
    'make':     '-t make',
    'python':   '-t py --type-add py:*.pycfg',
    'rust':     '-t rust',
    'vim':      '-t vimscript',
}

rgtype = ft_map.get(vim.eval("a:sFt"), '')
vim.command('return "{0}"'.format(rgtype))

endpython
endfunction

command! -complete=tag -nargs=1 G call Grep('<args>', 0)
command! -complete=tag -nargs=1 Gi call Grep('<args>', 1)

" find in git repo with fugitive
noremap <leader>gg :silent Ggrep! -n <c-r>=expand("<cword>") .
    \ " -- " . GetFtExtension(&filetype, bufname('%'), '', has("unix"))<CR>
if executable("rg")
    noremap <leader>ff :silent  <c-r>=GetRepoGrep() .
        \ GetRgExt(&filetype, bufname('%')) . " " . expand("<cword>") <CR>
elseif has("unix")
    noremap <leader>ff :silent grep! -s -r --include
        \ =<c-r>=GetFtExtension(&filetype, bufname('%'), '', has('unix')) .
        \ " " . expand("<cword>") . " ."<CR>
else
    noremap <leader>ff :silent grep! /r /s /p <c-r>=expand("<cword>") .
        \ " " . GetFtExtension(&filetype, bufname('%'), '', has("unix"))<CR>
endif
