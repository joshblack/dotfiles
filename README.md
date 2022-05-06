# dotfiles

> Dotfiles for git, zsh, iTerm2, Homebrew, Neovim, and more

## Features

- [x] Basic `.gitconfig`
- [x] [Oh my zsh](https://ohmyz.sh/) with custom `.zshrc`
- [x] [iTerm 2](https://www.iterm2.com/) preferences synced to folder
- [x] [Homebrew](https://brew.sh/) settings synced to `Brewfile`
- [x] [Neovim](https://neovim.io/) support with native packages
- [ ] [`tmux`](https://github.com/tmux/tmux) config

## `.config`

## Tips & Tricks

Instead of symlink'ing the whole `.config` directory, just symlink all the sub-directories over to the `.config` directory that already exists.

The reason for this is mostly to support `yarn link`. When linking projects, Yarn will put them in `~/.config/yarn/link/*` on MacOS. If we have this folder symlinked to a different folder, say `~/dotfiles/.config/yarn/link`, then all of the symlinks they put in the `link` directory will be off by one directory.

```bash
ln -s ~/dotfiles/.config/* .config/
```

## Vim (Neovim)

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
    - flow-language-server
    - go-langserver
  - `gocode`: `go get -u github.com/mdempsky/gocode`
  - `:GoInstallBinaries`

### Language Servers

This configuration currently uses `nvim-lspconfig` with the following LSPs
defined [here](https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md)

- vimls

#### JavaScript

```bash
# javascript-typescript-stdio
npm install -g typescript-language-server
```

#### Rust

```bash
rustup component add rls rust-analysis rust-src --toolchain stable-x86_64-apple-darwin
```

- `deoplete.nvim`
  - [Install](https://github.com/Shougo/deoplete.nvim#install)
  - `:UpdateRemotePlugins` if no handler registered


## Debugging

#### Using `echo`

`echo` often can get surpressed, use `echom` instead and check with `:messages`
if not immediately visible

## Reference

- [Vimscript](https://github.com/johngrib/vimscript-cheatsheet)
- [Learn vimscript the hard way](http://learnvimscriptthehardway.stevelosh.com/chapters/42.html#vimftdetect)

### UltiSnips

```vimscript
" UltiSnips
" b - only run at the beginning of a line
```

## Tips

#### `:checkhealth` for the win

This command can be run in `neovim` to make sure everything is working as
expected.

#### Updating submodules

```bash
git pull --recurse-submodules
git submodule update --remote --recursive
```

#### Homebrew

```bash
# Dump installed homebrew packages into `Brewfile`
brew bundle dump --describe --force --file Brewfile
```
