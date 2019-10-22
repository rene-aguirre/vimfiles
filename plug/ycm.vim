" YouCompleteMe plug-in {
function! BuildYCM(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status == 'installed' || a:info.force
        !python3 ./install.py --racer-completer --clang-completer
    endif
endfunction

nnoremap <Leader>] :YcmCompleter GoTo<CR>
" let g:ycm_rust_src_path=expand("~/tools/rust/src")
" rustup 'rust-src' component installation path
let g:ycm_rust_src_path=substitute(system('echo `rustc --print sysroot`/lib/rustlib/src/rust/src'), "\n", "", "")
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']

Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
" }
