"
" Language Client support
"

" Required for operations modifying multiple buffers like rename.
set hidden

" let g:LanguageClient_loggingLevel = 'INFO'
" let g:LanguageClient_virtualTextPrefix = ''
" let g:LanguageClient_loggingFile =  expand('~/.config/nvim/log/LanguageClient.log')
" let g:LanguageClient_serverStderr = expand('~/.config/nvim/log/LanguageServer.log')

let g:LanguageClient_fzfContextMenu=1
let g:LanguageClient_useFloatingHover=1
let g:LanguageClient_hoverPreview='Always'

let g:LanguageClient_rootMarkers = {
      \   'javascript': ['tsconfig.json', '.flowconfig', 'package.json'],
      \   'typescript': ['tsconfig.json', '.flowconfig', 'package.json']
      \ }

" let g:LanguageClient_serverCommands = {
    " \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    " \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    " \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    " \ }

let g:LanguageClient_serverCommands = {}

if executable('javascript-typescript-stdio')
  " ie. via `npm install -g javascript-typescript-langserver`
  " if exists('$DEBUG_LSP_LOGFILE')
    " let s:debug_args=['--trace', '--logfile', $DEBUG_LSP_LOGFILE]
  " else
    " let s:debug_args=[]
  " endif

  " let s:ts_lsp=extend([exepath('javascript-typescript-stdio')], s:debug_args)
  let s:ts_lsp=extend([exepath('javascript-typescript-stdio')], [])
else
  let s:ts_lsp=[]
endif

" From `npm install -g flow-bin`:
let s:flow_lsp=executable('flow') ?
      \ [exepath('flow'), 'lsp'] :
      \ []

let s:ts_filetypes=[
      \   'typescript',
      \   'typescript.tsx',
      \ ]

let s:js_filetypes=[
      \   'javascript',
      \   'javascript.jsx',
      \ ]

if s:ts_lsp != []
  for s:ts_filetype in s:ts_filetypes
    let g:LanguageClient_serverCommands[s:ts_filetype]=s:ts_lsp
  endfor
endif

if s:ts_lsp != [] && filereadable('tsconfig.json')
  let s:js_lsp=s:ts_lsp
elseif s:flow_lsp != [] && filereadable('.flowconfig')
  let s:js_lsp=s:flow_lsp
elseif s:ts_lsp != []
  let s:js_lsp=s:ts_lsp
endif

if exists('s:js_lsp')
  for s:js_filetype in s:js_filetypes
    let g:LanguageClient_serverCommands[s:js_filetype]=s:js_lsp
  endfor
endif

" via https://rustup.rs
if executable('rustup')
  let g:LanguageClient_serverCommands['rust']=[exepath('rustup'), 'run', 'stable', 'rls']
endif

" https://github.com/sourcegraph/go-langserver
" via go get -u github.com/sourcegraph/go-langserver
if executable('go-langserver')
  let g:LanguageClient_serverCommands['go']=[exepath('go-langserver')]
endif

nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
