# dotfiles

> [WIP] Dotfiles for setting up a new machine.

## iTerm2

Settings are stored in the `iterm2` folder!

## Homebrew

```bash
brew bundle dump --describe --force --file Brewfile
```

## ssh

When asking you to provide password between restarts, can run the following command:

```bash
ssh-add -K ~/.ssh/id_rsa
```
