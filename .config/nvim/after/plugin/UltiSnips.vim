"
" ultisnips.vim
"

" If UltiSnips' own "after" hook runs after us (and `:scriptnames` shows that it
" does), don't let it overwrite us.
let b:did_after_plugin_ultisnips_after=1

let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"
