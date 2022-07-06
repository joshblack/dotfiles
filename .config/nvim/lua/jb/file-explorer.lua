local tree_cb = require('nvim-tree.config').nvim_tree_callback
local map = require('jb.config.utils').map

vim.g.nvim_tree_refresh_wait = 300

-- Mappings
map('n', '<leader>d', ':NvimTreeToggle<CR>')
map('n', '<leader>f', ':NvimTreeFindFile<CR>')

require('nvim-tree').setup({
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    add_trailing = true,
    icons = {
      show = {
        file = false,
        folder = false,
        folder_arrow = false,
        git = false,
      },
      glyphs = {
        folder = {
          default = '˃',
          open = '˅',
        },
      },
      padding = '',
    },
    indent_markers = {
      enable = true,
    },
    special_files = {},
  },
  view = {
    width = 32,
    mappings = {
      custom_only = false,
      list = {
        { key = 'p', cb = tree_cb('parent_node') },
        { key = 'i', cb = tree_cb('split') },
        { key = 's', cb = tree_cb('vsplit') },
        { key = 'r', cb = tree_cb('refresh') },
        { key = 'm', cb = tree_cb('rename') },
      },
    },
  },
})
