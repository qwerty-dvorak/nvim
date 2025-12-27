return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  -- Look for Neovim config markers or git
  root_markers = { ".luarc.json", ".luarc.jsonc", "init.lua", ".git" },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}
