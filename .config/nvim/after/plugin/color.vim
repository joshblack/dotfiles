if v:progname !=# 'vi'
  if !has('termguicolors')
    let g:base16colorspace=256
  endif

  if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
  endif

  " Hide (or at least make less obvious) the EndOfBuffer region
  highlight! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg


  " Updates color for each item in NERDTree, without this fix
  " the region where the text is won't match highlighting for other
  " selected lines
  " https://github.com/neovim/neovim/issues/9019#issuecomment-423791923
  execute 'highlight NERDTreeFile ctermfg=251'

  execute 'highlight Comment ' . pinnacle#italicize('Comment')
endif
