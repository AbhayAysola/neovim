vim.g.mapleader = ' '
require('options')
require('plugins')
require('mappings')
vim.cmd [[colorscheme oh-lucy-evening]]
-- folding using treesitter
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.cmd('autocmd FileType * exe "normal zR"')
