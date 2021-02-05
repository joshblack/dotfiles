if !has('nvim')
  finish
endif

function s:CheckColorScheme()
  if !has('termguicolors')
    let g:base16colorspace=256
  endif

  if !exists('g:colors_name') || g:colors_name != 'base16-ocean'
    colorscheme base16-ocean
  endif

  set background=dark

  execute 'highlight Comment ' . luaeval("require'wincent.pinnacle'.italicize('Comment')")

  " Hide (or at least make less obvious) the EndOfBuffer region
  highlight! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg
endfunction

if v:progname !=# 'vi'
  if has('autocmd')
    augroup JBAutocolor
      autocmd!
      autocmd FocusGained * call s:CheckColorScheme()
    augroup END
  endif

  call s:CheckColorScheme()
endif
