" ctrlp.vim plug-in {
    " fuzy file browser
    Plug 'ctrlpvim/ctrlp.vim'
    let s:cpsm_enabled = 1
    let s:pymatcher_enabled = 0

    " CtrlP browse buffers
    nmap <leader>be :CtrlPBuffer<CR>

    " work on tags
    let g:ctrlp_extensions = ['tag']

    " open files extra files in hidden buffers
    let g:ctrlp_open_multiple_files = '1jr'

    " special wildignore
    let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

    " use ctrlp-cmatcher extension
    " let g:ctrlp_match_func = {'match' : 'matcher#cmatch'}
if s:cpsm_enabled
    function! BuildCPSM(info)
        " info is a dictionary with 3 fields
        " - name:   name of the plugin
        " - status: 'installed', 'updated', or 'unchanged'
        " - force:  set on PlugInstall! or PlugUpdate!
        if a:info.status == 'installed' || a:info.force
            !PY3=ON ./install.sh
        endif
    endfunction

    " cpsm, ctrlp matcher for paths
    Plug 'nixprime/cpsm', { 'do': function('BuildCPSM') }

    let g:ctrlp_match_func = {'match' : 'cpsm#CtrlPMatch'}
elseif s:pymatcher_enabled
    " use ctrlp-cmatcher extension, ctrlp-py-matcher
    let g:ctrlp_match_func = {'match' : 'pymatcher#PyMatch'}
endif

    " keep current dir, avoid messin with submodules
    let g:ctrlp_working_path_mode = 'wa'

    " limit max number of files
    let g:ctrlp_max_files = 100000

    " indexing speed up
    let s:ctrlp_git_command = 'cd %s && python ~/vimfiles/gitsub.py --rg'
    if executable('rg')
        " let s:ctrlp_git_command = 'rg --color=never --no-messages --glob "" --files %s'
        let s:ctrlp_git_command = s:ctrlp_git_command . '--rg'
        let g:ctrlp_use_caching = 0
    endif
    if has("unix")
        let g:ctrlp_user_command = {
            \ 'types': {
                \ 1: ['.git', s:ctrlp_git_command],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ 3: ['.svn', 'svn status %s -q -v | sed ' . "'" . 's/^.\\{28\}\\s*\\(.*\\s\\)//'],
                \ },
            \ 'fallback': 'find %s -not -path "*/\.*" -type f \( ! -iname ".*" \)| head -50000'
            \ }
    else
        " windows
        let ctrlp_filter_greps = "".
            \ 'grep -iv "\\.\\(' .
            \ 'exe\|jar\|class\|swp\|swo\|log\|so\|o\|pyc\|jpe?g\|png\|gif\|mo\|po' .
            \ 'o\|a\|obj\|com\|dll\|exe\|tmp\|docx\|pdf\|jpg\|png\|vsd\|zip' .
            \ '\\)$"'
        " vim currently broken
        if executable('rg')
            let g:ctrlp_fast_search = 'rg --color=never --no-messages --glob "" --files %s'
        elseif executable('ag')
            let g:ctrlp_fast_search = 'ag %s -l --nocolor -g ""'
        else
            let g:ctrlp_fast_search = 'dir %s /-n /b /s /a-d'
        endif
        let g:ctrlp_user_command = {
            \ 'types': {
                \ 1: ['.git', 'cd %s && python %%userprofile%%\\vimfiles\\gitsub.py'],
                \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ 3: ['.svn', 'svn status %s -q -v | sed ' . "'" . 's/^.\\{28\}\\s*\\(.*\\s\\)//'],
                \ },
            \ 'fallback': g:ctrlp_fast_search,
            \ }
    endif
" }
