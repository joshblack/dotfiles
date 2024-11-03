-- Plugins
return {
  -- Colorscheme
  {
    'rmehri01/onenord.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onenord').setup({
        theme = "dark",
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
  { import = 'jb.fuzzy-finder' },

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
  -- {
    -- 'lewis6991/gitsigns.nvim',
    -- config = function()
      -- require('gitsigns').setup()
    -- end,
  -- },

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
  -- 'tpope/vim-sleuth',
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    config = function()
      local slow_format_filetypes = {}

      require('conform').setup({
        formatters_by_ft = {
          css = { 'prettierd', 'prettier', stop_after_first = true },
          javascript = { 'prettierd', 'prettier', stop_after_first = true },
          javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
          typescript = { 'prettierd', 'prettier', stop_after_first = true },
          typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
          json = { 'prettierd', 'prettier', stop_after_first = true },
          markdown = { 'prettierd', 'prettier', stop_after_first = true },
          scss = { 'prettierd', 'prettier', stop_after_first = true },
          yaml = { 'prettierd', 'prettier', stop_after_first = true },
        },

        -- https://github.com/stevearc/conform.nvim/blob/master/doc/recipes.md#automatically-run-slow-formatters-async
        format_on_save = function(bufnr)
          if slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          local function on_format(err)
            if err and err:match('timeout$') then
              slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
          end

          return { timeout_ms = 200, lsp_fallback = true }, on_format
        end,

        format_after_save = function(bufnr)
          if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          return { lsp_fallback = true }
        end,
      })
    end,
  },

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
  -- {
    -- 'folke/which-key.nvim',
    -- config = function()
      -- vim.o.timeout = true
      -- vim.o.timeoutlen = 500
      -- require('which-key').setup({})
    -- end
  -- },

  -- Golang
  'fatih/vim-go',

  -- Testing
  -- {
    -- "nvim-neotest/neotest",
    -- dependencies = {
      -- "nvim-neotest/nvim-nio",
      -- "nvim-lua/plenary.nvim",
      -- "antoinemadec/FixCursorHold.nvim",
      -- "nvim-treesitter/nvim-treesitter",
      -- "nvim-neotest/neotest-jest"
    -- },
    -- config = function()
      -- require('neotest').setup({
        -- adapters = {
          -- require('neotest-jest')({
            -- jestCommand = "npm test --",
            -- jestConfigFile = function(file)
              -- if string.find(file, "/packages/") then
                -- return string.match(file, "(.-/[^/]+/)src") .. "jest.config.js"
              -- end

              -- return vim.fn.getcwd() .. "/jest.config.js"
            -- end,
            -- -- jest_test_discovery = false,
            -- cwd = function(file)
              -- if string.find(file, "/packages/") then
                -- return string.match(file, "(.-/[^/]+/)src")
              -- end
              -- return vim.fn.getcwd()
            -- end
          -- }),
        -- },
        -- -- discovery = {
          -- -- enabled = false,
        -- -- },
      -- })

      -- vim.api.nvim_set_keymap("n", "<leader>tw", "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>", {})
    -- end,
  -- }
}
