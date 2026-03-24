# Neovim Configuration

A lightweight, modular Neovim setup using `lazy.nvim` for plugin management.

## Plugins

| Plugin | Description |
|--------|-------------|
| **nvim-treesitter** | Syntax highlighting, parsing, and folding |
| **mason.nvim** + **mason-lspconfig.nvim** | LSP server installation and management |
| **oil.nvim** | File explorer with native buffer editing |
| **oil-git-status.nvim** | Git status decorations in Oil |
| **mini.pick** | Fuzzy finder with files, grep, buffers, help |
| **gitsigns.nvim** | Git signs, hunk staging, and diff |
| **git-blame.nvim** | Inline git blame in lualine |
| **lualine.nvim** | Customizable statusline |
| **opencode.nvim** | AI-assisted editing and commands |
| **vim-fugitive** | Git commands (status, commit, push, etc.) |
| **nvim-dap** | Debug adapter protocol for debugging |

## Layout

```
.
├── init.lua                 # Startup entry point
├── lua/
│   ├── plugins/             # Plugin specs (lazy.nvim)
│   │   ├── treesitter.lua
│   │   ├── mason.lua
│   │   ├── oil.lua
│   │   ├── oil_git_status.lua
│   │   ├── mini_pick.lua
│   │   ├── gitsigns.lua
│   │   ├── gitblame.lua
│   │   ├── lualine.lua
│   │   ├── opencode.lua
│   │   ├── fugitive.lua
│   │   └── dap.lua
│   ├── config/              # Autocommands and config
│   │   ├── autocommands.lua
│   │   └── autocmds/
│   │       ├── lsp.lua
│   │       └── treesitter.lua
│   └── core/
│       └── constants.lua    # Language configurations
├── keybinds.txt             # Keybinding reference
└── README.md
```

## Requirements

- Neovim 0.9+
- `git`
- C compiler (for native plugin builds)
- `gdb` (for C debugging with DAP)

## Setup

1. Clone into `~/.config/nvim/`
2. Open Neovim
3. `lazy.nvim` installs plugins automatically

## Keybindings

See `keybinds.txt` for the complete reference.

## Workflow

When adding a plugin:

1. Create `lua/plugins/<name>.lua` returning the plugin spec
2. Register in `init.lua` under `require("lazy").setup(...)`
3. Add keymaps with `desc` values for discoverability
4. Update `keybinds.txt` with new bindings
