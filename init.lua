-- ~/.config/nvim/init.lua

vim.opt.rtp:prepend("/home/afish/.local/share/nvim/lazy/lazy.nvim")
vim.g.mapleader = " "

local langs = require("core.constants")

require("lazy").setup({
	spec = {
		require("plugins.treesitter")(langs.parsed),
		require("plugins.mason")(langs.lsp),
	},
})

require("config.autocommands")(langs.parsed)

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"

vim.cmd.colorscheme "void_black"
