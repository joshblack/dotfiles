"
" ale.vim
"
" For help debugging, or for viewing available linters, run :ALEInfo
"

let g:ale_linters = {
\  'javascript': ['flow', 'flow-language-server', 'tsserver']
\}

let g:ale_linters_explicit = 1

let g:ale_fixers = {
\   'css': ['prettier'],
\   'html': ['prettier'],
\   'javascript': ['prettier'],
\   'json': ['prettier'],
\   'json5': ['prettier'],
\   'md': ['prettier'],
\   'mdx': ['prettier'],
\   'scss': ['prettier'],
\   'ts': ['prettier'],
\   'yaml': ['prettier'],
\   'yml': ['prettier'],
\}

" Do not lint or fix minified files.
let g:ale_pattern_options = {
\ 'build\/.+\.js$': {'ale_linters': [], 'ale_fixers': []},
\ 'es\/.+\.js$': {'ale_linters': [], 'ale_fixers': []},
\ 'lib\/.+\.js$': {'ale_linters': [], 'ale_fixers': []},
\ 'umd\/.+\.js$': {'ale_linters': [], 'ale_fixers': []},
\}

" If you configure g:ale_pattern_options outside of vimrc, you need this.
let g:ale_pattern_options_enabled = 1

" Set this variable to 1 to fix files when you save them.
let g:ale_fix_on_save = 1

" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
