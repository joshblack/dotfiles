# `.config`

## Tips & Tricks

Instead of symlink'ing the whole `.config` directory, just symlink all the sub-directories over to the `.config` directory that already exists.

The reason for this is mostly to support `yarn link`. When linking projects, Yarn will put them in `~/.config/yarn/link/*` on MacOS. If we have this folder symlinked to a different folder, say `~/dotfiles/.config/yarn/link`, then all of the symlinks they put in the `link` directory will be off by one directory.

```bash
ln -s ~/dotfiles/.config/* .config/
```
