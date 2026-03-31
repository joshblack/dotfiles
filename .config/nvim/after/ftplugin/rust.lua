-- local bufnr = vim.api.nvim_get_current_buf()

-- local nmap = function(keys, func, desc)
-- if desc then
-- desc = 'LSP: ' .. desc
-- end
-- vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, silent = true })
-- end

-- nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
-- -- nmap('K', function()
-- -- vim.cmd.RustLsp({ 'hover' })
-- -- end, 'Hover documentation')
-- nmap('K', vim.lsp.buf.hover, 'Hover documentation')
-- nmap('gca', vim.lsp.buf.code_action, '[G]oto [C]ode [A]ctions')
-- nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
-- nmap('gD', vim.lsp.buf.type_definition, '[G]oto Type [D]efinition')
-- nmap('god', vim.diagnostic.open_float, '[G]oto [O]pen [D]iagnostics');
