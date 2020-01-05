" Leader mappings.

" <Leader><Leader> -- Open last buffer.
nnoremap <Leader><Leader> <C-^>

nnoremap <Leader>o :only<CR>
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>s :write<CR>
nnoremap <Leader>w :write<CR>
nnoremap <Leader>x :xit<CR>

" Toggle fold at current position.
" (Using s-tab to avoid collision between <tab> and <C-i>).
nnoremap <s-tab> za

imap jj <Esc>
