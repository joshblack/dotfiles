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

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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

      vim.lsp.enable('copilot')
      vim.lsp.inline_completion.enable()
      vim.keymap.set('i', '<C-.>', function()
        if not vim.lsp.inline_completion.get() then
          return "<C-.>"
        end
      end, {
        expr = true,
        desc = 'Accept the current inline completion',
      })

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

      -- vim.lsp.config('tsgo', {
      --   on_attach = on_attach,
      --   capabilities = capabilities,
      -- })
      -- vim.lsp.enable('tsgo')

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

      vim.diagnostic.config({
        virtual_text = true,
      })

      vim.api.nvim_create_autocmd("LspProgress", {
        callback = function(ev)
          -- ev.data.params.value contains the actual LSP payload
          local value = ev.data.params.value
          if not value then return end

          local status = "running"
          if value.kind == "end" then
            status = "success"
          end

          -- Send structured progress to Neovim's UI and terminal system
          vim.api.nvim_echo({}, false, {
            kind = "progress",
            title = ev.data.client_id and
            vim.lsp.get_client_by_id(ev.data.client_id).name or "LSP",
            status = status,
            percent = value.percentage,
            message = value.message or value.title,
          })
        end,
      })

      --   local pending_lsp_progress
      --
      --   local function echo_lsp_progress(data)
      --     local value = data.params.value
      --     local message = (value.message or 'done'):gsub('%s+', ' ')
      --     local title = value.title and value.title:gsub('%s+', ' ') or nil
      --
      --     vim.api.nvim_echo({ { message } }, false, {
      --       id = 'jb.lsp.progress',
      --       kind = 'progress',
      --       source = 'vim.lsp',
      --       title = title,
      --       status = value.kind ~= 'end' and 'running' or 'success',
      --       percent = value.percentage,
      --     })
      --   end
      --
      --   vim.api.nvim_create_autocmd('LspProgress', {
      --     callback = function(ev)
      --       -- The command line cannot be replaced while `/`, `:`, or `?` is active.
      --       if vim.fn.getcmdtype() ~= '' then
      --         pending_lsp_progress = ev.data
      --         return
      --       end
      --
      --       echo_lsp_progress(ev.data)
      --     end,
      --   })
      --
      --   vim.api.nvim_create_autocmd('CmdlineLeave', {
      --     callback = function()
      --       if not pending_lsp_progress then
      --         return
      --       end
      --
      --       local progress = pending_lsp_progress
      --       pending_lsp_progress = nil
      --       vim.schedule(function()
      --         echo_lsp_progress(progress)
      --       end)
      --     end,
      --   })
    end
  },
}
