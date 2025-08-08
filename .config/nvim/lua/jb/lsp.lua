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

      require('lspconfig').astro.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require('lspconfig').cssls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require('lspconfig').gopls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require('lspconfig').lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require('lspconfig').tailwindcss.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require('lspconfig').ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require('lspconfig').rust_analyzer.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {},
        },
      })

      vim.diagnostic.config({
        virtual_text = true,
        -- virtual_lines = true
      })
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
  {
    'simrat39/symbols-outline.nvim',
    config = function()
      require('symbols-outline').setup({
        keymaps = {
          wrap = true,
        },
      })
    end
  }
}
