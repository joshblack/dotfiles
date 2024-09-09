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
          'tsserver',
        },
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
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'single',
      })

      require('lspconfig').astro.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- require('lspconfig').cssls.setup({
        -- on_attach = on_attach,
        -- capabilities = capabilities,
      -- })

      require('lspconfig').gopls.setup({
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

      -- local format_sync_grp = vim.api.nvim_create_augroup("RustFormat", {})
      -- vim.api.nvim_create_autocmd("BufWritePre", {
        -- pattern = "*.rs",
        -- callback = function()
          -- vim.lsp.buf.format({ timeout_ms = 200 })
        -- end,
        -- group = format_sync_grp,
      -- })

      require('lspconfig').tailwindcss.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      require('lspconfig').ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end
  },
  -- {
    -- 'jose-elias-alvarez/null-ls.nvim',
    -- event = { 'BufReadPre', 'BufNewFile' },
    -- config = function()
      -- local null_ls = require('null-ls')
      -- local lsp_formatting = function(bufnr)
        -- vim.lsp.buf.format({
          -- filter = function(client)
            -- return client.name == 'null-ls'
          -- end,
          -- bufnr = bufnr,
        -- })
      -- end
      -- local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

      -- null_ls.setup({
        -- debug = true,
        -- sources = {
          -- -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md#diagnostic-config
          -- null_ls.builtins.diagnostics.eslint.with({
            -- diagnostic_config = {
              -- -- see :help vim.diagnostic.config()
              -- underline = false,
              -- virtual_text = false,
              -- signs = false,
              -- update_in_insert = false,
            -- },
            -- method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
          -- }),
          -- -- null_ls.builtins.formatting.prettierd.with({
            -- -- extra_filetypes = { "html", "json", "markdown", "yaml" }
          -- -- }),
        -- },
        -- on_attach = function(client, bufnr)
          -- -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
          -- if client.supports_method('textDocument/formatting') then
            -- vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            -- vim.api.nvim_create_autocmd('BufWritePre', {
              -- group = augroup,
              -- buffer = bufnr,
              -- callback = function()
                -- lsp_formatting(bufnr)
              -- end,
            -- })
          -- end
        -- end,
      -- })
    -- end
  -- },
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      require('fidget').setup({})
    end
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
