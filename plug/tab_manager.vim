"
" Tab ("\t") managers {
    let s:supertab_enabled   = 0
    let s:mucomplete_enabled = 0
    let s:clevertab_enabled  = 1

if s:mucomplete_enabled || s:clevertab_enabled || s:supertab_enabled
    " Keep <tab> for vim_mucomplete
    let g:UltiSnipsExpandTrigger="<C-J>"
    let g:UltiSnipsJumpForwardTrigger="<C-J>"
    let g:UltiSnipsJumpBackwardTrigger="<C-K>"
else
    " let g:UltiSnipsListSnippets = "<c-tab>"
    let g:UltiSnipsExpandTrigger = "<tab>"
    let g:UltiSnipsJumpForwardTrigger = "<tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
endif

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
    inoremap <silent><tab> <c-r>=CleverTab#Complete('start')<cr>
                        \<c-r>=CleverTab#Complete('tab')<cr>
                        \<c-r>=CleverTab#Complete('ultisnips')<cr>
                        \<c-r>=CleverTab#Complete('keyword')<cr>
                        \<c-r>=CleverTab#Complete('omni')<cr>
                        \<c-r>=CleverTab#Complete('stop')<cr>
    inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>
" }
else
    Plug 'ajh17/VimCompletesMe'
endif
" } Tab managers
