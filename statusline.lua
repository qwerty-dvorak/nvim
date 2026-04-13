local modes = {
  n  = {"NORMAL", "StatuslineNormal"},
  no = {"N-PEND", "StatuslineNormal"},
  i  = {"INSERT", "StatuslineInsert"},
  v  = {"VISUAL", "StatuslineVisual"},
  V  = {"V-LINE", "StatuslineVisual"},
  ["\22"] = {"V-BLOCK", "StatuslineVisual"},
  R  = {"REPLACE", "StatuslineReplace"},
  c  = {"COMMAND", "StatuslineCmd"},
  t  = {"TERMINAL", "StatuslineTerminal"},
}

local function git_info()
  local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD 2>/dev/null")[1] or ""
  if branch == "" then return "" end

  local status = vim.fn.systemlist("git status --porcelain 2>/dev/null")
  if #status == 0 then return branch end

  local m, a, d = 0, 0, 0
  for _, s in ipairs(status) do
    local x, y = s:sub(1, 1), s:sub(2, 2)
    if x == "M" or y == "M" then m = m + 1 end
    if x == "A" then a = a + 1 end
    if x == "D" then d = d + 1 end
  end

  return string.format("%s %s%s%s", branch,
    m > 0 and ("+%d "):format(m) or "",
    a > 0 and ("+%d "):format(a) or "",
    d > 0 and ("-%d "):format(d) or "")
end

function _G.get_statusline()
  local mode = modes[vim.api.nvim_get_mode().mode] or {"UNKNOWN", "StatuslineNormal"}
  local rec = vim.fn.reg_recording()
  local hlsearch = vim.v.hlsearch == 1

  return table.concat({
    "%#", mode[2], "# ", mode[1], " ",
    rec ~= "" and ("%#ErrorMsg#  REC @" .. rec .. "  ") or "",
    "%#StatuslinePath#",
    git_info() ~= "" and ("%#StatuslineGit# " .. git_info() .. " ") or "",
    "%f",
    "%m%r%h%w",
    "%=",
    vim.bo.filetype ~= "" and ("[" .. vim.bo.filetype .. "]") or "",
    " ", vim.bo.fileformat, " ",
    vim.bo.fileencoding ~= "" and vim.bo.fileencoding or "utf-8",
    hlsearch and ("  %d/%d  "):format(vim.fn.searchcount({maxcount = 999, timeout = 500}).current,
      vim.fn.searchcount({maxcount = 999, timeout = 500}).total) or "",
    "%#StatuslinePos# %l:%c %p%% ",
  })
end

vim.cmd([[
  highlight StatuslineNormal   guibg=#5e81ac guifg=#2e3440 gui=bold
  highlight StatuslineInsert guibg=#a3be8c guifg=#2e3440 gui=bold
  highlight StatuslineVisual  guibg=#b48ead guifg=#2e3440 gui=bold
  highlight StatuslineReplace guibg=#bf616a guifg=#2e3440 gui=bold
  highlight StatuslineCmd     guibg=#ebcb8b guifg=#2e3440 gui=bold
  highlight StatuslineTerminal guibg=#88c0d0 guifg=#2e3440 gui=bold
  highlight StatuslinePath    guibg=#3b4252 guifg=#d8dee9
  highlight StatuslinePos    guibg=#4c566a guifg=#d8dee9
  highlight StatuslineGit     guibg=#81a1c1 guifg=#2e3440
  highlight StatuslineGitMod guifg=#bf616a
  highlight StatuslineGitAdd guifg=#a3be8c
  highlight StatuslineGitDel guifg=#bf616a
]])

vim.opt.statusline = '%!v:lua.get_statusline()'
