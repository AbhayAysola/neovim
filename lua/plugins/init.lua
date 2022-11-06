-- ensure packer is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'nvim-treesitter/nvim-treesitter'
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use "rafamadriz/friendly-snippets"
  use { 'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim' }
  use { 'nvim-lualine/lualine.nvim', requires = { 'kyazdani42/nvim-web-devicons', opt = true } }
  use "p00f/nvim-ts-rainbow"
  use "folke/which-key.nvim"
  use 'm4xshen/autoclose.nvim'
  use {
  'nvim-tree/nvim-tree.lua',
  requires = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
  tag = 'nightly' -- optional, updated every week. (see issue #1193)
}

  -- themes
  use 'folke/tokyonight.nvim'
  use "rebelot/kanagawa.nvim"
  use { 'Everblush/everblush.nvim', as = 'everblush' }
  use 'rmehri01/onenord.nvim'
  use "rafamadriz/neon"
  use 'kvrohit/mellow.nvim'
  use 'olivercederborg/poimandres.nvim'

  -- Automatically set up your configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

require('plugins.nvim-treesitter')
require('plugins.lsp')
require('plugins.lualine')
require('plugins.tree')
