# dotfiles

> Dotfiles for git, zsh, Ghostty, Homebrew, Neovim, and more

## Features

- [x] Basic `.gitconfig`
- [x] [Oh my zsh](https://ohmyz.sh/) with custom `.zshrc`
- [x] [Ghostty](https://ghostty.org/) preferences synced to `.config`
- [x] [Rex](https://www.superlogical.com/rex/docs) configuration synced to `.config`
- [x] [Homebrew](https://brew.sh/) settings synced to `Brewfile`
- [x] [Neovim](https://neovim.io/) support with native packages

## Getting started

```bash
ln -s ~/dotfiles/.config/* .config/
ln -s ~/dotfiles/.gitconfig .gitconfig
ln -s ~/dotfiles/.gitconfig-github .gitconfig-github
ln -s ~/dotfiles/.gitconfig-macos .gitconfig-macos
ln -s ~/dotfiles/.gitconfig-nbdsystem .gitconfig-nbdsystem
ln -s ~/dotfiles/.gitignore_global .gitignore
ln -s ~/dotfiles/.zshrc .zshrc
ln -s ~/dotfiles/Brewfile Brewfile
```

The `.config/*` step includes Rex, linking `~/.config/rex` to
`~/dotfiles/.config/rex`. Edit `.config/rex/init.lua` to customize Rex, then
reload the configuration:

```bash
rex config reload
```

## Tips

### Homebrew

```bash
# Dump installed homebrew packages into `Brewfile`
brew bundle dump --no-dump-npm --no-dump-cargo --no-dump-vscode --no-dump-go -f
```
