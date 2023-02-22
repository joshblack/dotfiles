require('lualine').setup({
  options = {
    icons_enabled = false,
    theme = 'nord',
    section_separators = {
      left = '',
      right = '',
    },
    component_separators = {
      left = '',
      right = '',
    },
  },
  sections = {
    lualine_b = {
      {
        'diagnostics',
        symbols = {
          error = '≢ ',
          warn = '≅ ',
          info = 'i',
          hint = 'Hint: ',
        },
      }
    },
    lualine_x = {'filetype'}
  },
  extensions = {
    'fzf',
    'nvim-tree',
  },
})
