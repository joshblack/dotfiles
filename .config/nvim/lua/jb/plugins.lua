local jb_packer = require('jb.packer')
local packer = jb_packer.packer;
local first_install = jb_packer.first_install;

return packer.startup(function(use)
  -- Setup, common plugins
  use 'wbthomason/packer.nvim'
  use 'lewis6991/impatient.nvim'
  use 'nvim-lua/plenary.nvim';

  -- Color scheme
  use {
    'rmehri01/onenord.nvim',
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
      vim.cmd [[colorscheme onenord]]
    end
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/playground',
    },
    run = ':TSUpdate',
    config = function()
      require('jb.treesitter')
    end,
  }
  use 'nvim-treesitter/playground'

  -- File explorer
  use {
    'kyazdani42/nvim-tree.lua',
    commit = '8b8d457',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('jb.file-explorer')
    end
  }

  -- LSP
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      local null_ls = require('null-ls')
      null_ls.setup({
        sources = {
          -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#diagnostic-config
          null_ls.builtins.diagnostics.eslint.with({
            diagnostic_config = {
              -- see :help vim.diagnostic.config()
              underline = false,
              virtual_text = false,
              signs = true,
              update_in_insert = false,
            },
          }),
          null_ls.builtins.formatting.prettierd,
        },
      })
    end
  }
  use {
    'williamboman/mason.nvim',
    config = function()
      require('jb.lsp')
    end
  }
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'
  use 'onsails/lspkind-nvim'
  use {
    'j-hui/fidget.nvim',
    config = function()
      require('fidget').setup({})
    end
  }
  use {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup({
        icons = false,
        fold_open = 'v',
        fold_closed = '>',
        indent_lines = false,
        signs = {
            error = 'error',
            warning = 'warn',
            hint = 'hint',
            information = 'info'
        },
        use_diagnostic_signs = false
      })
    end
  }

  -- Snippets
  use {
    'L3MON4D3/LuaSnip',
    config = function()
      require('jb.snippets')
    end
  }

  -- Completion
  -- use {
    -- "zbirenbaum/copilot.lua",
    -- cmd = "Copilot",
    -- event = "VimEnter",
    -- config = function()
      -- vim.defer_fn(function()
        -- require("copilot").setup({
            -- filetypes = {
              -- ["*"] = true,
            -- },
            -- suggestions = {
              -- enabled = false,
            -- },
            -- panel = {
              -- auto_refresh = true,
            -- },
        -- })
      -- end, 100)
    -- end,
  -- }
  use {
    'hrsh7th/nvim-cmp',
    config = function()
      require('jb.completion')
    end,
    requires = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      -- 'zbirenbaum/copilot-cmp',
    }
  }
  -- use {
    -- 'zbirenbaum/copilot-cmp',
    -- after = { 'copilot.lua' },
    -- config = function ()
      -- require('copilot_cmp').setup()
    -- end
  -- }

  -- FZF
  -- use { 'junegunn/fzf', run = './install --all' }
  -- use {
    -- 'junegunn/fzf.vim',
    -- config = function()
      -- require('jb.fuzzy-finder')
    -- end
  -- }
  use 'nvim-telescope/telescope-ui-select.nvim'
  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.x',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
      require('jb.fuzzy-finder')
    end
  }

  -- Statusline
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('jb.statusline')
    end,
    requires = {
      'kyazdani42/nvim-web-devicons',
      opt = true
    }
  }

  -- Git
  use 'tpope/vim-fugitive'

  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      require('gitsigns').setup()
    end,
  }

  -- Comments
  use {
    'preservim/nerdcommenter',
    config = function()
      vim.g.NERDSpaceDelims = 1
    end
  }

  -- Formatting
  -- https://github.com/editorconfig/editorconfig-vim
  use 'editorconfig/editorconfig-vim'
  use 'tpope/vim-sleuth'

  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function()
      require('todo-comments').setup({
        -- show icons in the signs column
        -- TODO: help me
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
  }

  -- Emmet
  use {
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
  }

  -- Formatting
  -- use {
    -- 'dense-analysis/ale',
    -- config = function()
      -- vim.g.ale_completion_enabled = 0
      -- vim.g.ale_linters = {
        -- elixir =  {},
        -- javascript =  {},
        -- rust =  {},
        -- typescript = {}
      -- }
      -- vim.g.ale_linters_explicit = 1
      -- vim.g.ale_fixers = {
        -- css = {'prettier'},
        -- -- elixir = {'mix_format'},
        -- elixir = {},
        -- html = {'prettier'},
        -- javascript = {'prettier'},
        -- json = {'prettier'},
        -- json5 = {'prettier'},
        -- markdown = {'prettier'},
        -- mdx = {'prettier'},
        -- rust = {'rustfmt'},
        -- scss = {'prettier'},
        -- typescript = {'prettier'},
        -- typescriptreact = {'prettier'},
        -- yaml = {'prettier'},
        -- yml = {'prettier'},
      -- }

      -- -- Do not lint or fix minified files.
      -- vim.g.ale_pattern_options = {
        -- ['build\\/.+\\.js$'] = {ale_linters = {}, ale_fixers = {}},
        -- ['es\\/.+\\.js$'] = {ale_linters = {}, ale_fixers = {}},
        -- ['lib\\/.+\\.js$'] = {ale_linters = {}, ale_fixers = {}},
        -- ['umd\\/.+\\.js$'] = {ale_linters = {}, ale_fixers = {}},
      -- }

      -- -- If you configure g:ale_pattern_options outside of vimrc, you need this.
      -- vim.g.ale_pattern_options_enabled = 1

      -- -- Set this variable to 1 to fix files when you save them.
      -- vim.g.ale_fix_on_save = 1

      -- -- Rust settings
      -- vim.g.ale_rust_cargo_use_clippy = 1
      -- vim.g.ale_rust_rustfmt_options = '--edition 2021'
    -- end
  -- }

  -- JSX
  -- Note: this requires additional_vim_regex_highlighting = true in treesitter
  use 'maxmellon/vim-jsx-pretty'

  -- Dashboard
  use {
    'goolord/alpha-nvim',
    config = function ()
        local startify = require('alpha.themes.startify')
        startify.nvim_web_devicons.enabled = false

        require('alpha').setup(startify.config)
    end
  }

  -- Help
  use {
    'folke/which-key.nvim',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 500
      require('which-key').setup({})
    end
  }

  if first_install then
    packer.sync()
  end
end)
