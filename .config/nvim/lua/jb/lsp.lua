local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

function default_on_attach(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
end

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {}
)
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = 'single',
})


local config = {}

-- Setup
require('nvim-lsp-installer').on_server_ready(function (server)
  local opts = {
    capabilities = capabilities,
    on_attach = default_on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  }

  if config[server.name] then
    opts = vim.tbl_deep_extend('force', opts, config[server.name])
  end

  server:setup(opts)

  vim.cmd [[ do User LspAttachBuffers ]]
end)
