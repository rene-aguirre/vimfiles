" My personal vimrc file.
" Rene F. Aguirre
"
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
filetype off
set encoding=utf-8

filetype plugin on
filetype plugin indent on " allow plug-ins to detect filetypes

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

" current file path, follow symlinks and get only directory
let s:cfg_path=fnamemodify(resolve(expand("<sfile>:p")), ":h")

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
    autocmd bufreadpost,bufnewfile *.swift set filetype=swift

    autocmd filetype rust compiler cargo

    autocmd filetype markdown setlocal spell spelllang=en_us

    " Change Color when entering Insert Mode
    " autocmd InsertEnter * set cursorline

    " Revert Color to default when leaving Insert Mode
    " autocmd InsertLeave * set nocursorline
    if version >= 700
        " autocmd QuickFixCmdPre *grep* Gcd
        autocmd QuickFixCmdPre *grep* call Tcd()
        autocmd QuickFixCmdPost * botright cwindow 5
    endif

    " resize windows when vim changes size
    autocmd VimResized * wincmd =

    augroup end

endif " has("autocmd")
" }

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

if !has('win32unix') && !has('nvim')
" use system clipboard for yanks
set clipboard^=unnamed
endif

" Ctrl-V and SHIFT-Insert are Paste
vnoremap <C-V>  :set paste<CR>"+gP:set nopaste<CR>
inoremap <C-V>  <C-O>:set paste<CR><C-O>"+gP<C-O>:set nopaste<CR>
cmap     <C-V>  <C-R>+

" CTRL-Z is Undo, insert only
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

set laststatus=2 " always show status window
set statusline=
set statusline +=%*\ %n%*              "buffer number
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

" Fonts {
if has("gui_gtk2")
    set guifont=DejaVu\ Sans\ Mono\ 10,Fixed\ 12
    " set guifontwide=Microsoft\ Yahei\ 12,WenQuanYi\ Zen\ Hei\ 12
else
    set guifont=FuraCode\ Nerd\ Font\ Mono:h14,mononoki\ Nerd\ Font\ Mono:h14,
                \Mononoki:h14,Monaco:h13,DejaVu\ Sans\ Mono:h9,Consolas:h10
endif
" }

"display line numbers on left of window
set number

" visible lines above or below the cursor
set scrolloff=2

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

" set splitright
"set splitbelow

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
set equalalways
set eadirection=ver

" Change to top level git repo, works with nested git modules
" (repo, sumboules, etc)
function! Tcd()
    exec 'Gcd'
    let topgit=system('git rev-parse --show-toplevel')
    while !v:shell_error
        let g:gitroot=topgit
        exec 'cd ' . topgit
        exec 'cd ..'
        let topgit=system('git rev-parse --show-toplevel')
    endwhile
    exec 'cd ' . g:gitroot
endfunction

"  tag helpers (ctags) {
    " run ctags in the current folder
    if has("win32") || has("win64")
		command! BuildTags execute '!' . expand('~') .
		    \ "\\vimfiles\\ctags.exe -R --c++-kinds=+p --fields=+iaS --extra=+q ."
	else
		command! BuildTags execute '!' .
		    \ "ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
	endif
	set tags=./tags;
    " work with git hooks (so top level repo path applies)
    set notagrelative
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
if has('nvim')
    " exit terminal mode (go back with 'i')
    tnoremap <Esc> <C-\><C-N>

    let g:python_host_prog  = '/usr/local/bin/python2'
    let g:python3_host_prog = '/usr/local/bin/python3'
endif

" clang-format helper
vnoremap <Leader>c :pyfile ~/vimfiles/clang-format.py<cr>
nnoremap <Leader>c :pyfile ~/vimfiles/clang-format.py<cr>
" use g:clang_format_path for custom tool path

" ------------------
" Pluggin management {
"
" plug.vim is in my vimfiles/autoload repo
set rtp+=~/vimfiles
call plug#begin('~/.vim/plugged')
    " Make sure to use single quotes
    "
" Popular color schemes {
    Plug 'crusoexia/vim-monokai'
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'altercation/vim-colors-solarized'
    Plug 'junegunn/seoul256.vim'
" }

"text object, motion plug-ins {
    " delimited-object-deletions
    Plug 'machakann/vim-textobj-delimited'

    " handle brackets, quotes, etc. easier
    Plug 'tpope/vim-surround'

    Plug 'gorkunov/smartpairs.vim'
" }

    " my personal stuff
    Plug 'rene-aguirre/vim-personal'

    " Tab helper
    Plug 'godlygeek/tabular'

if has("win32") || has("win64")
    " Run shell commands in background
    Plug 'xolox/vim-shell'
    Plug 'xolox/vim-misc'
endif

    exec 'source' s:cfg_path .'/plug/tagbar.vim'

    " Snippets
    let g:ultisnips_enabled = 1
if g:ultisnips_enabled
    exec 'source' s:cfg_path .'/plug/ultisnips.vim'
endif

    " <leader>bd buffer delete & keep layout
    Plug 'vim-scripts/kwbdi.vim'

    " Ascii drawing helper
    " Plug 'vim-scripts/DrawIt'

    " RST Markup helper
    " Plug 'vim-scripts/VST'

    " full reST support (complains on clicable.vim)
    " Plug 'Rykka/riv.vim'

    " software caps lock
    Plug 'tpope/vim-capslock'

    Plug 'scrooloose/nerdcommenter'

    let s:vimairline_enabled = 0 " or lightline
if s:vimairline_enabled
    exec 'source' s:cfg_path .'/plug/vim-airline'
else
    Plug 'itchyny/lightline.vim'
endif

    exec 'source' s:cfg_path .'/plug/nerdtree.vim'

    " tags: syntax checks
    exec 'source' s:cfg_path .'/plug/syntastic.vim'

    exec 'source' s:cfg_path .'/plug/fugitive.vim'

    " tag: ctrlp, fuzzy
    exec 'source' s:cfg_path .'/plug/ctrlp.vim'

    exec 'source' s:cfg_path .'/plug/vimwiki.vim'

    " Plant UML syntax and helper
    " Plug 'aklt/plantuml-syntax'

    Plug 'ntpeters/vim-better-whitespace'

    " Completion and highlighting while on active substitution
    Plug 'osyo-manga/vim-over'

" programming languages, syntax addition {
    " Rust programming language
    Plug 'rust-lang/rust.vim', { 'for': 'rust' }

    " Julia support, broken with 'for':'julia setting
    Plug 'JuliaEditorSupport/julia-vim'

    " tags: python, pep8, syntax
    Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }

    " swift
    Plug 'keith/swift.vim', { 'for': 'swift' }

    let c_no_curly_error = 1
    Plug 'bfrg/vim-cpp-modern', { 'for': 'cpp' }

    " C, C++, python, gdb, lldb, pdb, debug
    Plug 'sakhnik/nvim-gdb', { 'for': ['python', 'c', 'cpp'] }

if has("autocmd")
    autocmd filetype cpp setlocal matchpairs+=<:>
endif

" }

if !has("gui_running")
    " tmux integration
    Plug 'tmux-plugins/vim-tmux-focus-events'
endif

" tags: completion {
    let g:ycm_enabled    = 0
    let g:clang_complete = 1

if g:ycm_enabled
    exec 'source' s:cfg_path .'/plug/ycm.vim'
elseif g:clang_complete
    exec 'source' s:cfg_path .'/plug/clang_complete.vim'
endif
" }
    exec 'source' s:cfg_path .'/plug/tab_manager.vim'
    exec 'source' s:cfg_path .'/plug/smartword.vim'

" FastFold plug-in {
    " start with folding disabled
    set nofoldenable
    set foldmethod=syntax
    Plug 'Konfekt/FastFold'
" }

    exec 'source' s:cfg_path .'/plug/startify.vim'

if has('nvim')
    Plug 'neomake/neomake'
endif

" UI customization {
    Plug 'ludovicchabant/vim-gutentags'

    Plug 'ryanoasis/vim-devicons'
    let g:WebDevIconsUnicodeDecorateFolderNodes = 1
    let g:DevIconsEnableFoldersOpenClose = 1
" }  UI customization

" Emmet plug-in {
    Plug 'mattn/emmet-vim'
    let g:user_emmet_install_global = 0
    autocmd FileType html,css,xml EmmetInstall
" }

call plug#end()

" }

let g:startify_custom_header = g:ascii + startify#fortune#boxed()

" tags: textobj, motion, Extended %
"runtime macros/matchit.vim

" seoul256 (dark):
" "   Range:   233 (darkest) ~ 239 (lightest)
" "   Default: 237
let g:seoul256_background = 237
" " seoul256 (light):
" "   Range:   252 (darkest) ~ 256 (lightest)
" "   Default: 253
colorscheme seoul256

set errorformat^=%-G%f:%l:\ WARNING\ %m
" cmocka
set errorformat^=\[\ \ \ LINE\ \ \ \]\ ---\ %f:%l:\ %m

if has("gui_running")
    exec 'source' s:cfg_path .'/utils/gui.vim'
endif
exec 'source' s:cfg_path .'/utils/grep.vim'
exec 'source' s:cfg_path .'/utils/build.vim'
exec 'source' s:cfg_path .'/utils/hex2dec.vim'
exec 'source' s:cfg_path .'/utils/indent.vim'
exec 'source' s:cfg_path .'/utils/shell.vim'

" this improves XML syntax highlighting with huge files
let g:xml_namespace_transparent=1

" source any local project config
if (!empty(glob('.vimrc~')))
    source .vimrc~
endif

