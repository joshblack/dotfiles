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
        enabled = true,
        sources = {
          gh_issue = {},
          gh_pr = {},
        },
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
  {
    'echasnovski/mini.ai',
    version = '*',
    opts = {},
  },

  -- LLMs
  -- {
  -- "olimorris/codecompanion.nvim",
  -- config = true,
  -- dependencies = {
  -- "nvim-lua/plenary.nvim",
  -- "nvim-treesitter/nvim-treesitter",
  -- "j-hui/fidget.nvim",
  -- },
  -- opts = {
  -- adapters = {
  -- copilot = function()
  -- return require("codecompanion.adapters").extend("copilot", {
  -- name = "custom-copilot",
  -- schema = {
  -- model = {
  -- default = "claude-sonnet-4",
  -- },
  -- },
  -- })
  -- end,
  -- },
  -- strategies = {
  -- chat = {
  -- adapter = "copilot"
  -- },
  -- inline = {
  -- adapter = "copilot"
  -- }
  -- }
  -- },
  -- keys = {
  -- { "<leader>ac", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "[A]I CodeCompanion [C]hat" },
  -- },
  -- init = function()
  -- -- Inspired by: https://github.com/jessevdp/personal.nvim/blob/568bc0754ccfc48bf7e20a39e42257cef18b535d/lua/plugins/codecompanion/fidget-spinner.lua
  -- local progress = require("fidget.progress")
  -- local handle = nil

  -- local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

  -- vim.api.nvim_create_autocmd({ "User" }, {
  -- pattern = "CodeCompanionRequest*",
  -- group = group,
  -- callback = function(request)
  -- if request.match == "CodeCompanionRequestStarted" then
  -- handle = progress.handle.create({
  -- title = " Requesting assistance",
  -- -- https://codecompanion.olimorris.dev/usage/events.html#event-data
  -- lsp_client = {
  -- name = request.data.adapter.formatted_name ..
  -- " (" .. request.data.adapter.model .. ")",
  -- },
  -- })
  -- elseif request.match == "CodeCompanionRequestFinished" then
  -- if handle then
  -- handle:finish()
  -- end
  -- end
  -- end,
  -- })
  -- end,
  -- },
  {
    "folke/sidekick.nvim",
    opts = {
      cli = {},
      nes = {
        enabled = false,
      },
    },
    keys = {
      {
        "<c-.>",
        function() require("sidekick.cli").toggle() end,
        desc = "Sidekick Toggle",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "copilot" }) end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        -- Or to select only installed tools:
        -- require("sidekick.cli").select({ filter = { installed = true } })
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
    },
  },


  -- {
  -- 'echasnovski/mini.surround',
  -- version = '*',
  -- },

  -- {
  -- "folke/which-key.nvim",
  -- event = "VeryLazy",
  -- opts = {},
  -- keys = {
  -- {
  -- "<leader>?",
  -- function()
  -- require("which-key").show({ global = false })
  -- end,
  -- desc = "Buffer Local Keymaps (which-key)",
  -- },
  -- },
  -- },
}
