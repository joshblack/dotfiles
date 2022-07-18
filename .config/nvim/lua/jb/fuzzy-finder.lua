local map = require('jb.config.utils').map
local actions = require('telescope.actions')

-- map('n', '<Leader>t', ':FZF<CR>')

-- vim.g.fzf_colors = {
  -- gutter = {'bg', 'Normal'},
  -- ['bg+'] = {'bg', 'Normal'},
  -- pointer = {'fg', 'Normal'},
-- }

vim.keymap.set('n', '<Leader>t', function()
  require('telescope.builtin').find_files()
end)

require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<Esc>"] = actions.close,
      },
    },
    preview = false,
  },
  pickers = {
    find_files = {
      disable_devicons = true,
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown()
    },
  },
})

require('telescope').load_extension('ui-select')
