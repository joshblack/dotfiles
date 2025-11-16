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
          'rust_analyzer',
          'tailwindcss',
          'ts_ls',
        },
        automatic_enable = false,
      })

      local capabilities = require('cmp_nvim_lsp').default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      function on_attach(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {}
      )

      vim.lsp.config('astro', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('astro')

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
      })
      vim.lsp.enable('lua_ls')

      vim.lsp.config('tailwindcss', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('tailwindcss')

      vim.lsp.config('ts_ls', {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable('ts_ls')

      vim.lsp.config('rust_analyzer', {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {},
        },
      })
      vim.lsp.enable('rust_analyzer')

      vim.diagnostic.config({
        virtual_text = true,
        -- virtual_lines = true
      })


      vim.lsp.config('emmet_language_server', {
        filetypes = { "css", "html", "javascript", "javascriptreact", "scss", "typescriptreact" },
        -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
        -- **Note:** only the options listed in the table are supported.
        init_options = {
          ---@type table<string, string>
          includeLanguages = {},
          --- @type string[]
          excludeLanguages = {},
          --- @type string[]
          extensionsPath = {},
          --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
          preferences = {},
          --- @type boolean Defaults to `true`
          showAbbreviationSuggestions = true,
          --- @type "always" | "never" Defaults to `"always"`
          showExpandedAbbreviation = "always",
          --- @type boolean Defaults to `false`
          showSuggestionsAsSnippets = false,
          --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
          syntaxProfiles = {},
          --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
          variables = {},
        },
        -- on_attach = on_attach,
        -- capabilities = capabilities,
        -- filetypes = { 'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue' },
      })
      vim.lsp.enable('emmet_language_server')
    end
  },
  {
    'j-hui/fidget.nvim',
    opts = {},
  },
  {
    'folke/trouble.nvim',
    config = function()
      require('trouble').setup({
        icons = true,
        indent_lines = false,
        use_diagnostic_signs = true
      })
    end
  },
  -- {
  -- 'simrat39/symbols-outline.nvim',
  -- config = function()
  -- require('symbols-outline').setup({
  -- keymaps = {
  -- wrap = true,
  -- },
  -- })
  -- end
  -- }
}
