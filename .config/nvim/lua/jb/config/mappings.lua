local map = require('jb.config.utils').map

-- Mapping options:
-- map('n', ...)
-- map('v', ...)
-- map('i', ...)
-- map('t', ...)

-- Normal
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
-- Toggle fold at current position.
map('n', '<s-tab>', 'za')
-- Toggle fold at current position.
map('n', '<tab>', 'za')

-- Visual
map('v', '<C-h>', '<C-w>h')
map('v', '<C-j>', '<C-w>j')
map('v', '<C-k>', '<C-w>k')
map('v', '<C-l>', '<C-w>l')

-- Insert
map('i', 'jj', '<esc>')
