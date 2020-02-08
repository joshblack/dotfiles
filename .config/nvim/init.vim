if v:progname == 'vi'
  set noloadplugins
endif

let mapleader=','

" Yank and paste with the system clipboard
set clipboard=unnamed

" Enable basic mouse behavior such as resizing buffers
set mouse=a

if !has('nvim')
  " Support resizing tmux
  set ttymouse=xterm2
endif

" Webpack config for triggering recompiles
" See: https://webpack.js.org/guides/development/#adjusting-your-text-editor
set backupcopy=yes

" Enable deoplete
let g:deoplete#enable_at_startup = 1

" Enable LanguageClient-Neovim
" set rtp+=$HOME/.config/nvim/pack/bundle/opt/LanguageClient-neovim

" Update runtime to include fzf
if executable('fzf')
  set rtp+=/usr/local/opt/fzf
endif

" If supports loading packages, will load from `pack` directory.
" In the `pack` directory, it will look for any folders. In each folder,
" it will look for an `start` folder for packages to load at startup.
" You can also use the `opt` directory and add in packages using the
" `packload` command
if &loadplugins
  " start, vim loads by default
  " opt, not loaded by default, can manually enable
  " packadd, packadd!, packloadall
  " packadd!, get ready to load the package but don't load it till the end
  " packloadall
  packadd! ale
  packadd! base16-vim
  packadd! deoplete.nvim
  packadd! editorconfig-vim
  packadd! emmet-vim
  packadd! fzf.vim
  packadd! goyo.vim
  packadd! json5.vim
  packadd! nerdcommenter
  packadd! nerdtree
  packadd! pinnacle
  packadd! terminus
  packadd! ultisnips
  packadd! vim-airline
  packadd! vim-airline-themes
  packadd! vim-fugitive
  packadd! vim-gitgutter
  packadd! vim-go
  packadd! vim-javascript
  packadd! vim-json
  packadd! vim-jsx
  packadd! vim-toml
endif

" Automatic, language-dependent indentation, syntax coloring and other
" functionality.
"
" Must come *after* the `:packadd!` calls above otherwise the contents of
" package "ftdetect" directories won't be evaluated.
filetype indent plugin on
syntax on

" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
