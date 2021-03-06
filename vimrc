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
  if $COLORTERM == 'truecolor'
    set termguicolors
  endif
  set synmaxcol=128
  syntax sync minlines=256
  syntax sync maxlines=512
  set nocursorline
  set nocursorcolumn
  set redrawtime=10000
  if has('nvim')
    set lazyredraw
  endif
endif

" current file path, follow symlinks and get only directory
let s:cfg_path=fnamemodify(resolve(expand("<sfile>:p")), ":h")
let g:CFG_PATH=s:cfg_path

function s:load_config(from_path)
    exec 'source ' . s:cfg_path . a:from_path
endfunction

function s:load_plug(plug_file)
    exec 'source ' . s:cfg_path . '/plug/' . a:plug_file . '.vim'
endfunction

function s:load_utility(utility_file)
    exec 'source ' . s:cfg_path . '/utils/' . a:utility_file . '.vim'
endfunction

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
    autocmd bufreadpost,bufnewfile *.psr setlocal filetype=psr
    autocmd bufreadpost,bufnewfile *.psq setlocal filetype=psr
    autocmd bufreadpost,bufnewfile *.jth setlocal filetype=forth
    autocmd bufreadpost,bufnewfile *.pycfg setlocal filetype=python
    autocmd bufreadpost,bufnewfile *.swift setlocal filetype=swift

    autocmd filetype rust compiler cargo

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

	" close preview window when exiting insert mode
	autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | silent! pclose | endif

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

" stock vim Catalina shows error
execute 'silent! set diffopt+=vertical'

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
if has('nvim')
    nnoremap <D-V>  :set paste<CR>"+gP:set nopaste<CR>
    vnoremap <D-V>  :set paste<CR>"+gP:set nopaste<CR>
    inoremap <D-V>  <C-O>:set paste<CR><C-O>"+gP<C-O>:set nopaste<CR>
    cnoremap <D-V>  <C-R>+
else
    vnoremap <C-V>  :set paste<CR>"+gP:set nopaste<CR>
    inoremap <C-V>  <C-O>:set paste<CR><C-O>"+gP<C-O>:set nopaste<CR>
    cnoremap <C-V>  <C-R>+
endif


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

set history=100    " keep 50 lines of command line history
set ruler        " show the cursor position all the time

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
    set incsearch    " do incremental searching
    set hlsearch    " highlight searches
    set ignorecase  " Do case insensitive matching
    set smartcase
if has('nvim')
    set inccommand=split " neovim incremental search (:s only)
else
    set incsearch " vim incremental search
endif
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
    "https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack/Regular/complete
    set guifont=Hack\ Nerd\ Font\ Mono:h13,mononoki\ Nerd\ Font\ Mono:h14,
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
" (repo, submodules, etc)
function! Tcd() abort
    let s:top_dir = get(s:, 'top_dir', getcwd())
    let l:test_dir=trim(system('git rev-parse --show-toplevel'))
    let l:test_dir_prev=''
    while !v:shell_error && l:test_dir == l:test_dir_prev
        let s:top_dir=l:test_dir
        exec 'cd ' . s:top_dir
        exec 'cd ..'
        let l:test_dir_prev=l:test_dir
        let l:test_dir=trim(system('git rev-parse --show-toplevel'))
    endwhile
    if s:top_dir || getcwd() != s:top_dir
        exec 'cd ' . s:top_dir
    endif
endfunction

let s:xcode_dev_path = trim(system("xcode-select -p 2>/dev/null"))
let s:xcode_toolchain_path = glob(s:xcode_dev_path . '/Toolchains/XcodeDefault.xctoolchain')
" w/ brew prefix
let s:brew_path = trim(system('brew --prefix'))
if v:shell_error
    let s:brew_path=''
endif
" tries to find utility executable, prefers /usr/local paths
" args:
"   cmd_str     plain command, e.g. 'clang-format'
"   formula     homebrew's package 'formula' (optional)
function! FindExecutableBase(cmd_str, formula, path_first)
    if a:path_first
        let l:cmd_path = trim(system('command -v ' . a:cmd_str))
        if !v:shell_error && executable(l:cmd_path)
            return l:cmd_path
        endif
    endif
    let l:path_prefix = [
        \ s:brew_path . '/opt/' . a:formula . '/bin/',
        \ '/usr/local/opt/' . a:formula . '/bin/',
        \ '/usr/local/bin/',
        \ '/usr/bin/',
        \ ]
    for prefix in l:path_prefix
        " echom 'Checking: ' . prefix . a:cmd_str
        if executable(prefix . a:cmd_str)
            return prefix . a:cmd_str
        endif
    endfor
    if !empty(s:xcode_toolchain_path)
        for prefix in l:path_prefix
            if executable(s:xcode_toolchain_path . prefix . a:cmd_str)
                return s:xcode_toolchain_path . prefix . a:cmd_str
            endif
        endfor
    endif
    if !a:path_first
        let l:cmd_path = trim(system('command -v ' . a:cmd_str))
        if !v:shell_error && executable(l:cmd_path)
            return l:cmd_path
        endif
    endif
    return ""
endfunction

function! FindExecutable(cmd_str, formula)
    return FindExecutableBase(a:cmd_str, a:formula, 1)
endfunction

function! FindExecutableOpt(cmd_str, formula)
    return FindExecutableBase(a:cmd_str, a:formula, 0)
endfunction

let s:cmd_python2 = FindExecutable('python2', 'python2')
let s:cmd_python3 = FindExecutable('python3', 'python3')
let s:cmd_python = s:cmd_python3
if !executable(s:cmd_python)
    let s:cmd_python = s:cmd_python2
endif
let s:cmd_rg = FindExecutable('rg', 'ripgrep')
" helper for fast list of files
function! s:GetFileListCmd()
    call Tcd()
    if has("unix") && !empty(glob('.git')) && executable(s:cmd_python)
        if executable(s:cmd_rg)
            return s:cmd_python . ' ' . s:cfg_path  . '/gitsub.py --rg'
        else
            return s:cmd_python . 'python ' . s:cfg_path  . '/gitsub.py'
        endif
    elseif executable(s:cmd_rg)
        return s:cmd_rg . ' --color=never --no-messages --glob "" --files .'
    elseif executable('ag')
        return 'ag . -l --nocolor -g ""'
    elseif has("unix")
        return 'find . -not -path "*/\.*" -type f \( ! -iname ".*" \)| head -50000'
    else
        return 'dir . /-n /b /s /a-d'
    endif
endfunction

"  tag helpers (ctags) {
    " run ctags in the current folder
    if has("win32") || has("win64")
        command! BuildTags execute '!' . s:cfg_path .
            \ "\\ctags.exe -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    else
        let s:cmd_ctags = FindExecutableOpt('ctags', 'universal-ctags')
        command! BuildTags execute '!' . s:cmd_ctags
            \ " -R --c++-kinds=+p --ObjectiveC-kinds=+p --fields=+iaS --extras=+q ."
    endif
    set tags=./tags,tags
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

    if executable(s:cmd_python2)
        let g:python_host_prog  = s:cmd_python2
    endif

    if executable(s:cmd_python3)
        let g:python3_host_prog = s:cmd_python3
    endif
endif

" clang-format helper
vnoremap <Leader>c :pyfile s:cfg_path . 'clang-format.py'<cr>
nnoremap <Leader>c :pyfile s:cfg_path . 'clang-format.py'<cr>
" use g:clang_format_path for custom tool path

" ------------------
" Pluggin management {
"
" plug.vim is in my vimfiles/autoload repo
exe 'set rtp+=' . s:cfg_path
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

    " handle brackets, quotes, etc. easier
    Plug 'tpope/vim-surround'

    Plug 'gorkunov/smartpairs.vim'

    " more object motions, tweaks default ones too
    Plug 'wellle/targets.vim'
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

    let s:tagbar_enabled = 0
if s:tagbar_enabled
    call s:load_plug('tagbar')
else
    Plug 'liuchengxu/vista.vim'
    nmap <F3> :Vista!!<CR>
    imap <F3> <C-O>:Vista!!<CR>
    omap <F3> <C-C>:Vista!!<CR>
endif

    " Snippets
    let g:ultisnips_enabled = has("python3")
if g:ultisnips_enabled
    call s:load_plug('ultisnips')
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

    let s:vim_airline_enabled = 0 " or lightline
if s:vim_airline_enabled
    exec 'source ' . s:cfg_path . '/plug/vim-airline'
else
    Plug 'itchyny/lightline.vim'
endif

    call s:load_plug('nerdtree')

    " tags: syntax checks
    call s:load_plug('syntastic')

    call s:load_plug('fugitive')

    " tag: ctrlp, fuzzy
let g:fuzzy_executable = FindExecutable('fzy', 'fzy')
if executable(g:fuzzy_executable)
    let g:picker_selector_executable = g:fuzzy_executable
    Plug 'srstevenson/vim-picker'
    nnoremap <C-p> <Plug>(PickerEdit)
    nmap <unique> <leader>fe <Plug>(PickerEdit)
    nmap <unique> <leader>fs <Plug>(PickerSplit)
    nmap <unique> <leader>ft <Plug>(PickerTabedit)
    nmap <unique> <leader>fv <Plug>(PickerVsplit)
    nmap <unique> <leader>fb <Plug>(PickerBuffer)
    nmap <unique> <leader>f] <Plug>(PickerTag)
    nmap <unique> <leader>fw <Plug>(PickerStag)
    nmap <unique> <leader>fo <Plug>(PickerBufferTag)
    nmap <unique> <leader>fh <Plug>(PickerHelp)
    " suppress unexpected 'f' command
    nmap <unique> <leader>f <Plug>(PickerEdit)
    let g:picker_custom_find_executable = s:cmd_python
    if executable('rg')
        let g:picker_custom_find_flags = s:cfg_path . '/gitsub.py --rg'
    else
        let g:picker_custom_find_flags = s:cfg_path . '/gitsub.py'
    endif
else
    call s:load_plug('ctrlp')
endif

    " disabled tab expand on table, fixes UltiSnips expands
    let g:vimwiki_table_mappings = 0
    call s:load_plug('vimwiki')

    " Plant UML syntax and helper
    Plug 'aklt/plantuml-syntax'

" {
    let g:vim_markdown_auto_insert_bullets = 0
    " let g:vim_markdown_new_list_item_indent = 0
    Plug 'godlygeek/tabular'
    Plug 'plasticboy/vim-markdown'
    " If you have nodejs and yarn
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
    autocmd filetype markdown setlocal spell spelllang=en_us conceallevel=2 textwidth=80
" }

    " :OverCommandLine for completion/highlight %s commands
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
    Plug 'bfrg/vim-cpp-modern', { 'for': ['cpp', 'objcpp'] }

if has('nvim')
    " C, C++, python, gdb, lldb, pdb, debug
    Plug 'sakhnik/nvim-gdb', { 'for': ['python', 'c', 'cpp'] }
endif

if has("autocmd")
    autocmd filetype cpp,objcpp setlocal matchpairs+=<:>
    autocmd filetype objc,objcpp setlocal synmaxcol=512
    " refresh ObjC++ on read (avoid some detection issues)
    autocmd bufreadpost,bufnewfile *.mm setlocal filetype=objcpp
    autocmd bufreadpost,bufnewfile *.m setlocal filetype=objc
endif

if has("mac")
    " CopyRTF copy with color to Clipboard
    Plug 'zerowidth/vim-copy-as-rtf'
endif
" }

" https://vim.fandom.com/wiki/Faster_loading_of_large_files
" file is large from 10mb
let g:LargeFile = 1024 * 1024 * 10
augroup LargeFile 
  au!
  autocmd BufReadPre * let f=getfsize(expand("<afile>")) | if f > g:LargeFile || f == -2 | call LargeFile() | endif
  autocmd BufWinEnter * if line2byte(line("$") + 1) > 1000000 | syntax clear | endif
augroup END

function! LargeFile()
" don't change eventignore, this needs window enter/exit helpers
 " save memory when other file is viewed
 setlocal bufhidden=unload
 " is read-only (write with :w new_filename)
 setlocal buftype=nowrite
 " no undo possible
 setlocal undolevels=-1
 " display message
 autocmd VimEnter *  echo "The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB, so some options are changed (see .vimrc for details)."
endfunction

if !has("gui_running")
    " tmux integration
    Plug 'tmux-plugins/vim-tmux-focus-events'
endif

" tags: completion {
    let s:cmd_clangd = FindExecutable('clangd', 'llvm')
    let s:cmd_ccls = FindExecutable('ccls', 'ccls')
    " omni
    let g:ycm_enabled    = 0
    let g:clang_complete = !executable(s:cmd_clangd) && !executable(s:cmd_ccls)
    " use tab manager
    let g:tab_manager_enabled = 1
    let g:lsp_enabled = 0
if g:ycm_enabled
    call s:load_plug('ycm')
elseif g:clang_complete
    call s:load_plug('clang_complete')
else
    " Language Server Protocol
    let g:lsp_enabled = 1 " custom
    let g:lsp_settings = { }
    if executable(s:cmd_clangd)
        if s:cmd_clangd != 'clangd'
            " clangd specific settings only, no extra compiler flags (use
            " compile_flags.txt
            let g:lsp_settings['clangd'] = { 'cmd': [s:cmd_clangd] }
        endif
    elseif executable(s:cmd_ccls)
        " ccls: https://github.com/MaskRay/ccls/wiki/Project-Setup
        au User lsp_setup call lsp#register_server({
            \ 'name': 'ccls',
            \ 'cmd': {server_info->[s:cmd_ccls]},
            \ 'root_uri': {
                \ server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(),
                \ 'compile_commands.json'))
                \ },
            \ 'initialization_options': {'cache': {'directory': '/tmp/ccls/cache' }},
            \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
            \ })
    endif
    if executable('svls')
        " system verilog
        au User lsp_setup call lsp#register_server({
            \ 'name': 'svls',
            \ 'cmd': {server_info->['svls']},
            \ 'whitelist': ['verilog', 'systemverilog'],
            \ })
    endif
    let s:swifth_lsp_enabled = 0 " not quite there yet
    if s:swifth_lsp_enabled
        let s:sourcekit_lsp = FindExecutable('sourcekit-lsp', 'swift')
        if executable(s:sourcekit_lsp)
            au User lsp_setup call lsp#register_server({
                \ 'name': 'sourcekit-lsp',
                \ 'cmd': {server_info->[s:sourcekit_lsp]},
                \ 'whitelist': ['swift'],
                \ })
        endif
    endif
    let s:hdl_checker = FindExecutable('hdl_checker', 'hdl_checker')
    if executable(s:hdl_checker)
        au User lsp_setup call lsp#register_server({
        \ 'name': 'hdl_checker',
        \ 'cmd': {server_info->lsp_settings#get('hdl_checker', 'cmd', [s:hdl_checker , '--lsp'])},
        \ 'root_uri':{server_info->lsp_settings#get('hdl_checker', 'root_uri', lsp_settings#root_uri('hdl_checker'))},
        \ 'initialization_options': lsp_settings#get('hdl_checker', 'initialization_options', {'diagnostics': 'true'}),
        \ 'allowlist': lsp_settings#get('hdl_checker', 'allowlist', ['verilog', 'vhdl', 'systemverilog']),
        \ 'blocklist': lsp_settings#get('hdl_checker', 'blocklist', []),
        \ 'config': lsp_settings#get('hdl_checker', 'config', lsp_settings#server_config('hdl_checker')),
        \ 'workspace_config': lsp_settings#get('hdl_checker', 'workspace_config', {}),
        \ 'semantic_highlight': lsp_settings#get('hdl_checker', 'semantic_highlight', {}),
        \ })
    endif
	let g:lsp_diagnostics_enabled = 0
    let g:lsp_virtual_text_enabled = 1
	let g:lsp_virtual_text_prefix = " ‣ "

    " LSP: Language Server Protocol
    Plug 'prabirshrestha/async.vim'
    Plug 'prabirshrestha/vim-lsp'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'mattn/vim-lsp-settings' " :LspInstallServer
endif
" }

if g:tab_manager_enabled
    call s:load_plug('tab_manager')
endif

    call s:load_plug('smartword')

" FastFold plug-in {
    " start with folding disabled
    set nofoldenable
    set foldmethod=syntax
    Plug 'Konfekt/FastFold'
" }

    call s:load_plug('startify')

    let g:startify_skiplist = [
           \ '/home',
           \ ]

if has('nvim')
    Plug 'neomake/neomake'
endif

" UI customization {
    Plug 'ludovicchabant/vim-gutentags', { 'for': ['python', 'c', 'cpp', 'objc', 'objcpp', 'vim', 'rust'] }

    Plug 'ryanoasis/vim-devicons'
    let g:WebDevIconsUnicodeDecorateFolderNodes = 1
    let g:DevIconsEnableFoldersOpenClose = 1
" }  UI customization

" Emmet plug-in {
    Plug 'mattn/emmet-vim'
    let g:user_emmet_install_global = 0
    autocmd FileType html,css,xml EmmetInstall
" }


if has('nvim')
" Floating preview helper {
    Plug 'ncm2/float-preview.nvim'

    function! s:DisableExtras()
        call nvim_win_set_option(g:float_preview#win, 'number', v:false)
        call nvim_win_set_option(g:float_preview#win, 'relativenumber', v:false)
        call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)
    endfunction

    autocmd User FloatPreviewWinOpen call s:DisableExtras()
" }
endif

" local configuation helper {
    let g:localvimrc_ask = 0
    Plug 'embear/vim-localvimrc'
if g:lsp_enabled
    autocmd User LocalVimRCPost call Tcd()

    function! s:cwd_updated(cdir, scope) abort
        let g:lsp_diagnostics_enabled = 0
        if &diff
            " not in vimdiff
            return
        endif
        if a:scope != 'global'
            return
        endif
        let g:lsp_diagnostics_enabled = !empty(glob('compile_commands.json')) || !empty(glob('compile_flags.txt'))
    endfunction


    if has('nvim')
        autocmd DirChanged * call s:cwd_updated(v:event['cwd'], v:event['scope'])
    else
        autocmd DirChanged global call s:cwd_updated(getcwd(), 'global')
    endif
endif
" }

call plug#end()

" }

let g:startify_custom_header = g:ascii + startify#fortune#boxed()

" tags: textobj, motion, Extended %
runtime macros/matchit.vim

" seoul256 (dark):
" "   Range:   233 (darkest) ~ 239 (lightest)
" "   Default: 237
let g:seoul256_background = 237
" " seoul256 (light):
" "   Range:   252 (darkest) ~ 256 (lightest)
" "   Default: 253
colorscheme seoul256

" cmocka
set errorformat^=\[\ \ \ LINE\ \ \ \]\ ---\ %f:%l:\ %m
" clang
set errorformat^=%f:%l:%c:\ %trror:\ %m
set errorformat^=%f:%l:%c:\ %tarning:\ %m
set errorformat^=❌\ %f:%l:%c:%m
" usually false positives (e.g. dates + time)
set errorformat-=%f:%l:%c:%m
set errorformat-=%f:%l:%m

" ignores, last items for prepend to be effective
set errorformat^=%-G%f:%l:\ WARNING\ %m
set errorformat^=%-G%f:%l:%c:\ %tarning:\ %m[-Wdeprecated-declarations]
set errorformat^=%-G%f:%l:%c:\ %tarning:\ %m[-Wunguarded-availability-new]

if has("gui_running")
    call s:load_utility('gui')
endif
call s:load_utility('grep')
call s:load_utility('build')
exec 'source' s:cfg_path .'/utils/hex2dec.vim'
call s:load_utility('indent')
call s:load_utility('shell')

" this improves XML syntax highlighting with huge files
let g:xml_namespace_transparent=1
