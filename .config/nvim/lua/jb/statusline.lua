require('lualine').setup({
  options = {
    icons_enabled = true,
    -- theme = 'nord',
    theme = 'auto',
    section_separators = {
      left = '',
      right = '',
    },
    component_separators = {
      left = '|',
      right = '|',
    },
  },
  sections = {
    lualine_b = {
      {
        'diagnostics',
        symbols = {},
      }
    },
    lualine_x = {'filetype'}
  },
  extensions = {
    'fzf',
    'nvim-tree',
  },
})
