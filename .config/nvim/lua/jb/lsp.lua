-- Setup
require('mason').setup()
require('mason-lspconfig').setup()

local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

local lsp_formatting = function(bufnr)
    vim.lsp.buf.format({
        filter = function(client)
            return client.name == 'null-ls'
        end,
        bufnr = bufnr,
    })
end
local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

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

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        lsp_formatting(bufnr)
      end,
    })
  end
end

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {}
)
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'single',
})

require('lspconfig').cssls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require('lspconfig').elixirls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require('lspconfig').jsonls.setup({
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

require('lspconfig').tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

require('lspconfig').yamlls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})
