let g:prettier#autoformat=0
let g:prettier#exec_cmd_async=1
let g:prettier#quickfix_enabled=0

" max line length that prettier will wrap on
let g:prettier#config#print_width=80

" number of spaces per indentation level
let g:prettier#config#tab_width=2

" use tabs over spaces
let g:prettier#config#use_tabs='false'

" print semicolons
let g:prettier#config#semi='true'

" single quotes over double quotes
let g:prettier#config#single_quote='true'

" print spaces between brackets
let g:prettier#config#bracket_spacing='false'

" put > on the last line instead of new line
let g:prettier#config#jsx_bracket_same_line='true'

" none|es5|all
let g:prettier#config#trailing_comma='es5'

" cli-override|file-override|prefer-file
let g:prettier#config#config_precedence='prefer-file'

" Manually override file formatting
let g:joshblack#format_on_save=1
function! FormatFile()
  if g:joshblack#format_on_save
    PrettierAsync
  endif
endfunction

autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.css,*.scss,*.graphql,*.md,*.mdx,*.vue call FormatFile()