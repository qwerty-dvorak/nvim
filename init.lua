vim.opt.rtp:prepend("/home/afish/.local/share/nvim/lazy/lazy.nvim")
vim.g.mapleader = " "
local langs = require("core.constants")
require("lazy").setup({
    spec = {
        require("plugins.treesitter")(langs.parsed),
        require("plugins.mason")(langs.lsp),
        require("plugins.oil"),
    },
})
require("config.autocommands")(langs.parsed)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<leader>v", ":vsplit<CR>", opts)
keymap("n", "<leader>b", ":split<CR>", opts)
keymap("n", "<leader>q", ":close<CR>", opts)
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<A-h>", ":vertical resize -2<CR>", opts)
keymap("n", "<A-l>", ":vertical resize +2<CR>", opts)
keymap("n", "<A-k>", ":resize +2<CR>", opts)
keymap("n", "<A-j>", ":resize -2<CR>", opts)
keymap("n", "<leader>tn", ":tabnew<CR>", opts)     -- [t]ab [n]ew
keymap("n", "<leader>tc", ":tabclose<CR>", opts)   -- [t]ab [c]lose
keymap("n", "<C-Tab>", ":tabnext<CR>", opts)       -- Cycle forward
keymap("n", "<C-S-Tab>", ":tabprevious<CR>", opts) -- Cycle backward
vim.cmd.colorscheme "void_black"
