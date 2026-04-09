local filetypes = { "go", "gomod" }
local known_filetypes = vim.fn.getcompletion("", "filetype")

if vim.list_contains(known_filetypes, "gowork") then
  table.insert(filetypes, "gowork")
end

if vim.list_contains(known_filetypes, "gotmpl") then
  table.insert(filetypes, "gotmpl")
end

return {
  cmd = { "gopls" },
  filetypes = filetypes,
  root_markers = { "go.work", "go.mod", ".git" },
  settings = {
    gopls = {
      analyses = { unusedparams = true },
      staticcheck = true,
      gofumpt = true,
    },
  },
}
