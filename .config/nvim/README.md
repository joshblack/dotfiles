# Neovim

## Tips & Tripcs

- `:CheckHealth` for the win

## Reference

- [Vimscript](https://github.com/johngrib/vimscript-cheatsheet)

### UltiSnips

```vimscript
" UltiSnips
" b - only run at the beginning of a line
```

## Install

- Generate `:helptags`

```vimscript
" Get help for this command:
:help :helptags

" Generate :helptags for directory {dir}
" When {dir} is ALL then all directories in runtimepath
" are included
:helpt ALL
```

- LanguageClient-Neovim
  - https://github.com/autozimu/LanguageClient-neovim/blob/next/INSTALL.md#manual
  - Language Servers
    - javascript-typescript-stdio
      - `npm install -g typescript-language-server`
    - flow-language-server
    - go-langserver
  - `gocode`: `go get -u github.com/mdempsky/gocode`
  - `:GoInstallBinaries`

- `deoplete.nvim`
  - [Install](https://github.com/Shougo/deoplete.nvim#install)
  - `:UpdateRemotePlugins` if no handler registered

## Debugging

#### Using `echo`

`echo` often can get surpressed, use `echom` instead and check with `:messages`
if not immediately visible
