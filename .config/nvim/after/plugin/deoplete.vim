" Handle closing preview window after leaving insert mode
" Note: can add ',CompleteDone' onto InsertLeave if you want the preview pane
" to dissapear after completing from deople
" https://github.com/Shougo/deoplete.nvim/issues/115#issuecomment-170237485
autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

" call deoplete#custom#option('sources', {
" \ '_': ['ale'],
" \})
