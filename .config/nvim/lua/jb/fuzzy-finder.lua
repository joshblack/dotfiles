local map = require('jb.config.utils').map
local actions = require('telescope.actions')

vim.keymap.set('n', '<leader>t', require('telescope.builtin').find_files, { desc = 'Search files' })
vim.keymap.set('n', '<leader>rg', require('telescope.builtin').live_grep, { desc = 'Grep files ([r]ip[g]rep)' })
vim.keymap.set('n', '<leader>rf', require('telescope.builtin').lsp_references, { desc = 'Search [r]e[f]erences' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').lsp_document_symbols, { desc = '[S]earch Document [S]ymbols' })
vim.keymap.set('n', '<leader>sws', require('telescope.builtin').lsp_dynamic_workspace_symbols, { desc = '[S]earch [W]orkspace [S]ymbols' })

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
      hidden = true,
    },
    live_grep = {
      -- disable_devicons = true,
    },
    lsp_references = {
      -- disable_devicons = true,
    },
    diagnostics = {
      -- disable_devicons = true,
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown()
    },
  },
})

require('telescope').load_extension('ui-select')
