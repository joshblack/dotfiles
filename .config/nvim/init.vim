if v:progname == 'vi'
  set noloadplugins
endif

let mapleader=','

" Automatic, language-dependent indentation, syntax coloring and other
" functionality.
filetype indent plugin on
syntax on

" Yank and paste with the system clipboard
set clipboard=unnamed

" Enable basic mouse behavior such as resizing buffers
set mouse=a

" Support resizing tmux
if exists('$TMUX')
  set ttymouse=xterm2
endif

" Webpack config for triggering recompiles
" See: https://webpack.js.org/guides/development/#adjusting-your-text-editor
set backupcopy=yes

" If supports loading packages, will load from `pack` directory.
" In the `pack` directory, it will look for any folders. In each folder,
" it will look for an `start` folder for packages to load at startup.
" You can also use the `opt` directory and add in packages using the
" `packload` command
if &loadplugins
  if has('packages')
    packloadall
  endif
endif