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

if has("autocmd")
    " makefiles retain tabs
    autocmd filetype make setlocal ts=4 sw=4 noexpandtab

    " webi tems size 2 tabstop
    autocmd filetype html,json,javascript,xml,cmake,yaml setlocal ts=2 sw=2

    autocmd filetype c,cpp,objc,objcpp,yaml setlocal indentkeys-=:
endif
" }

