function s:CheckColorScheme()
  if !has('termguicolors')
    let g:base16colorspace=256
  endif

  if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
  endif

  execute 'highlight Comment ' . pinnacle#italicize('Comment')
  " doautocmd ColorScheme
endfunction



if v:progname !=# 'vi'
  " if has('autocmd')
    " augroup JBAutocolor
      " autocmd!
      " autocmd FocusGained * call s:CheckColorScheme()
    " augroup END
  " endif

  call s:CheckColorScheme()
endif
