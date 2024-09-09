local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = 'jb.plugins' },
  },
  defaults = {
    version = false,
  },
  checker = {
    enabled = true,
  },
  install = {
    colorscheme = {'onenord', 'habamax'},
    missing = true,
  },
})
