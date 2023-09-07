# dotfiles

> Dotfiles for git, zsh, iTerm2, Homebrew, Neovim, and more

## Features

- [x] Basic `.gitconfig`
- [x] [Oh my zsh](https://ohmyz.sh/) with custom `.zshrc`
- [x] [iTerm 2](https://www.iterm2.com/) preferences synced to folder
- [x] [Homebrew](https://brew.sh/) settings synced to `Brewfile`
- [x] [Neovim](https://neovim.io/) support with native packages

## Getting started

```bash
ln -s ~/dotfiles/.config/* .config/
```

## Debugging

### Using `echo`

`echo` often can get surpressed, use `echom` instead and check with `:messages`
if not immediately visible

## Tips

### `:checkhealth` for the win

This command can be run in `neovim` to make sure everything is working as
expected.

### Homebrew

```bash
# Dump installed homebrew packages into `Brewfile`
brew bundle dump --describe --force --file Brewfile
```
