-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/Users/joshblack/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/joshblack/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/joshblack/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/joshblack/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/joshblack/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  LuaSnip = {
    config = { "\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16jb.snippets\frequire\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/LuaSnip",
    url = "https://github.com/L3MON4D3/LuaSnip"
  },
  ale = {
    config = { "\27LJ\2\n©\a\0\0\4\0002\0a6\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\1\0005\1\4\0004\2\0\0=\2\5\0014\2\0\0=\2\6\0014\2\0\0=\2\a\0014\2\0\0=\2\b\1=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\t\0006\0\0\0009\0\1\0005\1\f\0005\2\v\0=\2\r\0014\2\0\0=\2\5\0015\2\14\0=\2\15\0015\2\16\0=\2\6\0015\2\17\0=\2\18\0015\2\19\0=\2\20\0015\2\21\0=\2\22\0015\2\23\0=\2\24\0015\2\25\0=\2\a\0015\2\26\0=\2\27\0015\2\28\0=\2\b\0015\2\29\0=\2\30\0015\2\31\0=\2 \0015\2!\0=\2\"\1=\1\n\0006\0\0\0009\0\1\0005\1%\0005\2$\0004\3\0\0=\3\3\0024\3\0\0=\3\n\2=\2&\0015\2'\0004\3\0\0=\3\3\0024\3\0\0=\3\n\2=\2(\0015\2)\0004\3\0\0=\3\3\0024\3\0\0=\3\n\2=\2*\0015\2+\0004\3\0\0=\3\3\0024\3\0\0=\3\n\2=\2,\1=\1#\0006\0\0\0009\0\1\0)\1\1\0=\1-\0006\0\0\0009\0\1\0)\1\1\0=\1.\0006\0\0\0009\0\1\0)\1\1\0=\1/\0006\0\0\0009\0\1\0'\0011\0=\0010\0K\0\1\0\19--edition 2018\29ale_rust_rustfmt_options\30ale_rust_cargo_use_clippy\20ale_fix_on_save ale_pattern_options_enabled\17umd\\/.+\\.js$\1\0\0\17lib\\/.+\\.js$\1\0\0\16es\\/.+\\.js$\1\0\0\19build\\/.+\\.js$\1\0\0\1\0\0\24ale_pattern_options\byml\1\2\0\0\rprettier\tyaml\1\2\0\0\rprettier\20typescriptreact\1\2\0\0\rprettier\1\2\0\0\rprettier\tscss\1\2\0\0\rprettier\1\2\0\0\frustfmt\bmdx\1\2\0\0\rprettier\rmarkdown\1\2\0\0\rprettier\njson5\1\2\0\0\rprettier\tjson\1\2\0\0\rprettier\1\2\0\0\rprettier\thtml\1\2\0\0\rprettier\bcss\1\0\0\1\2\0\0\rprettier\15ale_fixers\25ale_linters_explicit\15typescript\trust\15javascript\velixir\1\0\0\16ale_linters\27ale_completion_enabled\6g\bvim\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/ale",
    url = "https://github.com/dense-analysis/ale"
  },
  ["cmp-buffer"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/cmp-buffer",
    url = "https://github.com/hrsh7th/cmp-buffer"
  },
  ["cmp-nvim-lsp"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
    url = "https://github.com/hrsh7th/cmp-nvim-lsp"
  },
  ["cmp-nvim-lua"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/cmp-nvim-lua",
    url = "https://github.com/hrsh7th/cmp-nvim-lua"
  },
  ["cmp-path"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/cmp-path",
    url = "https://github.com/hrsh7th/cmp-path"
  },
  cmp_luasnip = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/cmp_luasnip",
    url = "https://github.com/saadparwaiz1/cmp_luasnip"
  },
  ["editorconfig-vim"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/editorconfig-vim",
    url = "https://github.com/editorconfig/editorconfig-vim"
  },
  ["emmet-vim"] = {
    config = { "\27LJ\2\nÅ\1\0\0\3\0\b\0\t6\0\0\0009\0\1\0005\1\4\0005\2\3\0=\2\5\0015\2\6\0=\2\a\1=\1\2\0K\0\1\0\20typescriptreact\1\0\1\fextends\bjsx\15javascript\1\0\0\1\0\1\fextends\bjsx\24user_emmet_settings\6g\bvim\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/emmet-vim",
    url = "https://github.com/mattn/emmet-vim"
  },
  fzf = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/fzf",
    url = "https://github.com/junegunn/fzf"
  },
  ["fzf.vim"] = {
    config = { "\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20jb.fuzzy-finder\frequire\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/fzf.vim",
    url = "https://github.com/junegunn/fzf.vim"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/gitsigns.nvim",
    url = "https://github.com/lewis6991/gitsigns.nvim"
  },
  ["impatient.nvim"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/impatient.nvim",
    url = "https://github.com/lewis6991/impatient.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/lspkind-nvim",
    url = "https://github.com/onsails/lspkind-nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18jb.statusline\frequire\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  nerdcommenter = {
    config = { "\27LJ\2\n1\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\20NERDSpaceDelims\6g\bvim\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/nerdcommenter",
    url = "https://github.com/preservim/nerdcommenter"
  },
  ["nvim-cmp"] = {
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18jb.completion\frequire\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/nvim-cmp",
    url = "https://github.com/hrsh7th/nvim-cmp"
  },
  ["nvim-lsp-installer"] = {
    config = { "\27LJ\2\n&\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\vjb.lsp\frequire\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
    url = "https://github.com/williamboman/nvim-lsp-installer"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  ["nvim-tree.lua"] = {
    config = { "\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21jb.file-explorer\frequire\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18jb.treesitter\frequire\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-refactor"
  },
  ["nvim-ts-context-commentstring"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/nvim-ts-context-commentstring",
    url = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["onenord.nvim"] = {
    config = { "\27LJ\2\n∑\1\0\0\4\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\0016\0\6\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0\24colorscheme onenord\bcmd\bvim\fitalics\1\0\5\rkeywords\1\fstrings\1\rcomments\2\14variables\1\14functions\1\1\0\1\fborders\2\nsetup\fonenord\frequire\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/onenord.nvim",
    url = "https://github.com/rmehri01/onenord.nvim"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["todo-comments.nvim"] = {
    config = { "\27LJ\2\nœ\1\0\0\5\0\14\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\0025\3\v\0005\4\n\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\vcolors\ttodo\1\0\0\1\2\0\0\tTodo\rkeywords\tTODO\1\0\0\1\0\1\ncolor\ttodo\14highlight\1\0\3\vbefore\5\nafter\5\fkeyword\afg\1\0\1\nsigns\1\nsetup\18todo-comments\frequire\0" },
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/todo-comments.nvim",
    url = "https://github.com/folke/todo-comments.nvim"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/vim-fugitive",
    url = "https://github.com/tpope/vim-fugitive"
  },
  ["vim-jsx-pretty"] = {
    loaded = true,
    path = "/Users/joshblack/.local/share/nvim/site/pack/packer/start/vim-jsx-pretty",
    url = "https://github.com/maxmellon/vim-jsx-pretty"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: nvim-cmp
time([[Config for nvim-cmp]], true)
try_loadstring("\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18jb.completion\frequire\0", "config", "nvim-cmp")
time([[Config for nvim-cmp]], false)
-- Config for: emmet-vim
time([[Config for emmet-vim]], true)
try_loadstring("\27LJ\2\nÅ\1\0\0\3\0\b\0\t6\0\0\0009\0\1\0005\1\4\0005\2\3\0=\2\5\0015\2\6\0=\2\a\1=\1\2\0K\0\1\0\20typescriptreact\1\0\1\fextends\bjsx\15javascript\1\0\0\1\0\1\fextends\bjsx\24user_emmet_settings\6g\bvim\0", "config", "emmet-vim")
time([[Config for emmet-vim]], false)
-- Config for: nvim-lsp-installer
time([[Config for nvim-lsp-installer]], true)
try_loadstring("\27LJ\2\n&\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\vjb.lsp\frequire\0", "config", "nvim-lsp-installer")
time([[Config for nvim-lsp-installer]], false)
-- Config for: nerdcommenter
time([[Config for nerdcommenter]], true)
try_loadstring("\27LJ\2\n1\0\0\2\0\3\0\0056\0\0\0009\0\1\0)\1\1\0=\1\2\0K\0\1\0\20NERDSpaceDelims\6g\bvim\0", "config", "nerdcommenter")
time([[Config for nerdcommenter]], false)
-- Config for: todo-comments.nvim
time([[Config for todo-comments.nvim]], true)
try_loadstring("\27LJ\2\nœ\1\0\0\5\0\14\0\0176\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\0025\3\a\0005\4\6\0=\4\b\3=\3\t\0025\3\v\0005\4\n\0=\4\f\3=\3\r\2B\0\2\1K\0\1\0\vcolors\ttodo\1\0\0\1\2\0\0\tTodo\rkeywords\tTODO\1\0\0\1\0\1\ncolor\ttodo\14highlight\1\0\3\vbefore\5\nafter\5\fkeyword\afg\1\0\1\nsigns\1\nsetup\18todo-comments\frequire\0", "config", "todo-comments.nvim")
time([[Config for todo-comments.nvim]], false)
-- Config for: lualine.nvim
time([[Config for lualine.nvim]], true)
try_loadstring("\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18jb.statusline\frequire\0", "config", "lualine.nvim")
time([[Config for lualine.nvim]], false)
-- Config for: LuaSnip
time([[Config for LuaSnip]], true)
try_loadstring("\27LJ\2\n+\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\16jb.snippets\frequire\0", "config", "LuaSnip")
time([[Config for LuaSnip]], false)
-- Config for: fzf.vim
time([[Config for fzf.vim]], true)
try_loadstring("\27LJ\2\n/\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\20jb.fuzzy-finder\frequire\0", "config", "fzf.vim")
time([[Config for fzf.vim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
try_loadstring("\27LJ\2\n0\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\21jb.file-explorer\frequire\0", "config", "nvim-tree.lua")
time([[Config for nvim-tree.lua]], false)
-- Config for: onenord.nvim
time([[Config for onenord.nvim]], true)
try_loadstring("\27LJ\2\n∑\1\0\0\4\0\t\0\r6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\4\0=\3\5\2B\0\2\0016\0\6\0009\0\a\0'\2\b\0B\0\2\1K\0\1\0\24colorscheme onenord\bcmd\bvim\fitalics\1\0\5\rkeywords\1\fstrings\1\rcomments\2\14variables\1\14functions\1\1\0\1\fborders\2\nsetup\fonenord\frequire\0", "config", "onenord.nvim")
time([[Config for onenord.nvim]], false)
-- Config for: ale
time([[Config for ale]], true)
try_loadstring("\27LJ\2\n©\a\0\0\4\0002\0a6\0\0\0009\0\1\0)\1\0\0=\1\2\0006\0\0\0009\0\1\0005\1\4\0004\2\0\0=\2\5\0014\2\0\0=\2\6\0014\2\0\0=\2\a\0014\2\0\0=\2\b\1=\1\3\0006\0\0\0009\0\1\0)\1\1\0=\1\t\0006\0\0\0009\0\1\0005\1\f\0005\2\v\0=\2\r\0014\2\0\0=\2\5\0015\2\14\0=\2\15\0015\2\16\0=\2\6\0015\2\17\0=\2\18\0015\2\19\0=\2\20\0015\2\21\0=\2\22\0015\2\23\0=\2\24\0015\2\25\0=\2\a\0015\2\26\0=\2\27\0015\2\28\0=\2\b\0015\2\29\0=\2\30\0015\2\31\0=\2 \0015\2!\0=\2\"\1=\1\n\0006\0\0\0009\0\1\0005\1%\0005\2$\0004\3\0\0=\3\3\0024\3\0\0=\3\n\2=\2&\0015\2'\0004\3\0\0=\3\3\0024\3\0\0=\3\n\2=\2(\0015\2)\0004\3\0\0=\3\3\0024\3\0\0=\3\n\2=\2*\0015\2+\0004\3\0\0=\3\3\0024\3\0\0=\3\n\2=\2,\1=\1#\0006\0\0\0009\0\1\0)\1\1\0=\1-\0006\0\0\0009\0\1\0)\1\1\0=\1.\0006\0\0\0009\0\1\0)\1\1\0=\1/\0006\0\0\0009\0\1\0'\0011\0=\0010\0K\0\1\0\19--edition 2018\29ale_rust_rustfmt_options\30ale_rust_cargo_use_clippy\20ale_fix_on_save ale_pattern_options_enabled\17umd\\/.+\\.js$\1\0\0\17lib\\/.+\\.js$\1\0\0\16es\\/.+\\.js$\1\0\0\19build\\/.+\\.js$\1\0\0\1\0\0\24ale_pattern_options\byml\1\2\0\0\rprettier\tyaml\1\2\0\0\rprettier\20typescriptreact\1\2\0\0\rprettier\1\2\0\0\rprettier\tscss\1\2\0\0\rprettier\1\2\0\0\frustfmt\bmdx\1\2\0\0\rprettier\rmarkdown\1\2\0\0\rprettier\njson5\1\2\0\0\rprettier\tjson\1\2\0\0\rprettier\1\2\0\0\rprettier\thtml\1\2\0\0\rprettier\bcss\1\0\0\1\2\0\0\rprettier\15ale_fixers\25ale_linters_explicit\15typescript\trust\15javascript\velixir\1\0\0\16ale_linters\27ale_completion_enabled\6g\bvim\0", "config", "ale")
time([[Config for ale]], false)
-- Config for: gitsigns.nvim
time([[Config for gitsigns.nvim]], true)
try_loadstring("\27LJ\2\n6\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
time([[Config for gitsigns.nvim]], false)
-- Config for: nvim-treesitter
time([[Config for nvim-treesitter]], true)
try_loadstring("\27LJ\2\n-\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\18jb.treesitter\frequire\0", "config", "nvim-treesitter")
time([[Config for nvim-treesitter]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  error_msg = error_msg:gsub('"', '\\"')
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
