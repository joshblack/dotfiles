-- Plugins
return {
  -- Colorscheme
  {
    'rmehri01/onenord.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onenord').setup({
        borders = true,
        italics = {
          comments = true,
          strings = false,
          keywords = false,
          functions = false,
          variables = false,
        },
      })
      vim.cmd.colorscheme('onenord')
    end
  },

  -- Setup
  'folke/lazy.nvim',
  'lewis6991/impatient.nvim',
  'nvim-lua/plenary.nvim',

  -- TreeSitter
  { import = 'jb.treesitter' },

  -- File explorer
  { import = 'jb.file-explorer' },

  -- LSP
  { import = 'jb.lsp' },

  -- Snippets
  {
    'L3MON4D3/LuaSnip',
    config = function()
      require('jb.snippets')
    end
  },

  -- Completion
  { import = 'jb.completion' },

  -- Fuzzy Finder
  'nvim-telescope/telescope-ui-select.nvim',
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      require('jb.fuzzy-finder')
    end
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require('jb.statusline')
    end,
  },

  -- Git
  'tpope/vim-fugitive',
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  },

  -- Comments
  {
    'preservim/nerdcommenter',
    config = function()
      vim.g.NERDSpaceDelims = 1
    end
  },

  -- Formatting
  -- https://github.com/editorconfig/editorconfig-vim
  'editorconfig/editorconfig-vim',
  'tpope/vim-sleuth',

  {
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup({
        -- show icons in the signs column
        signs = false,
        highlight = {
          before = '',
          keyword = 'fg',
          after = '',
        },
        keywords = {
          TODO = {
            color = 'todo',
          }
        },
        colors = {
          todo = {'Todo'},
        },
      })
    end
  },

  -- Emmet
  {
    'mattn/emmet-vim',
    config = function()
      vim.g.user_emmet_settings = {
        javascript = {
          extends = 'jsx',
        },
        typescriptreact = {
          extends = 'jsx',
        },
      }
    end
  },

  -- JSX
  -- Note: this requires additional_vim_regex_highlighting = true in treesitter
  'maxmellon/vim-jsx-pretty',

  -- Startup screen
  {
    'goolord/alpha-nvim',
    config = function ()
      local startify = require('alpha.themes.startify')
      require('alpha').setup(startify.config)
    end
  },

  -- Help
  {
    'folke/which-key.nvim',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
      require('which-key').setup({})
    end
  },
}
