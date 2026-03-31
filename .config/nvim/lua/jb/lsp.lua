return {
  'neovim/nvim-lspconfig',
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'onsails/lspkind-nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Setup
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'cssls',
          'tailwindcss',
          'ts_ls',
        },
        automatic_enable = false,
      })

      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false
      -- capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Experiment to see if this helps with editor locking when using clippy
      -- @see https://github.com/neovim/neovim/issues/23291
      -- @see https://github.com/neovim/neovim/issues/24325
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      vim.tbl_extend('force', capabilities,
        require('cmp_nvim_lsp').default_capabilities())
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      function on_attach(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc',
          { buf = bufnr })

        -- Mappings.
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        -- See `:help vim.lsp.*` for documentation on any of the below functions
        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('K', vim.lsp.buf.hover, 'Hover documentation')
        nmap('gca', vim.lsp.buf.code_action, '[G]oto [C]ode [A]ctions')
        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gD', vim.lsp.buf.type_definition, '[G]oto Type [D]efinition')
        nmap('god', vim.diagnostic.open_float, '[G]oto [O]pen [D]iagnostics');
      end

      local lsp_configs = {
        { 'astro' },
        { 'cssls' },
        { 'gopls' },
        {
          'lua_ls',
          {
            settings = {
              Lua = {
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                },
              },
            },
          },
        },
        { 'tailwindcss' },
        -- { 'tsgo' },
        { 'ts_ls' },
        -- {
        -- 'bacon_ls',
        -- {
        -- init_options = {
        -- updateOnSave = true,
        -- -- updateOnSaveWaitMillis = 1000
        -- }
        -- }
        -- },
        {
          'rust_analyzer',
          {
            settings = {
              ["rust-analyzer"] = {
                -- semanticHighlighting = {},
                -- diagnostics = { enable = false },
                -- checkOnSave = { enable = false },
              },
            },
          },
        },
        {
          'emmet_language_server',
          {
            filetypes = { "css", "html", "javascript", "javascriptreact", "scss", "typescriptreact" },
            init_options = {
              includeLanguages = {},
              excludeLanguages = {},
              extensionsPath = {},
              preferences = {},
              showAbbreviationSuggestions = true,
              showExpandedAbbreviation = "always",
              showSuggestionsAsSnippets = false,
              syntaxProfiles = {},
              variables = {},
            },
          },
        },
      }

      for _, lsp in ipairs(lsp_configs) do
        local name = lsp[1]
        local config = vim.tbl_extend('force', {
          on_attach = on_attach,
          capabilities = capabilities,
        }, lsp[2] or {})
        vim.lsp.config(name, config)
        vim.lsp.enable(name)
      end

      vim.diagnostic.config({
        virtual_text = true,
        -- virtual_lines = true
      })
    end
  },
  -- {
  -- 'mrcjkb/rustaceanvim',
  -- lazy = false,
  -- },
  {
    'j-hui/fidget.nvim',
    opts = {
      -- progress = {
      -- suppress_on_insert = true
      -- },
    },
  },
  -- {
  -- 'folke/trouble.nvim',
  -- config = function()
  -- require('trouble').setup({
  -- icons = true,
  -- indent_lines = false,
  -- use_diagnostic_signs = true
  -- })
  -- end
  -- },
}
