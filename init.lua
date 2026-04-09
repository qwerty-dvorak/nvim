vim.opt.runtimepath:prepend(vim.fn.stdpath("config"))
package.path = package.path .. ";" .. vim.fn.stdpath("config") .. "/?.lua;" .. vim.fn.stdpath("config") .. "/?/init.lua"

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

require("statusline")
require("util")
require("c")
require("buffers")

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
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
vim.opt.encoding = "UTF-8"
vim.opt.showtabline = 2
vim.opt.cursorline = true
vim.opt.mouse = "a"
vim.opt.hlsearch = false
vim.opt.updatetime = 250
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.g.netrw_altv = 1
vim.g.netrw_alto = 0
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 20
vim.g.netrw_browse_split = 4
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore = "*.o,*.obj,*.bin,*.elf,*.so,*.exe"
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }

vim.opt.backspace = "indent,eol,start"
vim.opt.history = 100
vim.opt.undolevels = 1000
vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.opt.redrawtime = 1500
vim.opt.ttimeoutlen = 10
vim.opt.updatetime = 200

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>v", ":vsplit<CR>", { desc = "Vertical split" })
keymap("n", "<leader>s", ":split<CR>", { desc = "Horizontal split" })
keymap("n", "<leader>q", ":close<CR>", { desc = "Close current split" })

keymap("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Navigate to bottom window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Navigate to top window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })

keymap("n", "<A-h>", ":vertical resize -2<CR>", { desc = "Shrink window width" })
keymap("n", "<A-l>", ":vertical resize +2<CR>", { desc = "Grow window width" })
keymap("n", "<A-k>", ":resize +2<CR>", { desc = "Grow window height" })
keymap("n", "<A-j>", ":resize -2<CR>", { desc = "Shrink window height" })

keymap("n", "<leader>tn", ":tabnew<CR>", { desc = "New tab" })
keymap("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })
keymap("n", "<leader>th", ":tabprevious<CR>", { desc = "Previous tab" })
keymap("n", "<leader>tl", ":tabnext<CR>", { desc = "Next tab" })
keymap("n", "<leader>tf", ":tabfirst<CR>", { desc = "First tab" })
keymap("n", "<leader>to", ":tablast<CR>", { desc = "Last tab" })

for i = 1, 5 do
    keymap("n", "<leader>" .. i, i .. "gt", { desc = "Go to tab " .. i })
end

keymap("n", "J", "mzJ`z", { desc = "Join lines without moving cursor" })
keymap("n", "<leader>e", ":ToggleNetrwExplorer<CR>", { desc = "Toggle file explorer (20% left)" })

keymap("n", "<leader>t", ":vsplit | terminal<CR>", { desc = "Open terminal in vertical split" })
keymap("n", "<leader>r", "!!$SHELL<CR>", { desc = "Run current line in shell" })
keymap("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
keymap("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Navigate left from terminal" })
keymap("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Navigate down from terminal" })
keymap("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Navigate up from terminal" })
keymap("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Navigate right from terminal" })

keymap("n", "<leader>jl", ":jumps<CR>", { desc = "Show jump list" })

keymap("v", "<", "<gv", { desc = "Indent left and restore selection" })
keymap("v", ">", ">gv", { desc = "Indent right and restore selection" })

keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

keymap("n", "n", "nzzzv", { desc = "Next search result centered" })
keymap("n", "N", "Nzzzv", { desc = "Previous search result centered" })

keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>x", ":x<CR>", { desc = "Save and close" })

keymap("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlights" })

keymap("n", "<leader>so", ":source $MYVIMRC<CR>", { desc = "Reload vim config" })

keymap("i", "<C-u>", "<C-g>u<C-u>", { desc = "Delete to start of line (undo-friendly)" })
keymap("i", "<C-w>", "<C-g>u<C-w>", { desc = "Delete word (undo-friendly)" })

keymap("n", "Y", "y$", { desc = "Yank to end of line" })

keymap("n", "Q", "q", { desc = "Start recording macro" })

keymap("n", "<C-a>", "gg<S-g>", { desc = "Select all" })

keymap("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Change to current file directory" })

vim.cmd.colorscheme "void_theme"
