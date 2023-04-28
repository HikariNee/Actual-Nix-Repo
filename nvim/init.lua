--vim.o.expandtab = true
--vim.o.shiftwidth = 2
--vim.o.tabstop = 2
vim.o.number = 'yes'
vim.o.signcolumn = 'yes'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({"git",   "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git","--branch=stable", lazypath,})
end

vim.opt.rtp:prepend(lazypath)

require("plugins")
require("config")
require('bindings')
require('treesitter')
require('tabby')
require('completion')
