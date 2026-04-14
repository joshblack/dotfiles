-- Plugins
return {
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = 'moon',
        styles = {
          keywords = {
            italic = false,
          },
        },
      })
      vim.cmd [[colorscheme tokyonight]]
    end,
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
    'nvim-mini/mini.comment',
    version = false,
    opts = {
      mappings = {
        comment_line = '<leader>c<Space>',
        comment_visual = '<leader>c<Space>',
      },
    },
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
          todo = { 'Todo' },
        },
      })
    end
  },

  -- JSX
  -- Note: this requires additional_vim_regex_highlighting = true in treesitter
  'maxmellon/vim-jsx-pretty',

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = {
        enabled = true,
        notify = true,
      },
      gh = {
        enabled = true,
      },
      indent = {
        enabled = false,
        -- your indent configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      lazygit = {
        enabled = true,
      },
      notifier = {
        enabled = false,
      },
      picker = {
        enabled = false,
        sources = {
          gh_issue = {},
          gh_pr = {},
        },
        ui_select = true,
      },
      quickfile = {
        enabled = false,
      },
      statuscolumn = {
        enabled = false,
      },
      words = {
        enabled = false,
      },
      dashboard = {
        enabled = false,
        -- sections = {
        -- { section = "header" },
        -- { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
        -- { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        -- { section = "startup" },
        -- },
      },
    },
    keys = {
      {
        "<leader>lg",
        function() Snacks.lazygit() end,
        desc = "LazyGit (snacks.nvim)",
      },
      { "<leader>gi", function() Snacks.picker.gh_issue() end,                  desc = "GitHub Issues (open)" },
      { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      { "<leader>gp", function() Snacks.picker.gh_pr() end,                     desc = "GitHub Pull Requests (open)" },
      { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end,    desc = "GitHub Pull Requests (all)" },
    },
  },

  -- Startup screen
  {
    'goolord/alpha-nvim',
    config = function()
      local startify = require('alpha.themes.startify')
      require('alpha').setup(startify.config)
    end
  },

  -- Golang
  'fatih/vim-go',

  -- Text editing
  -- {
  --   'echasnovski/mini.ai',
  --   version = '*',
  --   opts = {},
  -- },

}
