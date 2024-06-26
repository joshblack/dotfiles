return {
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-refactor',
    },
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'astro',
          'css',
          'dockerfile',
          'elixir',
          'go',
          'gomod',
          'graphql',
          'html',
          'javascript',
          'jsdoc',
          'json',
          'json5',
          'lua',
          'prisma',
          'scss',
          'toml',
          'tsx',
          'typescript',
          'vim',
          'vimdoc',
          'yaml',
        },
        highlight = {
          enable = true,
          use_languagetree = true,
          additional_vim_regex_highlighting = true
        },
        indent = {
          enable = false,
        },
        -- context_commentstring = {
          -- enable = true,
        -- },
        playground = {
          enable = true,
        },
        refactor = {
          highlight_definitions = {
            enable = true,
          },
          highlight_current_scope = {
            enable = false,
          },
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = {'BufWrite', 'CursorHold'},
        },
      })
    end,
  },
  'nvim-treesitter/playground',
}
