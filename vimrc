" My personal vimrc file.
"
" Author:	Rene F. Aguirre
" Last change:	$date$
"

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
filetype off
set encoding=utf-8

" Pluggin management {
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()

    " Vim Vundle, https://github.com/gmarik/vundl
    " Refresh with ":BundlesInstall"
    " let Vundle manage Vundle
    Bundle 'gmarik/vundle'
    "
    " My Bundles here:
    "
    " original repos on github
    " handle brackets, quotes, etc. easier
    Bundle 'tpope/vim-surround'

    " better than taglist
    Bundle 'majutsushi/tagbar'

    " my personal stuff
    Bundle 'rene-aguirre/vim-personal.git'

    " Tab helper
    Bundle "godlygeek/tabular"

    " another buffer explorer
    " Bundle 'sandeepcr529/Buffet.vim'

if has("win32") || has("win64")
    " Run shell commands in background
    Bundle 'xolox/vim-shell'
    Bundle 'xolox/vim-misc'
endif
    
    " much better than snipMate
    Bundle 'SirVer/ultisnips'

    " \bd buffer delete mapping
    Bundle 'kwbdi.vim'

    " Ascii drawing helper
    " Bundle 'DrawIt'

    " RST Markup helper
    " Bundle 'VST'

    " full reST support
    Bundle "Rykka/riv.vim"

    " software caps lock
    Bundle "capslock.vim"

    " highlight bar
    Bundle 'Lokaltog/vim-powerline'

    " file browser
    Bundle 'scrooloose/nerdtree'

    " git helper
    Bundle 'tpope/vim-fugitive.git'

    " Extradite for fugitive
    Bundle 'grota/vim-extradite'

    " three file diffs
    " Bundle 'sjl/splice.vim.git'

    " file manager
    Bundle 'kien/ctrlp.vim'

    Bundle 'scrooloose/nerdcommenter'
    
    Bundle 'vimwiki'

    " expand selection incrementally
    Bundle 'terryma/vim-expand-region'

    " vertical indexing lines
    " Bundle 'Yggdroot/indentLine'

    " Extended %
    runtime macros/matchit.vim

    filetype plugin on  
    filetype plugin indent on " allow plug-ins to detect filetypes
" }

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
endif

" Only do this part when compiled with support for autocommands.
" auto commands {
    if has("autocmd")
    " put these in an autocmd group, so that we can delete them easily.
    augroup vimrcex
    au!

    " for all text files set 'textwidth' to 78 characters.
    autocmd filetype text setlocal textwidth=78

    " makefiles retain tabs
    autocmd filetype make setlocal ts=4 sts=4 sw=4 noexpandtab
    
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

    " single cursorline
    autocmd winenter * setlocal cursorline
    autocmd winleave * setlocal nocursorline

    " new syntax files
    autocmd bufreadpost,bufnewfile *.psr set filetype=psr
    autocmd bufreadpost,bufnewfile *.psq set filetype=psr
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

" Ctrl-V and SHIFT-Insert are Paste
vnoremap <C-V>  "+gP
inoremap <C-V>  <C-O>:set paste<CR><C-O>"+gP<C-O>:set nopaste<CR>
cmap   <C-V>  <C-R>+

vnoremap <S-Insert> "+gP
inoremap <S-Insert> <C-O>:set paste<CR><C-O>"+gP<C-O>:set nopaste<CR>
cmap   <S-Insert> <C-R>+

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
" let mapleader=","
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
    set softtabstop=4
    set shiftwidth=4
    set shiftround  " multiples of shiftwidth when using >
    set smarttab
    set expandtab
    set autoindent
    set cindent
    set copyindent
" }

set laststatus=2 " always show status window
set statusline=%F%m%r%h%w\ %{exists('*CapsLockSTATUSLINE')?CapsLockSTATUSLINE():''}\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%04.8b]\ [HEX=\%04.4B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

" remove visual and audio bells
set vb
"set fdm=marker
"set nofen

if has("gui")
    colorscheme desert-luna
    let g:molokai_original=1
endif

" Fonts {
    set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h9,DejaVu\ Sans\ Mono:h9,Consolas:h10
    let Powerline_symbols = 'fancy'
" }

"display line numbers on left of window
set number 

" visible lines above or below the cursor
set scrolloff=2

" Vundle plugin {
    if !has("unix")
        set shellxquote=
    endif
" }

" NERDTree plug-ing {
    nmap <F2> :NERDTreeToggle<CR>
    imap <F2> <C-O>:NERDTreeToggle<CR>
    omap <F2> <C-C>:NERDTreeToggle<CR>
" }

" Tagbar plug-in {
    if has("win32") || has("win64")
        let g:tagbar_ctags_bin = '~/vimfiles/ctags.exe'
    endif
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

    " indexing speed up
    if has("unix")
    let g:ctrlp_user_command = {
        \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ 3: ['.svn', 'find %s -type f'],
            \ },
        \ 'fallback': 'find %s -type f'
        \ }
    else
    " windows
    let ctrlp_filter_greps = "".
        \ 'grep -iv "\\.\(' .
        \ 'exe\|jar\|class\|swp\|swo\|log\|so\|o\|pyc\|jpe?g\|png\|gif\|mo\|po' .
        \ 'o\|a\|obj\|com\|dll\|exe\|tmp\|docx\|pdf\|jpg\|png\|vsd\|zip' .
        \ '\)$"'
    "   \ '\)$" | ' .
    "   \ 'grep -v "^\(\\./\)?\(' .
    "   \ 'deploy\\\|lib\\\|classes\\\|libs\\\|deploy\\vendor\\\|\\.git\\\|\\.hg\\\|\\.svn\\\|\\.*migrations\\\)'
    "    \ '\)"'
    let g:ctrlp_user_command = {
        \ 'types': {
            \ 1: ['.git', "cd %s && git ls-files | " . ctrlp_filter_greps],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ 3: ['.svn', 'svn status %s -q -v | sed ' . "'" . 's/^.\{28\}\s*\(.*\s\)//' . "' | " . ctrlp_filter_greps],
            \ },
        \ 'fallback': 'dir %s /-n /b /s /a-d'
        \ }
    endif
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
    endif
    " For CTRL-V to work autoselect must be off.
    " On Unix we have two selections, autoselect can be used.
    set guioptions-=a
    if has("win32") || has("win64")
        " For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
        " let &guioptions = substitute(&guioptions, "t", "", "g")
        set backupdir=$TMP
        set directory=$TMP
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
    function! s:qf_toggle()
        for i in range(1, winnr('$'))
            let bnum = winbufnr(i)
            if getbufvar(bnum, '&buftype') == 'quickfix'
                cclose
                return
            endif
        endfor
        execute "botright copen " . g:jah_Quickfix_Win_Height
    endfunction

    command! QFix call s:qf_toggle()

    " mapping F8 to toggle quickfix
    noremap <F8> :QFix<CR>
    inoremap <F8> <C-O>:QFix<CR>
    onoremap <F8> <C-C>:QFix<CR>
" } Quicklist
"
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
" CTR-F
noremap <S-C-f> /<c-r>=expand("<cword>")<CR>

" search & replace {
function! GetFtExtension(sFt, sFile, sRootPrefix)
" sFt, given filetype
" sFile, reference filename
" sRootPrefix, top level path

python << endpython
import vim
import os.path
ft_map = {
    'c' :   ['.c', '.h'],
    'asm':  ['.asm', '.h'],
    'kalimba': ['.asm', '.h'],
    'cpp': ['.c', '.cpp', '.asm', '.h', '.hpp'],
}
default_ext = os.path.splitext(vim.eval("a:sFile"))[1].strip()
all_ext = ft_map.get(vim.eval("a:sFt"), [default_ext,])
if default_ext and default_ext not in all_ext:
    # desirable to include current file ext
    all_ext.insert(0, default_ext)
if vim.eval("a:sRootPrefix").strip():
    if default_ext:
        result_str = " ".join([os.path.join(vim.eval("a:sRootPrefix").strip(), '*'+the_file.strip()) for the_file in all_ext])
    else:
        result_str = os.path.split( vim.eval("a:sFile") )[1]
elif default_ext:
    result_str = " ".join(['*' + the_file.strip() for the_file in all_ext])
else:
    result_str = os.path.split( vim.eval("a:sFile") )[1]
vim.command('return "{0}"'.format(result_str))
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
                let g:mygrepprg="findstr\\ /n\\ /r\\ /s\\ /i\\ /p"
            else
                let g:mygrepprg="findstr\\ /n\\ /r\\ /s\\ /p"
            endif
            let g:grepcmd="silent! grep " . a:args . " " . GetFtExtension(&filetype, bufname('%'), '')

        else
            if a:ignorecase
                let g:mygrepprg="git\\ grep\\ -ni"
            else
                let g:mygrepprg="git\\ grep\\ -n"
            endif
            let g:grepcmd="silent! grep " . a:args . " -- " . GetFtExtension(&filetype, bufname('%'), g:gitroot)
        endif
        exec "set grepprg=" . g:mygrepprg
        execute g:grepcmd
        botright copen
        let &grepprg=grepprg_bak
        exec "redraw!"
    endfunction

    command! -nargs=1 G call Grep( '<args>', 0)
    command! -nargs=1 Gi call Grep( '<args>', 1)

    " find in git repo with fugitive
    noremap <leader>gg :silent Ggrep! -n <c-r>=expand("<cword>") . 
        \ " -- " . GetFtExtension(&filetype, bufname('%'), '')<CR> \| :botright copen
    noremap <leader>ff :silent grep! /r /s /p <c-r>=expand("<cword>") . 
        \ " " . GetFtExtension(&filetype, bufname('%'), '')<CR> \| :botright copen
    noremap <leader>fi :silent grep! /i /r /s /p <c-r>=expand("<cword>") . 
        \ " " . GetFtExtension(&filetype, bufname('%'), '')<CR> \| :botright copen
    noremap <leader>fh :silent grep! /i /r /s /p <c-r>=expand("<cword>") . " *.h" <CR> \| :botright copen
" }

"  tag helpers (ctags) {
    " run ctags in the current folder
    command! BuildTags execute '!' . expand('~') . "\\vimfiles\\ctags.exe -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    " work with git hooks (so top level repo path applies)
    set notagrelative
" }

" F5 as running current file
noremap <F5> :update<CR>:silent !%<CR>
inoremap <F5> <ESC>:update<CR>:silent !%<CR>

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
set wildignore+=*.o,*.obj,*.a,*.bak,*.lib,.svn,.git,.hg
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

" other options
" default asm type to kalimba asm
let asmsyntax = "kalimba"

" save bookmarks
set viminfo='50,f1

" start with folding disabled
set nofoldenable

