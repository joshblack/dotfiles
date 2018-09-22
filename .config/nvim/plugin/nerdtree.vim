" Tell vim not to use netrw
" let g:loaded_netrw=1
" let g:loaded_netrwPlugin=1

" Tell vim to display hidden files by default
let g:NERDTreeShowHidden=1
let g:NERDSpaceDelims=1

" The default of 31 is just a little too narrow.
let g:NERDTreeWinSize=35

" Disable display of '?' text and 'Bookmarks' label.
let g:NERDTreeMinimalUI=1

" Let <Leader><Leader> (^#) return from NERDTree window.
let g:NERDTreeCreatePrefix='silent keepalt keepjumps'

" Single-click to toggle directory nodes, double-click to open non-directory
" nodes.
let g:NERDTreeMouseMode=2

" Use NERDTree by default
let g:NERDTreeHijackNetrw=1

" Custom NERDTree bindings
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>

" if has('autocmd')
"   augroup JBNERDTree
"     autocmd!
"     autocmd User NERDTreeInit call joshblack#autocmds#attempt_select_last_file()
"     autocmd vimenter * NERDTree
"     " autocmd bufenter * NERDTreeMirror
"     autocmd vimenter * wincmd w
"   augroup END
" endif

" call joshblack#plugin#lazy({
"       \   'pack': 'nerdtree',
"       \   'plugin': 'NERD_tree.vim',
"       \   'commands': {
"       \     'NERDTree': '-n=? -complete=dir -bar',
"       \     'NERDTreeCWD': '-n=0 -bar',
"       \     'NERDTreeClose': '-n=0 -bar',
"       \     'NERDTreeFind': '-n=0 -bar',
"       \     'NERDTreeFocus': '-n=0 -bar',
"       \     'NERDTreeFromBookmark': '-n=1 -bar',
"       \     'NERDTreeMirror': '-n=0 -bar',
"       \     'NERDTreeToggle': '-n=? -complete=dir -bar',
"       \   },
"       \   'nnoremap': {
"       \     '<silent> -': ":silent edit <C-R>=empty(expand('%')) ? '.' : fnameescape(expand('%:p:h'))<CR><CR>"
"       \   }
"       \ })
