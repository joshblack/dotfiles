" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
\ 'javascript.jsx': ['/usr/local/bin/javascript-typescript-stdio'],
\ 'go': ['$GOPATH/bin/go-langserver']
\ }