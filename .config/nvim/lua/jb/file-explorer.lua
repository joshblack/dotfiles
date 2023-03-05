return {
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = 'kyazdani42/nvim-web-devicons',
    config = function()
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
              { key = 'p', action = 'parent_node' },
              { key = 'i', action = 'split' },
              { key = 's', action = 'vsplit' },
              { key = 'm', action = 'full_rename' },
              { key = 'I', action = 'toggle_git_ignored' },
            },
          },
        },
      })
    end
  },
}
