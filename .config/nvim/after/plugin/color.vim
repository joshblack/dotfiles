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

  " Grey, just like we used to get with https://github.com/Yggdroot/indentLine
  " let s:conceal_term_fg=239
  " let s:conceal_gui_fg='Grey30'
  " highlight clear Conceal
  " execute 'highlight Conceal ' .
  "       \ 'ctermfg=' . s:conceal_term_fg
  "       \ 'guifg=' . s:conceal_gui_fg
endfunction

if v:progname !=# 'vi'
  if has('autocmd')
    augroup WincentAutocolor
      autocmd!
      autocmd FocusGained * call s:CheckColorScheme()
    augroup END
  endif

  call s:CheckColorScheme()
endif
