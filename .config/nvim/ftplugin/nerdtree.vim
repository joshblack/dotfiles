if exists('+colorcolumn')
  setlocal colorcolumn=
endif

if has('folding')
  setlocal nofoldenable
endif

setlocal nolist
setlocal signcolumn=no

" Move up a directory using "-" like vim-vinegar (usually "u" does this).
nmap <buffer> <expr> - g:NERDTreeMapUpdir
