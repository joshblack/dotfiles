# dotfiles

> Dotfiles for git, zsh, iTerm2, Homebrew, Neovim, and more

## Features

- [x] Basic `.gitconfig`
- [x] [Oh my zsh](https://ohmyz.sh/) with custom `.zshrc`
- [x] [Ghostty](https://ghostty.org/) preferences synced to `.config`
- [x] [Homebrew](https://brew.sh/) settings synced to `Brewfile`
- [x] [Neovim](https://neovim.io/) support with native packages

## Getting started

```bash
ln -s ~/dotfiles/.config/* .config/
```

## Tips

### Homebrew

```bash
# Dump installed homebrew packages into `Brewfile`
brew bundle dump --describe --force --file Brewfile
```
