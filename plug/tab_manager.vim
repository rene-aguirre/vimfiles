"
" Tab ("\t") managers {
    let s:supertab_enabled   = 0
    let s:mucomplete_enabled = 0
    let s:clevertab_enabled  = 1

if s:mucomplete_enabled || s:clevertab_enabled || s:supertab_enabled
    " Neither Tab nor <C-J> / <C-K> 
    let g:UltiSnipsExpandTrigger="∆" " <Option-j>
else
    let g:UltiSnipsExpandTrigger = "<tab>"
endif
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

if s:supertab_enabled
" SuperTab plug-in {
    " use supertab to work sith YCM and UltiSnips
    Plug 'ervandew/supertab'
    " let g:SuperTabNoCompleteAfter =
    " let g:SuperTabDefaultCompletionType = 'context'
    let g:SuperTabContextDefaultCompletionType = '\t'
    " consolidate space-tab to bare tab (easy way to force tab too)
    let g:SuperTabMappingTabLiteral = '<C-T>'
" }
elseif s:mucomplete_enabled
" Mucomplete plug-in {
    Plug 'lifepillar/vim-mucomplete'
    set noshowmode shortmess+=c   " Shut off completion messages
    " set showmode shortmess-=c   " Shut off completion messages
    set noinfercase
    set completeopt-=preview
    set completeopt+=longest
    set completeopt+=menuone
    set completeopt+=noselect
    set completeopt+=noinsert
    set belloff+=ctrlg " If Vim beeps during completion

    " for auto completion
    inoremap <expr> <c-e> mucomplete#popup_exit("\<c-e>")
    inoremap <expr> <c-y> mucomplete#popup_exit("\<c-y>")
    inoremap <expr>  <cr> mucomplete#popup_exit("\<cr>")
    let g:mucomplete#enable_auto_at_startup = 1

    imap <expr> <right> <plug>(MUcompleteCycFwd)

    let g:mucomplete#chains = {
      \ 'default' : ['path', 'omni', 'keyn', 'dict', 'uspl', 'ulti'],
      \ 'vim'     : ['path', 'cmd', 'keyn', 'ulti']
      \ }
    autocmd filetype c,cpp MUcompleteAutoOn
" }
elseif s:clevertab_enabled
" Clevertab {
    " Forked 'neitanod/vim-clevertab'
    Plug 'rene-aguirre/vim-clevertab'
    let g:UltiSnipsRemoveSelectModeMappings = 1
    let g:UltiSnipsMappingsToIgnore = [ "CleverTab", ]

    function s:tabComplete(tagStr)
        return "<c-r>=CleverTab#Complete('" . a:tagStr . "')<cr>"
    endfunction

    function s:getTabMapSetupStr()
        let mapStr = 'inoremap <silent><tab> '
        let tagItems = [ 'start', 'tab',
            \ 'ultisnips', 'omni', 'keyword', 'file',
            \ 'nopumtab', 'next', 'stop' ]
        for seqTag in tagItems
            let mapStr = mapStr . s:tabComplete(seqTag)
        endfor
        return mapStr
    endfunction()

    let s:tabMapStr = s:getTabMapSetupStr()

    function s:tabSetup()
        execute s:tabMapStr
        execute "inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>"
    endfunction()

    autocmd InsertEnter * call s:tabSetup()

    function! GetAllSnippetsCmd()
        call UltiSnips#SnippetsInCurrentScope(1)
        let l:snipps = []
        for [key, info] in items(g:current_ulti_dict_info)
            call add(l:snipps, key)
        endfor
        return 'echo "' . join(l:snipps, "\n"). '"'
    endfunction

    function s:vexpand_snippet(snippet)
        call UltiSnips#SaveLastVisualSelection()
        " 'gv' selects previous visual
        " 's' substitute, it enter insert deletig selection
        call feedkeys("gvs" . a:snippet . "\<c-r>=UltiSnips#ExpandSnippet()\<cr>")
    endfunction()
    command! -nargs=1 VSnippet call s:vexpand_snippet(<f-args>)
    if executable(g:fuzzy_executable)
        xnoremap <tab> :call picker#String(GetAllSnippetsCmd(), 'VSnippet')<cr>
    else
        xnoremap <tab> :<c-u><c-r>="VSnippet "<cr>
    endif
" }
else
    Plug 'ajh17/VimCompletesMe'
endif

" Ctrl-P like mappings
inoremap <expr> <C-j> pumvisible() ?  "\<Down>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ?  "\<Up>"   : "\<C-k>"

" } Tab managers
