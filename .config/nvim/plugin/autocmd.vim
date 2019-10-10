" Autocommands
" http://learnvimscriptthehardway.stevelosh.com/chapters/12.html

" Automatic toggling between hybrid and absolute line numbers
" See later part of: https://jeffkreeftmeijer.com/vim-number/ for info
augroup CustomNumberToggle
  autocmd!
  " Only set, or unset, relativenumber if number is set. This is helpful to
  " prevent line numbers from appearing in buffers like NERDTree that don't set
  " (or need) line numbers
  autocmd BufEnter,FocusGained,WinEnter * if &number | set relativenumber | endif
  autocmd BufLeave,FocusLost,WinLeave * if &number | set norelativenumber | endif
augroup END
