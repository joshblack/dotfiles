## Guide

- Creating your `init.lua` file
- Setting up your package manager, we'll go with packer
  - [Optional] setup packer to download if not available
  - Setup packer to manage packer
- Might be helpful to namespace your lua imports under a `lua/<username>` directory, but it's totally not needed

```lua
require('jb.packer')
```

## Features

- File explorer with `nvim-tree`
- Completion with `nvim-cmp`
- LSP integration with `nvim-lspconfig` and `nvim-cmp`
- Statusline with `nvim-lualine`
- Snippets
- Syntax highlighting by `nvim-treesitter`
- File searching with `fzf`

### Setting up plugins

Now we can make a `lua/jb/plugins.lua` file and require that in `init.vim`

```lua
require('jb.plugins')
```

In this file, we'll import packer from our packer import and our first_install info. We'll also use this file to call `packer.startup` which will include all of our plugins.

```lua
local jb_packer = require('jb.packer')
local packer = jb_packer.packer;
local first_install = jb_packer.first_install;

return packer.startup(function(use)
  use 'wbthomason/packer.nvim'

  if first_install then
    packer.sync()
  end
end)
```

We'll include some initial plugins along with plugins for:

- Color scheme
- File navigation
- Completion
- LSP
- Statusline
- Treesitter
- Ctrl+p support (fzf)
- Snippets
- Tree sitter?

**Question:** do you want your config in the plugin file or in a separate file?

It depends, if you're trying stuff out it's helpful to separate it out but once you settle on something putting it in packer can be helpful but it really doesn't matter

#### LSP

It's up to you if you want to install the LSPs separately, we'll use an auto installer to make life simpler

```lua
-- LSP
use 'neovim/nvim-lspconfig'
use {
  'williamboman/nvim-lsp-installer',
  config = function()
    require('jb.lsp')
  end
}
```

#### Snippets

```lua
-- Snippets
use 'L3MON4D3/LuaSnip'
```

#### Completion

We'll use `nvim-cmp`

```lua
-- Completion
use 'hrsh7th/nvim-cmp'
use 'hrsh7th/cmp-buffer'
use 'hrsh7th/cmp-path'
use 'hrsh7th/cmp-nvim-lua'
use 'hrsh7th/cmp-nvim-lsp'
```


#### Ctrl p, Ctrl t

Powered by fzf

```lua
-- FZF
use { 'junegunn/fzf', run = './install --all' }
use { 'junegunn/fzf.vim' }
```

Another fantastic choice is telescope


### Others

Other plugins to consider

- https://github.com/ray-x/lsp_signature.nvim
- Performance
  - Start-up time
    - https://github.com/nathom/filetype.nvim

### Configuration

Where you put your settings, leader keys. put before plugins for mappings

```lua
require('jb.packer')
require('jb.config')
require('jb.plugins')
```

## Links & Resources

- NeoVim Lua Guide https://github.com/nanotee/nvim-lua-guide
- Plugins
  - https://github.com/rockerBOO/awesome-neovim
  - https://github.com/kyazdani42/nvim-tree.lua
  - Color scheme
    - https://github.com/rmehri01/onenord.nvim
    - https://github.com/ful1e5/onedark.nvim
    - https://github.com/projekt0n/github-nvim-theme
- Examples
  - https://github.com/mattleong/CosmicNvim
  - https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
  - https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/init.lua