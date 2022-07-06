local map = require('jb.config.utils').map

-- Leader key
vim.g.mapleader = ','

-- Open last buffer.
map('n', '<leader><leader>', '<C-^>')

map('n', '<leader>q', ':quit<CR>')
map('n', '<leader>s', ':write<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>x', ':xit<CR>')
