" My personal vimrc file.
" Rene F. Aguirre
"
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
filetype off
set encoding=utf-8
"

" Tab managers
let s:supertab_enabled = 0
let s:mucomplete_enabled = 0
let s:clevertab_enabled = 1

" Omni completion
let s:clang_complete = 1
let s:ycm_enabled = 0 " using clang_complete

" Snippets
let s:ultisnips_enabled = 1

" Other
let s:vimairline_enabled = 0 " or lightline

" Pluggin management {
"
" YouCompleteMe {
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py --racer-completer
  endif
endfunction
" }
" cpsm {
function! BuildCPSM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !PY3=OFF ./install.sh
  endif
endfunction
" }

" Clang_complete {
function! BuildClangComp(info)
  if a:info.status == 'installed' || a:info.force
    !make install
  endif
endfunction
" }

" plug.vim is in my vimfiles/autoload repo
set rtp+=~/vimfiles
call plug#begin('~/.vim/plugged')
    " Make sure to use single quotes
    "
    " Popular color schems
    Plug 'crusoexia/vim-monokai'
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'altercation/vim-colors-solarized'
    Plug 'junegunn/seoul256.vim'

    " original repos on github
    " handle brackets, quotes, etc. easier
    Plug 'tpope/vim-surround'

    Plug 'gorkunov/smartpairs.vim'

    " better than taglist
    Plug 'majutsushi/tagbar'

    " my personal stuff
    Plug 'rene-aguirre/vim-personal'

    " Tab helper
    Plug 'godlygeek/tabular'

if has("win32") || has("win64")
    " Run shell commands in background
    Plug 'xolox/vim-shell'
    Plug 'xolox/vim-misc'
endif

if s:ultisnips_enabled
    " better than snipMate
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
endif

    " \bd buffer delete mapping
    Plug 'vim-scripts/kwbdi.vim'

    " Ascii drawing helper
    " Plug 'vim-scripts/DrawIt'

    " RST Markup helper
    " Plug 'vim-scripts/VST'

    " full reST support (complains on clicable.vim)
    " Plug 'Rykka/riv.vim'

    " software caps lock
    Plug 'tpope/vim-capslock'

if s:vimairline_enabled
    Plug 'vim-airline/vim-airline'
else
    Plug 'itchyny/lightline.vim'
endif

    " file browser
    Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle' }

    " syntax checker
    Plug 'scrooloose/syntastic'

    " git helpers
    Plug 'tpope/vim-fugitive'
    " Plug 'airblade/vim-gitgutter'

    " Extradite for fugitive
    Plug 'grota/vim-extradite'

    " three file diffs
    " Plug 'sjl/splice.vim.git'

    " file manager
    Plug 'ctrlpvim/ctrlp.vim'
    " cpsm, ctrlp matcher for paths
    Plug 'nixprime/cpsm', { 'do': function('BuildCPSM') }

    Plug 'scrooloose/nerdcommenter'

    Plug 'vimwiki/vimwiki'

    " expand selection incrementally (removed: I'm not really using it)
    " Plug 'terryma/vim-expand-region'

    " Plant UML syntax and helper
    Plug 'aklt/plantuml-syntax'

    Plug 'ntpeters/vim-better-whitespace'

    Plug 'octol/vim-cpp-enhanced-highlight'

    " Completion and highlighting while on active substitution
    Plug 'osyo-manga/vim-over'

    " Rust programming language
    Plug 'rust-lang/rust.vim'

    " Julia support
    Plug 'JuliaEditorSupport/julia-vim'

    " vim-runners, enable :Run script (save and execute)
    Plug 'urthbound/vim-runners'

    " tmux integration
if !has("gui_running")

    Plug 'tmux-plugins/vim-tmux-focus-events'
endif

    " You completeme
if s:ycm_enabled
    " Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
endif
    " deprecated in favor of Mucomplete
    " Plug 'ajh17/VimCompletesMe'

if s:supertab_enabled
    " use supertab to work sith YCM and UltiSnips
    Plug 'ervandew/supertab'
elseif s:mucomplete_enabled
    Plug 'lifepillar/vim-mucomplete'
elseif s:clevertab_enabled
    Plug 'neitanod/vim-clevertab'
endif

    Plug 'keith/swift.vim'

    " Convenient work motions
    Plug 'kana/vim-smartword'

    Plug 'Konfekt/FastFold'

    Plug 'mhinz/vim-startify'

    Plug 'neomake/neomake'

    Plug 'ludovicchabant/vim-gutentags'

if s:clang_complete
    Plug 'Rip-Rip/clang_complete', { 'do': function('BuildClangComp') }
endif

call plug#end()

    " Extended %
    runtime macros/matchit.vim

    filetype plugin on
    filetype plugin indent on " allow plug-ins to detect filetypes
" }

" Don't use Ex mode, use Q for formatting
nnoremap Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
endif
set synmaxcol=128
syntax sync minlines=256

" Only do this part when compiled with support for autocommands.
" auto commands {
if has("autocmd")
    " put these in an autocmd group, so that we can delete them easily.
    augroup vimrcex
    au!

    " for all text files set 'textwidth' to 78 characters.
    autocmd filetype text setlocal textwidth=78

    " only run pylint by :make
    let g:pylint_onwrite = 0

    " pylint enabled for python files
    autocmd filetype python compiler pylint

    " close if last window is nerd tree
    autocmd bufenter * if (winnr("$") == 1 && exists("b:nerdtreetype") && b:nerdtreetype == "primary") | q | endif

    " when editing a file, always jump to the last known cursor position.
    " don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd bufreadpost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

    " reset visual bell setting
    autocmd bufreadpost * set t_vb=""

    " automatically set working dir according to active buffer
    " disabled, this has a conflict with 'fugitive.vim' plugin
    " autocmd bufwinenter,bufenter * lcd %:p:h

    " new syntax files
    autocmd bufreadpost,bufnewfile *.psr set filetype=psr
    autocmd bufreadpost,bufnewfile *.psq set filetype=psr
    autocmd bufreadpost,bufnewfile *.jth set filetype=forth
    autocmd bufreadpost,bufnewfile *.pycfg set filetype=python

    autocmd filetype rust compiler cargo

    autocmd filetype gitcommit setlocal spell spelllang=en_us
    autocmd filetype markdown setlocal spell spelllang=en_us

    " Change Color when entering Insert Mode
    " autocmd InsertEnter * set cursorline

    " Revert Color to default when leaving Insert Mode
    " autocmd InsertLeave * set nocursorline

    if version >= 700 
        autocmd QuickFixCmdPre *grep* Gcd
        autocmd QuickFixCmdPost * botright cwindow 5
    endif
    augroup end

endif " has("autocmd")
" }

if executable("rg")
    " use ripgrep when available
    set grepprg=rg\ --vimgrep\ --no-heading\ --no-messages
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif
set diffopt+=vertical

" source $VIMRUNTIME/mswin.vim
" set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
behave mswin

" mouse selection works as visual
set selectmode=key

" fix surround.vim vs and vgS
set selection=inclusive

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

" backspace in Visual mode deletes selection
" vnoremap <BS> d

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X>   "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy (only visual mode)
vnoremap <C-C>      "+y
vnoremap <C-Insert> "+y

if !has("win32unix")
" use system clipboard for yanks
set clipboard^=unnamed
endif

" Ctrl-V and SHIFT-Insert are Paste
vnoremap <C-V>  :set paste<CR>"+gP:set nopaste<CR>
inoremap <C-V>  <C-O>:set paste<CR><C-O>"+gP<C-O>:set nopaste<CR>
cmap     <C-V>  <C-R>+

if has("virtualedit") && has("gui")
    " Pasting blockwise and linewise selections is not possible in Insert and
    " Visual mode without the +virtualedit feature.  They are pasted as if they
    " were characterwise instead.
    " Uses the paste.vim autoload script.
    exe 'inoremap <script> <S-Insert>' paste#paste_cmd['i']
    exe 'vnoremap <script> <S-Insert>' paste#paste_cmd['v']
endif

" Don't use CTRL-Q to do what CTRL-V used to do
" noremap <C-Q>		<C-V>

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<C-O>:update<CR>

" CTRL-Z is Undo; not in cmdline though
noremap <C-Z> u
inoremap <C-Z> <C-O>u

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" persistent undo
set undofile
set undodir=~/.vim/undodir

" CTRL-Y is Redo (although not repeat); not in cmdline though
noremap <C-Y> <C-R>
inoremap <C-Y> <C-O><C-R>

" Alt-Space is System menu
if has("gui")
  noremap <M-Space> :simalt ~<CR>
  inoremap <M-Space> <C-O>:simalt ~<CR>
endif

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
onoremap <C-Tab> <C-C><C-W>w

" ****************
" Main settings
" ****************
"
" global settings
let mapleader=";"
set title      " change terminal title

set history=100	" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" general buffer options
set autoread    " load file on changes, automatically

" wrapping
set wrap        " wrap lines
set linebreak   " wrap on full words
set showbreak=↪\ 

" show whitespace
set listchars=tab:▶–,trail:·,precedes:«,extends:»,eol:¶
nmap <leader>s :set list!<CR>

" searching and matching {
    set showcmd     " Show partial command in status line
    set showmatch   " Show matching brackets
    set incsearch	" do incremental searching
    set hlsearch    " highlight searches
    set ignorecase  " Do case insensitive matching
    set smartcase
" }

" tabs and indentation {
    set tabstop=4
    set softtabstop=0
    set shiftwidth=4
    set shiftround  " multiples of shiftwidth when using >
    set smarttab
    set expandtab
    set autoindent
    set cindent
    set copyindent
    set preserveindent

    " makefiles retain tabs
    autocmd filetype make setlocal ts=4 sw=4 noexpandtab

    " javascript size 2 tabstop
    autocmd filetype javascript setlocal ts=2 sw=2

    autocmd filetype c,cpp map [[ ?{<CR>w99[{
    autocmd filetype c,cpp map ][ /}<CR>b99]}
    autocmd filetype c,cpp map ]] j0[[%/{<CR>
    autocmd filetype c,cpp map [] k$][%?}<CR>
    " autocmd filetype c,cpp MUcompleteAutoOn
" }

set laststatus=2 " always show status window

set statusline=
set statusline +=%*\ %n%*            "buffer number
set statusline +=%*\ %{fugitive#statusline()}%*
set statusline +=%*\ %<%F%*            "full path
set statusline +=%*%m%*                "modified flag
set statusline +=%*\ %y%*              "file type
set statusline +=%*\ %{&ff}%*          "file format
set statusline +=%*%=%5l%*             "current line
set statusline +=%*/%L%*               "total lines
set statusline +=%*%4v\ %*             "virtual column number
set statusline +=%*0x%04B\ %*          "character under cursor

" remove visual and audio bells
set vb
"set fdm=marker
"set nofen

if has("gui_running")
    set background=dark
    " colorscheme desert_luna
    colorscheme monokai
else
    " seoul256 (dark):
    " "   Range:   233 (darkest) ~ 239 (lightest)
    " "   Default: 237
    if has("gui_running")
    let g:seoul256_background = 234
    else
    let g:seoul256_background = 235
    endif
    " " seoul256 (light):
    " "   Range:   252 (darkest) ~ 256 (lightest)
    " "   Default: 253
    " let g:seoul256_background = 256
    colorscheme seoul256
endif

" set background=light
" colorscheme PaperColor

" Fonts {
    if has("gui_gtk2")
        set guifont=DejaVu\ Sans\ Mono\ 10,Fixed\ 12
        " set guifontwide=Microsoft\ Yahei\ 12,WenQuanYi\ Zen\ Hei\ 12
    else
        set guifont=Mononoki:h14,Monaco:h13,DejaVu\ Sans\ Mono:h9,Consolas:h10
    endif
" }

"display line numbers on left of window
set number

" visible lines above or below the cursor
set scrolloff=2

if s:vimairline_enabled
" airline plugin {
    let g:airline#extensions#whitespace#enabled = 0
    " fugitive
    let g:airline#extensions#branch#enabled = 1
    let g:airline#extensions#branch#empty_message = ''
    " only branch name tail
    let g:airline#extensions#branch#format = 1
    let g:airline#extensions#branch#displayed_head_limit = 16
    " don't show empty changes items
    let g:airline#extensions#hunks#non_zero_only = 1
  " disable syntastic integration
  let g:airline#extensions#syntastic#enabled = 0

  let g:airline_left_sep = '»'
  let g:airline_right_sep = '«'
  let g:airline_right_alt_sep = ''

  " remove percentage
  " let g:airline_section_x = (filetype, virtualenv)

    function! MyFF()
        return printf('%s%s', &fenc, strlen(&ff) > 0 ? '['.&ff[0].']' : '')
    endfunction
    call airline#parts#define_function('myff', 'MyFF')
    let g:airline_section_y = airline#section#create_right(['myff'])
    " let g:airline_section_z = airline#section#create_right(['%2v', '%2p%%'])
    let g:airline_section_z = airline#section#create_right(['%2v %2p%%'])
" }
endif

" NERDTree plug-ing {
    nmap <F2> :NERDTreeToggle<CR>
    imap <F2> <C-O>:NERDTreeToggle<CR>
    omap <F2> <C-C>:NERDTreeToggle<CR>
" }

" Tagbar plug-in {
    if has("win32") || has("win64")
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

" Fugitive plug-in {
    " toggles the Fugitive status window.
    function! s:GS_toggle()
        for i in range(1, winnr('$'))
            let bnum = winbufnr(i)
            if getbufvar(bnum, '&filetype') == 'gitcommit'
                execute "bdelete".bnum
                return
            endif
        endfor
        execute "topleft Gstatus"
    endfunction

    nnoremap <Leader>gb :Gblame -w<cr>
    nnoremap <Leader>gc :Gcommit<cr>
    nnoremap <Leader>gd :Gdiff<cr>
    nnoremap <Leader>gs :Gstatus<cr>
    " nnoremap <Leader>gp :Git push<cr>
    " nnoremap <Leader>gr :Gremove<cr>
    " nnoremap <Leader>gw :Gwrite<cr>

    command! GSToggle call s:GS_toggle()
    nmap <F9> :GSToggle<CR>
    autocmd Filetype gitcommit noremap <buffer> <ESC> <C-W>c
" }

" ctrlp.vim plug-in {
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

    " use ctrlp-cmatcher extension, ctrlp-py-matcher
    " let g:ctrlp_match_func = {'match' : 'pymatcher#PyMatch'}
    let g:ctrlp_match_func = {'match' : 'cpsm#CtrlPMatch'}

    "
    " keep current dir, avoid messin with submodules
    let g:ctrlp_working_path_mode = 'wa'

    " limit max number of files
    let g:ctrlp_max_files = 100000

    " indexing speed up
    if executable('rg')
        let s:ctrlp_git_command = 'rg --color=never --no-messages --glob "" --files %s'
        let g:ctrlp_use_caching = 0
    else
        let s:ctrlp_git_command = 'cd %s && python ~/vimfiles/gitsub.py'
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

" vimwiki plug-in {
    let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/'}]
" }

" YouCompleteMe plug-in {
if s:ycm_enabled
    nnoremap <Leader>] :YcmCompleter GoTo<CR>
    " let g:ycm_rust_src_path=expand("~/tools/rust/src")
    " rustup 'rust-src' component installation path
    let g:ycm_rust_src_path=substitute(system('echo `rustc --print sysroot`/lib/rustlib/src/rust/src'), "\n", "", "")
    let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
    " make YCM compatible with UltiSnips (using supertab)
endif
" }

" SuperTab plug-in {
if s:supertab_enabled
    " let g:SuperTabNoCompleteAfter =
    " let g:SuperTabDefaultCompletionType = 'context'
    let g:SuperTabContextDefaultCompletionType = '\t'
    " consolidate space-tab to bare tab (easy way to force tab too)
    let g:SuperTabMappingTabLiteral = '<C-T>'
endif
" }

" Mucomplete {
if s:mucomplete_enabled
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
endif
" }

if s:clevertab_enabled 
" Clevertab {
    inoremap <silent><tab> <c-r>=CleverTab#Complete('start')<cr>
                        \<c-r>=CleverTab#Complete('tab')<cr>
                        \<c-r>=CleverTab#Complete('ultisnips')<cr>
                        \<c-r>=CleverTab#Complete('keyword')<cr>
                        \<c-r>=CleverTab#Complete('neocomplete')<cr>
                        \<c-r>=CleverTab#Complete('omni')<cr>
                        \<c-r>=CleverTab#Complete('stop')<cr>
    inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>
" }
endif

if s:clang_complete
" clang_complete {
if has("macunix")
    let g:clang_use_library = 1
    let g:clang_library_path='/Applications/Xcode.app/Contents/Frameworks/libclang.dylib'
    let g:clang_user_options = '-std=c++14'
    let g:clang_complete_auto = 1
    if s:ultisnips_enabled
        let g:clang_snippets = 1
        let g:clang_snippets_engine = 'ultisnips'
    endif
endif
" }
endif

" Startify plug-in {
    let s:padding_left = repeat(' ', 3)
    let g:startify_list_order = [
        \ [s:padding_left .'MRU '. getcwd()], 'dir',
        \ [s:padding_left .'MRU'],            'files',
        \ [s:padding_left .'Sessions'],       'sessions',
        \ [s:padding_left .'Bookmarks'],      'bookmarks',
        \ [s:padding_left .'Commands'],       'commands',
        \ ]

    let g:ascii = [
            \ '        __',
            \ '.--.--.|==|.--------.',
            \ '|  |  ||  ||  .  .  |',
            \ ' \___/ |__|.__|__|__.',
            \]

    let g:startify_custom_header = g:ascii + startify#fortune#boxed()
    " always keep my current dir
    let g:startify_change_to_dir = 0
" }

" smartword {
" Replace |w| and others with |smartword-mappings|:
	map w  <Plug>(smartword-w)
	map b  <Plug>(smartword-b)
	map e  <Plug>(smartword-e)
	map ge  <Plug>(smartword-ge)
" }

" gui options {
    if has("gui_running")
        " set guioptions+=e   " tab bar displayed
        set guioptions-=m     " menu bar displayed
        set guioptions-=T     " disable toolbar
        " set showtabline=2
        set cursorline        " highlight current line
        set columns=99
        nmap <F10> :if &guioptions=~'m' \| set guioptions-=m \| else \| set guioptions+=m \| endif<cr>

        " set the cursor to a vertical line in insert mode and a solid block
        " in command mode
        let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
        let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
        inoremap <special> <Esc> <Esc>hl

        highlight Cursor guifg=black guibg=cyan
        highlight iCursor guifg=black guibg=red
        set guicursor=i:ver30-iCursor
        set guicursor=n-v-c:block-Cursor
        set guicursor+=n-v-c:blinkon0

    endif
    " For CTRL-V to work autoselect must be off.
    " On Unix we have two selections, autoselect can be used.
    set guioptions-=a
    if has("win32") || has("win64")
        " For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
        " let &guioptions = substitute(&guioptions, "t", "", "g")
        set backupdir=$TMP
        set directory=$TMP
    else
        silent execute '!mkdir ~/.vim/backup > /dev/null 2>&1'
        silent execute '!mkdir ~/.vim/swap > /dev/null 2>&1'
        set backupdir=$HOME/.vim/backup//
        set directory=$HOME/.vim/swap//
    endif
" }

" change windows inside tabs
" like when moving sheets on excell
noremap <C-PageDown> <C-W>w
inoremap <C-PageDown> <C-O><C-W>w
onoremap <C-PageDown> <C-C><C-W>w

noremap <C-PageUp> <C-W><C-W>
inoremap <C-PageUp> <C-O><C-W><C-W>
onoremap <C-PageUp> <C-C><C-W><C-W>

" QuickList settings {
    " Turn off spell check in the quickfix buffer
    autocmd Filetype qf setlocal nospell
    autocmd Filetype qf setlocal nobuflisted

    " Browsing old results
    autocmd Filetype qf noremap <buffer> <C-K> :cold<CR>
    autocmd Filetype qf noremap <buffer> <C-J> :cnew<CR>

    " toggles the quickfix window.
    let g:jah_Quickfix_Win_Height=10
    let g:restore_buf_num = 0
    function! s:qf_toggle()
        for i in range(1, winnr('$'))
            let bnum = winbufnr(i)
            if getbufvar(bnum, '&buftype') != 'quickfix'
                continue
            endif
            cclose
            if g:restore_buf_num && getbufvar(bnum, '&buftype') == 'quickfix'
                if bufexists(g:restore_buf_num) && bnum == bufnr('%')
                    execute ":buffer " . g:restore_buf_num
                endif
            endif
            return
        endfor
        let g:restore_buf_num = bufnr('%')
        " g:restore_win_num = winbufnr(0) " -1 if none
        execute "botright copen " . g:jah_Quickfix_Win_Height
    endfunction
    " autocmd winleave qf let g:restore_buf_num=0

    command! QFix call s:qf_toggle()

    " mapping F8 to toggle quickfix
    noremap <F8> :QFix<CR>
    inoremap <F8> <C-O>:QFix<CR>
    onoremap <F8> <C-C>:QFix<CR>
" } Quicklist
"

" Delete window, keep split layout
function! s:bd_split()
    execute ":bp | bd #"
endfunction

command! Bd call s:bd_split()

map <F1> <Esc>
map! <F1> <Esc>

" map to shift indent
vnoremap > >gv
vnoremap < <gv

" delete words to the right
inoremap <C-Del> <C-O>daw
noremap <C-Del> daw

" CTRL-H does replace, normal mode only
noremap <S-C-h> :%s#\<<c-r>=expand("<cword>")<CR>\>#

" search & replace {

" supress "Press Enter..." prompt
" set shortmess+=a
" set cmdheight=2

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

    command! -nargs=1 G call Grep('<args>', 0)
    command! -nargs=1 Gi call Grep('<args>', 1)

    " find in git repo with fugitive
    noremap <leader>gg :silent Ggrep! -n <c-r>=expand("<cword>") .
        \ " -- " . GetFtExtension(&filetype, bufname('%'), '', has("unix"))<CR>
    if executable("rg")
        noremap <leader>ff :silent grep! <c-r>=GetRgExt(&filetype, bufname('%')) . " " . expand("<cword>") <CR>
    else
        if has("unix")
            noremap <leader>ff :silent grep! -s -r --include=<c-r>=GetFtExtension(&filetype, bufname('%'), '', has('unix')) . " " . expand("<cword>") . " ."<CR>
        else
            noremap <leader>ff :silent grep! /r /s /p <c-r>=expand("<cword>") .
                \ " " . GetFtExtension(&filetype, bufname('%'), '', has("unix"))<CR>
        endif
    endif
" }

"  tag helpers (ctags) {
    " run ctags in the current folder
    if has("win32") || has("win64")
		command! BuildTags execute '!' . expand('~') . "\\vimfiles\\ctags.exe -R --c++-kinds=+p --fields=+iaS --extra=+q ."
	else
		command! BuildTags execute '!' . "ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
	endif
	set tags=./tags;
    " work with git hooks (so top level repo path applies)
    set notagrelative
" }


"  UltiSnips {
if s:ultisnips_enabled
    let g:UltiSnipsSnippetsDir = '~/.vim/plugged/vim-personal/UltiSnips/'
    " better key bindings for UltiSnipsExpandTrigger
endif
" }

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
" }

" Syntastic {
" pylint slows down on write, I run it manually with :make
let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "passive_filetypes": ["python"] }
    " default all are active_filetypes
    " let g:syntastic_cpp_compiler = 'clang++'
    if executable('g++-7.1')
        let g:syntastic_cpp_compiler = 'g++-7.1'
    elseif executable('g++-7')
        let g:syntastic_cpp_compiler = 'g++-7'
    else
        let g:syntastic_cpp_compiler = 'g++'
    endif
    " let g:syntastic_cpp_compiler_options = ' -std=c++1z -stdlib=libc++ -Wall -Wextra'
    " -stdlib=libc++ not supported on gcc (implicit?)
    let g:syntastic_cpp_compiler_options = ' -std=c++1z -Wall -Wextra'
" }

" F5 as running current file
noremap <F5> :update<CR>:!%<CR>
inoremap <F5> <ESC>:update<CR>:!%<CR>

" alt+key to exit and move
inoremap è <esc>gh
inoremap ê <esc>gj
inoremap ë <esc>gk
inoremap ì <esc>gl

" at+key move by visible lines
noremap è gh
noremap ê gj
noremap ë gk
noremap ì gl

" convert current word to uppercase
noremap <leader>u m`gUiw``

" capslock.vim insert mode toggle (lock toggle)
imap <C-l> <Plug>CapsLockToggle

" change to current buffer directory, local
noremap <leader>cd :lcd %:p:h<CR>:pwd<CR>

" toggle highlight search (normal mode, <Alt-/>)
nmap ¯ :set hls!<CR>

" some plug-ins rely on wildignore
set wildignore+=*.o,*.obj,*.a,*.bak,*.lib,.svn,.hg
set wildignore+=*.pyc
set wildignore+=*.bmp,*.gif,*.jpg,*.png
set wildignore+=*.gz,*.bz,*.tar,*.zip
set wildignore+=*.avi,*.wmv,*.ogg,*.mp3,*.mov
set wildignore+=*.kobj,*.klo,*.dm1,*.dm2
set wildignore+=*.com,*.dll,*.exe,*.tmp,*.swp

if has("wildmenu")
    set wildmenu
    set wildmode=list:longest,list
endif

" use folder from current buffer
set browsedir=buffer

" It makes vim work like every other multiple-file editor on the planet
set hidden

" filename completion ignores case
set wildignorecase

" other options
" default asm type to kalimba asm
let asmsyntax = "kalimba"

" save bookmarks
set viminfo='50,f1

" start with folding disabled
set nofoldenable

" cmake project helper
function! s:s_build(...)
	execute ":wall"
    if (! empty(glob('./CMakeLists.txt'))) && (! empty(glob('./build/Makefile')))
        execute "make -C ./build " . join(a:000, ' ')
    else
        execute "make" . join(a:000, ' ')
    endif
endfunction
command! -nargs=* Build call s:s_build(<f-args>)

function! s:s_test()
    if (! empty(glob('./CMakeLists.txt'))) && (! empty(glob('./build/Makefile')))
        execute "make test ARGS=--output-on-failure -C ./build"
    else
        execute "make test" . join(a:000, ' ')
    endif
endfunction
command! -nargs=* Test call s:s_test()

" make sure arrow key mappings work properly
" this fixes fugitive E349 on commit
if &term =~ '^screen'
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
	map <Esc>[B <Down>
endif

" NeoVim (nvim) settings
if has('nvim') || version >= 800
    " exit terminal mode (go back with 'i')
    tnoremap <Esc> <C-\><C-N>

    let g:python_host_prog  = '/usr/local/bin/python2'
    let g:python3_host_prog = '/usr/local/bin/python3'
endif

