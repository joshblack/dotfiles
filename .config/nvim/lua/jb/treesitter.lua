require('nvim-treesitter.configs').setup({
  ensure_installed = {
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
    'scss',
    'toml',
    'tsx',
    'typescript',
    'vim',
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
  context_commentstring = {
    enable = true,
  },
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
