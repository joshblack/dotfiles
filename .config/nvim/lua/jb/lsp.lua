return {
  'neovim/nvim-lspconfig',
  {
    'williamboman/mason.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'onsails/lspkind-nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Setup
      require('mason').setup()

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

      vim.lsp.config('cssls', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('cssls')

      vim.lsp.config('gopls', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('gopls')

      vim.lsp.config('lua_ls', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
            },
          },
        },
      })
      vim.lsp.enable('lua_ls')

      vim.lsp.config('tailwindcss', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('tailwindcss')

      vim.lsp.config('terraformls', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('terraformls')

      vim.lsp.config('ts_ls', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('ts_ls')

      vim.lsp.config('rust_analyzer', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            -- semanticHighlighting = {},
            -- diagnostics = { enable = false },
            -- checkOnSave = { enable = false },
          },
        },
      })
      vim.lsp.enable('rust_analyzer')

      vim.lsp.config('emmet_language_server', {
        on_attach = on_attach,
        capabilities = capabilities,
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
      })
      vim.lsp.enable('emmet_language_server')

      -- for _, lsp in ipairs(lsp_configs) do
      --   local name = lsp[1]
      --   local config = vim.tbl_extend('force', {
      --     on_attach = on_attach,
      --     capabilities = capabilities,
      --   }, lsp[2] or {})
      --   vim.lsp.config(name, config)
      --   vim.lsp.enable(name)
      -- end

      vim.diagnostic.config({
        virtual_text = true,
        -- virtual_lines = true
      })

      -- vim.api.nvim_create_autocmd('LspProgress', {
      --   callback = function(ev)
      --     local value = ev.data.params.value
      --     vim.api.nvim_echo({ { value.message or 'done' } }, false, {
      --       id = 'lsp.' .. ev.data.client_id,
      --       kind = 'progress',
      --       source = 'vim.lsp',
      --       title = value.title,
      --       status = value.kind ~= 'end' and 'running' or 'success',
      --       percent = value.percentage,
      --     })
      --   end,
      -- })
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
