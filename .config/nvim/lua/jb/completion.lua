-- Completion
local cmp = require('cmp')
local luasnip = require('luasnip')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup({
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'nvim_lua' },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = require('lspkind').cmp_format({
      mode = 'symbol',
      maxwidth = 50,
      menu = {
        buffer = "[buf]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[api]",
        path = "[path]",
        luasnip = "[snip]",
      },
      -- https://github.com/onsails/lspkind-nvim/issues/18#issuecomment-913205575
      symbol_map = {
        Class = '',
        Color = '☀',
        Constant = '𝜋',
        Constructor = '⬡',
        Enum = '∴',
        EnumMember = '∷',
        Event = '⊸',
        Field = '→',
        File = 'File',
        Folder = 'Folder',
        Function = 'ƒ',
        Interface = '',
        Keyword = '',
        Method = 'λ',
        Module = 'm',
        Operator = '≠',
        Property = '',
        Reference = '⊷',
        Snippet = '{}',
        Struct = '',
        Text = '#',
        TypeParameter = '×',
        Unit = '()',
        Variable = '≔',
      }
    }),
  },
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
  mapping = {
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ['<C-Space>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },

    ['<C-n>'] = cmp.mapping({
        c = function()
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            else
                vim.api.nvim_feedkeys(t('<Down>'), 'n', true)
            end
        end,
        i = function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            else
                fallback()
            end
        end
    }),
    ['<C-p>'] = cmp.mapping({
        c = function()
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            else
                vim.api.nvim_feedkeys(t('<Up>'), 'n', true)
            end
        end,
        i = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            else
                fallback()
            end
        end
    }),
  },
})
