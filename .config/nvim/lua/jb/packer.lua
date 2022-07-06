local present, packer = pcall(require, 'packer')
local first_install = false

if not present then
    print('Setting up package manager...')

    local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

    print(string.format('Cloning into the directory: %s', packer_path))

    vim.fn.delete(packer_path, 'rf')
    vim.fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        packer_path
    })

    vim.cmd('packadd packer.nvim')
    present, packer = pcall(require, 'packer')

    if present then
        print('packer.nvim installed successfully')
        first_install = true
    else
        error('Could not install packer.nvim')
    end
end

packer.init({
    display = {
        open_fn = function()
            return require('packer.util').float({ border = 'single' })
        end
    }
})

return {
    packer = packer,
    -- We use this to run packer.sync() if it's the first install
    first_install = first_install,
}