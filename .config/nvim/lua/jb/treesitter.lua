return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    config = function()
      require('nvim-treesitter').install({
        'astro',
        'css',
        'dockerfile',
        'elixir',
        'go',
        'gomod',
        'graphql',
        'hcl',
        'html',
        'javascript',
        'jsdoc',
        'json',
        'json5',
        'lua',
        'markdown',
        'markdown_inline',
        'prisma',
        'rust',
        'scss',
        'terraform',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      })

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { '*' },
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)

          if not lang then
            return
          end

          if not vim.treesitter.language.add(lang) then
            local available = vim.g.ts_available
                or require("nvim-treesitter").get_available()
            if not vim.g.ts_available then
              vim.g.ts_available = available
            end
            if vim.tbl_contains(available, lang) then
              require("nvim-treesitter").install(lang)
            end
          end

          if vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo[0][0].foldmethod = "expr"
          end
        end,
      })
    end,
  },
  {
    'folke/ts-comments.nvim',
    opts = {},
    lazy = false,
    enabled = vim.fn.has("nvim-0.10.0") == 1,
  },
}
