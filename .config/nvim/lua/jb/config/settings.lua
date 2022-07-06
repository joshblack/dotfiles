-- Yank and paste with the system clipboard
vim.o.clipboard = 'unnamed'

-- Enable basic mouse behavior such as resizing buffers
vim.o.mouse = 'a'

-- Webpack config for triggering recompiles
-- See: https://webpack.js.org/guides/development/#adjusting-your-text-editor
vim.o.backupcopy = 'yes'

vim.cmd([[
  " Automatic, language-dependent indentation, syntax coloring and other
  " functionality.
  filetype indent plugin on
  syntax on  
  " Load all of the helptags now, after plugins have been loaded.
  " All messages and errors will be ignored.
  silent! helptags ALL
]])

-- maintain indent of current line
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.tabstop = 2
vim.o.softtabstop = -1
vim.o.shiftwidth = 2

-- foldering
vim.o.foldmethod = 'indent'
vim.o.foldlevelstart = 99

-- allow unrestricted backspacing in insert mode
vim.o.backspace = 'indent,start,eol'

-- keep backup files out of the way
vim.o.backupdir = vim.o.backupdir .. '~/.config/nvim/tmp/backup//'
vim.o.backupdir = vim.o.backupdir .. '.'

-- never ring the bell for any reason
vim.o.belloff = 'all'

-- highlight current line
vim.o.cursorline = true

-- keep swap files out of the way
vim.o.directory = vim.o.directory .. '~/.config/nvim/tmp/swap//'
vim.o.directory = vim.o.directory .. '.'

-- always use spaces instead of tabs
vim.o.expandtab = true

-- allows you to hide buffers with unsaved changes without being prompted
vim.o.hidden = true

-- always show status line
vim.o.laststatus = 2

-- don't bother updating screen during macro playback
vim.o.lazyredraw = true

-- wrap long lines at characters in 'breakat'
vim.o.linebreak = true

-- show whitespace
vim.o.list = true
vim.o.listchars = 'nbsp:¬,tab:>-,extends:»,precedes:«,trail:·'
-- don't autoinsert two spaces after '.', '?', '!' for join command
-- vim.o.nojoinspaces = true
vim.o.relativenumber = true

vim.o.scrolloff = 3
vim.o.shiftround = true

-- ignore annoying swapfile messages
vim.o.shortmess = vim.o.shortmess .. 'A'

-- no splash screen
vim.o.shortmess = vim.o.shortmess .. 'I'

-- file-read message overwrites previous
vim.o.shortmess = vim.o.shortmess .. 'O'

-- truncate non-file messages in middle
vim.o.shortmess = vim.o.shortmess .. 'T'

-- don't echo "[w]"/"[written]" when writing
vim.o.shortmess = vim.o.shortmess .. 'W'

-- use abbreviations in messages eg. `[RO]` instead of `[readonly]`
vim.o.shortmess = vim.o.shortmess .. 'a'

-- overwrite file-written messages
vim.o.shortmess = vim.o.shortmess .. 'o'

-- truncate file messages at start
vim.o.shortmess = vim.o.shortmess .. 't'


vim.o.showbreak = '↳ '

-- vim.o.noshowcmd = true

vim.o.sidescrolloff = 3



vim.o.splitbelow = true
vim.o.splitright = true
vim.o.synmaxcol=200

vim.o.termguicolors = true
vim.o.textwidth = 80
vim.o.colorcolumn = '80'

vim.o.virtualedit = 'block'

vim.o.wildmenu = true
vim.o.wildmode = 'longest:full,full'

vim.o.signcolumn = 'yes'