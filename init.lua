vim.opt.runtimepath:prepend(vim.fn.stdpath("config"))
package.path = package.path .. ";" .. vim.fn.stdpath("config") .. "/?.lua;" .. vim.fn.stdpath("config") .. "/?/init.lua"

for _, p in ipairs({"node", "perl", "python3", "ruby"}) do vim.g["loaded_" .. p .. "_provider"] = 0 end

require("statusline")
require("util")
require("c")

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.autoread = true
vim.opt.showtabline = 2
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.mousemodel = "extend"
vim.opt.hlsearch = false
vim.opt.updatetime = 200
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.backspace = "indent,eol,start"
vim.opt.timeoutlen = 300

local k = vim.keymap.set

k("n", "<leader>v", ":vsplit<CR>")
k("n", "<leader>s", ":split<CR>")
k("n", "<leader>q", ":close<CR>")
k("n", "<C-h>", "<C-w>h")
k("n", "<C-j>", "<C-w>j")
k("n", "<C-k>", "<C-w>k")
k("n", "<C-l>", "<C-w>l")
k("n", "<A-h>", ":vertical resize -2<CR>")
k("n", "<A-l>", ":vertical resize +2<CR>")
k("n", "<A-k>", ":resize +2<CR>")
k("n", "<A-j>", ":resize -2<CR>")
k("n", "<leader>tn", ":tabnew<CR>")
k("n", "<leader>tc", ":tabclose<CR>")
k("n", "<leader>th", ":tabprevious<CR>")
k("n", "<leader>tl", ":tabnext<CR>")
k("n", "<leader>tf", ":tabfirst<CR>")
k("n", "<leader>to", ":tablast<CR>")
for i = 1, 5 do k("n", "<leader>" .. i, i .. "gt") end
k("n", "J", "mzJ`z")
k("n", "<leader>e", ":ToggleNetrwExplorer<CR>")
k("n", "<leader>t", ":vsplit | terminal<CR>")
k("n", "<leader>r", "!!$SHELL<CR>")
k("t", "<Esc>", [[<C-\><C-n>]])
k("t", "<C-h>", [[<C-\><C-n><C-w>h]])
k("t", "<C-j>", [[<C-\><C-n><C-w>j]])
k("t", "<C-k>", [[<C-\><C-n><C-w>k]])
k("t", "<C-l>", [[<C-\><C-n><C-w>l]])
k("n", "<leader>jl", ":jumps<CR>")
k("v", "<", "<gv")
k("v", ">", ">gv")
k("v", "J", ":m '>+1<CR>gv=gv")
k("v", "K", ":m '<-2<CR>gv=gv")
k("n", "n", "nzzzv")
k("n", "N", "Nzzzv")
k("n", "<leader>w", ":w<CR>")
k("n", "<leader>x", ":x<CR>")
k("n", "<Esc>", ":nohlsearch<CR>")
k("n", "<leader>so", ":so $MYVIMRC<CR>")
k("i", "<C-u>", "<C-g>u<C-u>")
k("i", "<C-w>", "<C-g>u<C-w>")
k("n", "Y", "y$")
k("n", "Q", "q")
k("n", "<C-a>", "gg<S-g>")
k("n", "<leader>cd", ":cd %:p:h | pwd<CR>")

vim.cmd.colorscheme "void_theme"
