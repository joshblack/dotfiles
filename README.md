# dotfiles

> Dotfiles for git, zsh, iTerm2, Homebrew, Neovim, and more

## Features

- [x] Basic `.gitconfig`
- [x] [Oh my zsh](https://ohmyz.sh/) with custom `.zshrc`
- [x] [iTerm 2](https://www.iterm2.com/) preferences synced to folder
- [x] [Homebrew](https://brew.sh/) settings synced to `Brewfile`
- [x] [Neovim](https://neovim.io/) support with native packages
- [ ] [`tmux`](https://github.com/tmux/tmux) config

## Installation

- [ ] Install LanguageClient-neovim

```bash
cd .config/nvim/pack/bundle/opt/LanguageClient-neovim
bash install.sh
```

### Tips

#### Vim directory structure

- [Learn vimscript the hard way](http://learnvimscriptthehardway.stevelosh.com/chapters/42.html#vimftdetect)

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
