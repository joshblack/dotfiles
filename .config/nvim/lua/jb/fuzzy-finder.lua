local map = require('jb.config.utils').map

map('n', '<Leader>t', ':FZF<CR>')

vim.g.fzf_colors = {
  gutter = {'bg', 'Normal'},
  ['bg+'] = {'bg', 'Normal'},
  pointer = {'fg', 'Normal'},
}