" vimwiki plug-in {
let s:vimwiki_enabled = 0
if !empty(glob('~/Dropbox/vimwiki/'))
    let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/'}]
    let s:vimwiki_enabled = 1
elseif !empty(glob('~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/vimwiki/'))
    let g:vimwiki_list = [{'path': '~/Library/Mobile\ Documents/com~apple~CloudDocs/Documents/vimwiki/'}]
    let s:vimwiki_enabled = 1
endif
Plug 'vimwiki/vimwiki'
" }
