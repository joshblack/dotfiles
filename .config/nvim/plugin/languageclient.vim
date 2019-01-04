" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
\ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
\ 'javascript.jsx': ['flow-language-server', '--stdio'],
\ 'go': [$GOPATH . '/bin/go-langserver']
\ }
