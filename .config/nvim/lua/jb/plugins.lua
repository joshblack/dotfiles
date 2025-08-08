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
  -- {
  -- 'rmehri01/onenord.nvim',
  -- lazy = false,
  -- priority = 1000,
  -- config = function()
  -- require('onenord').setup({
  -- theme = "dark",
  -- borders = true,
  -- italics = {
  -- comments = true,
  -- strings = false,
  -- keywords = false,
  -- functions = false,
  -- variables = false,
  -- },
  -- })
  -- vim.cmd.colorscheme('onenord')
  -- end
  -- },

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

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = {
        enabled = false,
      },
      indent = {
        enabled = false,
        -- your indent configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      notifier = {
        enabled = false,
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

  -- Lazygit
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },

  -- Text editing
  {
    'echasnovski/mini.ai',
    version = '*',
    opts = {},
  },

  -- Notes
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "default",
          path = "~/obsidian/jb"
        },
      },
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },

        -- Toggle check-boxes.
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },

        -- Smart action depending on context, either follow link or toggle checkbox.
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        }
      },
    },
  },

  -- LLMs
  {
    "olimorris/codecompanion.nvim",
    config = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim",
    },
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            name = "custom-copilot",
            schema = {
              model = {
                default = "claude-sonnet-4",
              },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "copilot"
        },
        inline = {
          adapter = "copilot"
        }
      }
    },
    keys = {
      { "<leader>ac", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "[A]I CodeCompanion [C]hat" },
    },
    init = function()
      -- Inspired by: https://github.com/jessevdp/personal.nvim/blob/568bc0754ccfc48bf7e20a39e42257cef18b535d/lua/plugins/codecompanion/fidget-spinner.lua
      local progress = require("fidget.progress")
      local handle = nil

      local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequest*",
        group = group,
        callback = function(request)
          if request.match == "CodeCompanionRequestStarted" then
            handle = progress.handle.create({
              title = " Requesting assistance",
              -- https://codecompanion.olimorris.dev/usage/events.html#event-data
              lsp_client = {
                name = request.data.adapter.formatted_name ..
                    " (" .. request.data.adapter.model .. ")",
              },
            })
          elseif request.match == "CodeCompanionRequestFinished" then
            if handle then
              handle:finish()
            end
          end
        end,
      })
    end,
  },

  {
    'echasnovski/mini.surround',
    version = '*',
  },

  -- UI
  -- {
  -- 'folke/noice.nvim',
  -- event = "VeryLazy",
  -- opts = {
  -- lsp = {
  -- override = {
  -- ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  -- ["vim.lsp.util.stylize_markdown"] = true,
  -- ["cmp.entry.get_documentation"] = true,
  -- },
  -- },
  -- },
  -- config = function(_, opts)
  -- -- HACK: noice shows messages from before it was enabled,
  -- -- but this is not ideal when Lazy is installing plugins,
  -- -- so clear the messages in this case.
  -- if vim.o.filetype == "lazy" then
  -- vim.cmd([[messages clear]])
  -- end
  -- require("noice").setup(opts)
  -- end,
  -- },
  -- {
  -- "nvchad/volt",
  -- lazy = true,
  -- },
  -- {
  -- "nvchad/menu",
  -- lazy = true,
  -- config = function()
  -- -- Keyboard users
  -- -- vim.keymap.set("n", "<C-t>", function()
  -- -- require("menu").open("default")
  -- -- end, {})

  -- -- -- mouse users + nvimtree users!
  -- -- vim.keymap.set("n", "<RightMouse>", function()
  -- -- vim.cmd.exec '"normal! \\<RightMouse>"'

  -- -- local options = vim.bo.ft == "NvimTree" and "nvimtree" or "default"
  -- -- require("menu").open(options, { mouse = true })
  -- -- end, {})
  -- end
  -- },
}
