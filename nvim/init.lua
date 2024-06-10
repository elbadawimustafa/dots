-- vi: set ft=lua ts=2 sw=2 expandtab :

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
                "clone",
                "--filter=blob:none",
        	"https://github.com/folke/lazy.nvim.git",
                "--branch=stable", -- latest stable release
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
	{
  		"folke/tokyonight.nvim",
  		lazy = false,
  		priority = 1000,
  		opts = {},
	}
}

require("lazy").setup(plugins)


vim.wo.number = true
vim.o.termguicolors = true
vim.o.background = 'dark'
vim.cmd [[ colorscheme tokyonight-night ]]
