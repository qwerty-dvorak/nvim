--[[
    HOW require() WORKS IN NEOVIM
    =============================

    Neovim has a special integration between Lua's require() and its runtimepath.

    1. AT STARTUP, Neovim adds your config's lua/ dir to Lua's module search path:
       package.path = ...your_config/lua/?.lua;...your_config/lua/?/init.lua;...
       This makes "require('core.constants')" find "lua/core/constants.lua"

    2. require() IS LUA'S STANDARD MODULE LOADER:
       - require("foo") searches for "foo.lua" or "foo/init.lua"
       - It caches loaded modules (calling require twice returns the same table)
       - It runs the file once and returns the result

    3. RUNTIMEPATH (rtp) INTEGRATION:
       - Neovim merges the runtimepath into package.path automatically
       - This means plugins can also be required by name
       - lazy.nvim is prepended to rtp so it can be found by require()
]]

-- Step 1: Add lazy.nvim to the runtimepath
-- This prepends lazy.nvim's path so Neovim can find its files.
-- After this, require("lazy") will find: ~/.local/share/nvim/lazy/lazy.nvim/lua/lazy.lua
vim.opt.rtp:prepend("/home/afish/.local/share/nvim/lazy/lazy.nvim")

-- Leader key: use space as the prefix for all leader mappings
vim.g.mapleader = " "

-- Step 2: Load our own modules (from lua/ directory)
-- require("core.constants") -> searches lua/core/constants.lua
-- The module returns a table with language configs (parsed, lsp, etc.)
local langs = require("core.constants")

-- Step 3: Initialize lazy.nvim plugin manager
-- require("lazy") finds lazy.nvim/lua/lazy.lua from the runtimepath
-- .setup() configures which plugins to load
require("lazy").setup({
    spec = {
        -- Each require returns a plugin spec (a table of plugin configs)
        -- Functions are called with language data to customize the plugins
        require("plugins.treesitter")(langs.parsed),
        require("plugins.mason")(langs.lsp),
        require("plugins.oil"),
        require("plugins.oil_git_status"),
        require("plugins.mini_pick"),
        require("plugins.gitsigns"),
        require("plugins.gitblame"),
        require("plugins.lualine"),
        require("plugins.opencode"),
        require("plugins.fugitive"),
        require("plugins.dap"),
        require("plugins.blink_cmp"),
    },
})

-- Step 4: Load autocommands
-- require("config.autocommands") -> lua/config/autocommands.lua
-- The module returns a function that we call with language data
require("config.autocommands")(langs.parsed)

--[[
    VIM.OPT SETTINGS
    ================
    vim.opt is Neovim's option setter (lua version of :set).
    These options control editor behavior.
]]

vim.opt.number = true             -- Show absolute line numbers
vim.opt.relativenumber = true     -- Show relative line numbers (for navigation)
vim.opt.tabstop = 4               -- Tab displays as 4 spaces
vim.opt.softtabstop = 4           -- Backspace deletes 4 spaces when using tabs
vim.opt.shiftwidth = 4            -- Autoindent uses 4 spaces
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
vim.opt.termguicolors = true      -- Enable true color support
vim.opt.scrolloff = 10            -- Keep 10 lines visible above/below cursor
vim.opt.sidescrolloff = 8         -- Keep 8 lines visible left/right when scrolling
vim.opt.wrap = false              -- Disable line wrapping (horizontal scroll instead)
vim.opt.ignorecase = true         -- Search is case-insensitive by default
vim.opt.smartcase = true          -- Case-sensitive if search contains uppercase
vim.opt.incsearch = true          -- Show search matches as you type
vim.opt.autoread = true           -- Auto-reload files changed outside Neovim
vim.opt.encoding = "UTF-8"        -- Use UTF-8 encoding

--[[
    KEYMAPS
    =======
    vim.keymap.set(mode, lhs, rhs, opts) creates keybindings.
    <leader> refers to vim.g.mapleader which we set to " " (space)
]]

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true } -- Don't recursive remap, suppress output

-- Split commands
keymap("n", "<leader>v", ":vsplit<CR>", opts) -- Vertical split
keymap("n", "<leader>b", ":split<CR>", opts)  -- Horizontal split
keymap("n", "<leader>q", ":close<CR>", opts)  -- Close current split

-- Window navigation (Ctrl + hjkl)
keymap("n", "<C-h>", "<C-w>h", opts) -- Move to left window
keymap("n", "<C-j>", "<C-w>j", opts) -- Move to bottom window
keymap("n", "<C-k>", "<C-w>k", opts) -- Move to top window
keymap("n", "<C-l>", "<C-w>l", opts) -- Move to right window

-- Window resize (Alt + hjkl)
keymap("n", "<A-h>", ":vertical resize -2<CR>", opts) -- Shrink width
keymap("n", "<A-l>", ":vertical resize +2<CR>", opts) -- Grow width
keymap("n", "<A-k>", ":resize +2<CR>", opts)          -- Grow height
keymap("n", "<A-j>", ":resize -2<CR>", opts)          -- Shrink height

-- Tab management
keymap("n", "<leader>tn", ":tabnew<CR>", opts)     -- [t]ab [n]ew
keymap("n", "<leader>tc", ":tabclose<CR>", opts)   -- [t]ab [c]lose
keymap("n", "<C-Tab>", ":tabnext<CR>", opts)       -- Cycle forward
keymap("n", "<C-S-Tab>", ":tabprevious<CR>", opts) -- Cycle backward

-- Terminal
keymap("n", "<leader>t", ":vsplit | terminal<CR>", opts) -- Terminal in vertical split

-- Jump list navigation
keymap("n", "<C-o>", "<C-o>", opts)           -- Jump back
keymap("n", "<C-i>", "<C-i>", opts)           -- Jump forward
keymap("n", "<leader>jl", ":jumps<CR>", opts) -- [j]ump [l]ist

-- Set colorscheme
vim.cmd.colorscheme "void_black"

--[[
    PLUGIN WORKFLOW
    ===============
    When adding a new plugin:
    1. Create a file under lua/plugins/ that returns the plugin spec.
    2. Register it in the lazy.nvim setup list above.
    3. Update nvim/keybinds.txt whenever you add or change mappings.
    4. Prefer documenting any new keybinds directly in the plugin spec with desc values.
]]
