
" use ripgrep as default 'grep' if available
if executable("/usr/local/bin/rg")
    let s:rg_path="/usr/local/bin/rg""
else
    let s:rg_path="rg"
endif

function! GetRgRepoGrep()
    " For meta repositories using repo tool
    if (empty(glob('../.repo/')))
        " restore if not in repo
        let &grepprg=s:rg_grepprg
    else
        set grepprg=repo\ forall\ -c\ 'echo\ ../$REPO_PATH'\ \\\|\ xargs\ rg\ --vimgrep\ --no-heading\ --no-messages
    endif
    return "grep! "
endfunction

function! GetFtExtension(sFt, sFile, bIsUnix)
" sFt, given filetype
" sFile, reference filename

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
    'objc':     ['c', 'h', 'm'],
    'objcpp':   ['c', 'cpp', 'asm', 'h', 'hpp', 'mm', 'm'],
}

default_ext = os.path.splitext(vim.eval("a:sFile"))[1].strip()

if default_ext and default_ext.startswith('.'):
    default_ext = default_ext[1:]

all_ext = ft_map.get(vim.eval("a:sFt"), [default_ext,])

if default_ext and default_ext not in all_ext:
    # desirable to include current file ext too
    all_ext.insert(0, default_ext)

if default_ext:
    if vim.eval("a:bIsUnix") == '1':
        if len(all_ext) == 1:
            result_str = "'*." + all_ext[0].strip() + "'"
        else:
            result_str = "'*.{" + ",".join([the_file.strip() for the_file in all_ext]) + "}'"
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
    'c' :       '-t c -t cpp -t h -t objc -t objcpp',
    'cpp':      '-t c -t cpp -t h -t objc -t objcpp',
    'objc':     '-t c -t cpp -t h -t objc -t objcpp',
    'objcpp':   '-t c -t cpp -t h -t objc -t objcpp',
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

" find in git repo with fugitive
noremap <leader>gg :silent Ggrep! -n <c-r>=expand("<cword>") .
    \ " -- " . GetFtExtension(&filetype, bufname('%'), '', has("unix"))<CR>

" ff: find in filetype grep helper
if executable(s:rg_path)
    " as default grep
    let s:rg_grepprg=s:rg_path . " --vimgrep --no-heading --no-messages "
    let s:rg_grepformat="%f:%l:%c:%m,%f:%l:%m"

    noremap <leader>ff :silent  <c-r>=GetRgRepoGrep() .
        \ GetRgExt(&filetype, bufname('%')) . " " . expand("<cword>") <CR>
elseif has("unix")
    noremap <leader>ff :silent grep! -s -r --include
        \ =<c-r>=GetFtExtension(&filetype, bufname('%'), '', has('unix')) .
        \ " " . expand("<cword>") . " ."<CR>
else
    noremap <leader>ff :silent grep! /r /s /p <c-r>=expand("<cword>") .
        \ " " . GetFtExtension(&filetype, bufname('%'), '', has("unix"))<CR>
endif
