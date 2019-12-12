"
" LanguageClient-neovim
"

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_useFloatingHover=1
let g:LanguageClient_hoverPreview='Always'
let g:LanguageClient_diagnosticsList='Location'
" Sometimes the LanguageServer can be noisy, in particular the TypeScript one
" can be noisy if used in a non-TypeScript project. It will emit warnings about
" not being able to find type files that will get flushed to the window unless
" this is set to 'Error'
let g:LanguageClient_windowLogMessageLevel='Error'
let g:LanguageClient_diagnosticsDisplay = {
      \   1: {'signTexthl': 'LineNr', 'virtualTexthl': 'User8'},
      \   2: {'signTexthl': 'LineNr', 'virtualTexthl': 'User8'},
      \   3: {'signTexthl': 'LineNr', 'virtualTexthl': 'User8'},
      \   4: {'signTexthl': 'LineNr', 'virtualTexthl': 'User8'},
      \ }

if exists('$DEBUG_LC_LOGFILE')
  let g:LanguageClient_loggingFile=$DEBUG_LC_LOGFILE
  let g:LanguageClient_loggingLevel='DEBUG'
endif

let g:LanguageClient_rootMarkers = {
      \   'javascript': ['tsconfig.json', '.flowconfig', 'package.json'],
      \   'typescript': ['tsconfig.json', '.flowconfig', 'package.json'],
      \   'rust': ['Cargo.toml']
      \ }

let g:LanguageClient_serverCommands = {}

if executable('javascript-typescript-stdio')
  " ie. via `npm install -g javascript-typescript-langserver`
  if exists('$DEBUG_LSP_LOGFILE')
    let s:debug_args=['--trace', '--logfile', $DEBUG_LSP_LOGFILE]
  else
    let s:debug_args=[]
  endif

  let s:ts_lsp=extend([exepath('javascript-typescript-stdio')], s:debug_args)
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
nnoremap <silent> ds :call LanguageClient#textDocument_documentSymbol()<CR>
nnoremap <silent> rn :call LanguageClient#textDocument_rename()<CR>
