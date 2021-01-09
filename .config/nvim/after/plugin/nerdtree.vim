"
" nerdtree.vim
"

" Tell vim to display hidden files by default
let g:NERDTreeShowHidden=1
let g:NERDSpaceDelims=1

" The default of 31 is just a little too narrow.
let g:NERDTreeWinSize=35

" Disable display of '?' text and 'Bookmarks' label.
let g:NERDTreeMinimalUI=1

" Single-click to toggle directory nodes, double-click to open non-directory
" nodes.
let g:NERDTreeMouseMode=2

" Use NERDTree by default
let g:NERDTreeHijackNetrw=1

" Custom NERDTree bindings
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
