# Neovim Configuration

This repository contains my personal Neovim configuration, organized around `lazy.nvim` and a small set of focused plugin modules.

## Layout

- `init.lua` — startup entry point
- `lua/plugins/` — plugin specs
- `lua/config/` — autocommands and config helpers
- `lua/core/` — shared constants and core values
- `keybinds.txt` — human-readable keybinding reference

## Requirements

- Neovim 0.9+ recommended
- `git`
- A working C compiler if any plugins require native builds
- Optional language tooling depending on the plugins you use

## Setup

1. Clone this repository into your Neovim config directory.
2. Start Neovim.
3. `lazy.nvim` will install and manage the plugins automatically.

If you need to install plugins manually from inside Neovim, use the `:Lazy` interface.

## Adding a plugin

When adding a new plugin, follow this workflow:

1. Create a new file under `lua/plugins/` that returns the plugin spec.
2. Register that spec in `init.lua` inside the `require("lazy").setup(...)` plugin list.
3. Keep the plugin config small and consistent with the rest of the repo.
4. Prefer explicit `desc` values on keymaps so mappings are easy to discover.
5. Update `keybinds.txt` whenever you add, remove, or change key mappings.
6. Make sure any plugin-specific behavior is documented here if it affects setup or usage.

## Keybinding updates

`keybinds.txt` is the source of truth for user-facing mappings.

Whenever you change keymaps:

- add the new mappings
- remove stale mappings
- update descriptions when behavior changes
- keep sections grouped by feature or plugin

This helps avoid drift between the actual config and the reference document.

## Current plugin notes

A few examples of the current plugin style used in this repo:

- `nvim-treesitter` for parsing and syntax-related features
- `oil.nvim` for file browsing
- `oil-git-status.nvim` for Git status indicators inside Oil
- `mini.pick` for searching and picking
- `dap` for debugging
- `gitsigns.nvim` for Git hunks, blame, and diff actions
- `vim-fugitive` for Git workflows and commands
- `opencode.nvim` for AI-assisted editing and commands

## Plugin-specific notes

- `oil-git-status.nvim` depends on `oil.nvim` and augments the Oil file explorer with Git status information.
- `vim-fugitive` is a useful companion for Git commands outside the file explorer.
- `opencode.nvim` is configured with suggested keymaps for asking questions, selecting actions, toggling the UI, and interacting with selections or commands.
- If you add more `opencode.nvim` mappings, keep them documented in `keybinds.txt` so the reference stays accurate.

## Contributing changes

If you extend the config:

- match the existing formatting and naming style
- document any new bindings in `keybinds.txt`
- verify that new plugins do not conflict with existing shortcuts
- keep startup behavior predictable by loading only what you need at startup

## Notes

This repo is intentionally lightweight and opinionated. The goal is to keep the configuration readable, easy to edit, and easy to extend without losing track of keybindings or plugin responsibilities.