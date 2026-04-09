local modes = {
  ['n']      = {'NORMAL', 'StatuslineNormal'},
  ['no']     = {'N-PEND', 'StatuslineNormal'},
  ['i']      = {'INSERT', 'StatuslineInsert'},
  ['ic']     = {'INSERT', 'StatuslineInsert'},
  ['v']      = {'VISUAL', 'StatuslineVisual'},
  ['V']      = {'V-LINE', 'StatuslineVisual'},
  ['\22']    = {'V-BLOCK', 'StatuslineVisual'}, 
  ['R']      = {'REPLACE', 'StatuslineReplace'},
  ['c']      = {'COMMAND', 'StatuslineCmd'},
  ['t']      = {'TERMINAL', 'StatuslineTerminal'},
  ['nt']     = {'TERMINAL', 'StatuslineTerminal'},
}

local function get_git_branch()
  local cwd = vim.fn.getcwd()
  local git_dir = vim.fn.finddir(".git", cwd .. ";" .. vim.fn.stdpath("data"))
  if git_dir == "" then return "" end
  
  local head_file = vim.fn.fnamemodify(git_dir, ":p") .. "HEAD"
  local f = io.open(head_file, "r")
  if not f then return "" end
  
  local content = f:read("*all")
  f:close()
  
  local branch = content:match("ref: refs/heads/(.+)")
  if branch then
    branch = branch:gsub("%s+", "")
    return branch
  end
  
  local commit = content:match("([0-9a-f]+)")
  if commit and #commit == 40 then
    return commit:sub(1, 7)
  end
  
  return ""
end

local function get_git_status()
  local cwd = vim.fn.getcwd()
  local git_dir = vim.fn.finddir(".git", cwd .. ";" .. vim.fn.stdpath("data"))
  if git_dir == "" then return "", 0, 0, 0 end
  
  local git_root = vim.fn.fnamemodify(git_dir, ":p:h")
  
  local function run_git(cmd)
    local handle = io.popen("cd " .. vim.fn.shellescape(git_root) .. " && " .. cmd .. " 2>/dev/null")
    if not handle then return "" end
    local result = handle:read("*all")
    handle:close()
    return result:gsub("%s+$", "")
  end
  
  local branch = get_git_branch()
  if branch == "" then return "", 0, 0, 0 end
  
  local status = run_git("git status --porcelain")
  if status == "" then return branch, 0, 0, 0 end
  
  local modified = 0
  local added = 0
  local deleted = 0
  
  for line in status:gmatch("[^\r\n]+") do
    local stat = line:sub(1, 2)
    if stat:match("M") or stat:match(".") then modified = modified + 1 end
    if stat:match("A") then added = added + 1 end
    if stat:match("D") then deleted = deleted + 1 end
  end
  
  return branch, modified, added, deleted
end

function _G.get_statusline()
  local m = vim.api.nvim_get_mode().mode
  local mode_data = modes[m] or {'UNKNOWN', 'StatuslineNormal'}
  local mode_text = mode_data[1]
  local mode_hl   = mode_data[2]

  local reg = vim.fn.reg_recording()
  local recording = reg ~= "" and ("%#ErrorMsg#  REC @" .. reg .. "  ") or ""

  local search = ""
  if vim.v.hlsearch == 1 then
    local res = vim.fn.searchcount({maxcount = 999, timeout = 500})
    if res.total > 0 then
      search = string.format("  %d/%d  ", res.current, res.total)
    end
  end

  local branch, modified, added, deleted = get_git_status()
  local git_info = ""
  if branch ~= "" then
    git_info = "%#StatuslineGit#  " .. branch .. " "
    if modified > 0 then
      git_info = git_info .. "%#StatuslineGitMod#+" .. modified .. " "
    end
    if added > 0 then
      git_info = git_info .. "%#StatuslineGitAdd#+" .. added .. " "
    end
    if deleted > 0 then
      git_info = git_info .. "%#StatuslineGitDel#-" .. deleted .. " "
    end
  end

  local ft = vim.bo.filetype
  local ft_text = ft ~= "" and ("[" .. ft .. "]") or ""

  local file_encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or "utf-8"
  local fileformat = vim.bo.fileformat

  return table.concat({
    '%#' .. mode_hl .. '#',
    ' ' .. mode_text .. ' ',
    recording,
    '%#StatuslinePath#',
    git_info,
    '%f',
    '%m%r%h%w',
    '%=',
    ft_text,
    ' ',
    fileformat,
    ' ',
    file_encoding,
    search,
    '%#StatuslinePos#',
    ' %l:%c ',
    ' %p%% ',
  })
end

vim.cmd([[
  highlight StatuslineNormal   guibg=#5e81ac guifg=#2e3440 gui=bold
  highlight StatuslineInsert   guibg=#a3be8c guifg=#2e3440 gui=bold
  highlight StatuslineVisual   guibg=#b48ead guifg=#2e3440 gui=bold
  highlight StatuslineReplace  guibg=#bf616a guifg=#2e3440 gui=bold
  highlight StatuslineCmd      guibg=#ebcb8b guifg=#2e3440 gui=bold
  highlight StatuslineTerminal guibg=#88c0d0 guifg=#2e3440 gui=bold
  highlight StatuslinePath     guibg=#3b4252 guifg=#d8dee9
  highlight StatuslinePos      guibg=#4c566a guifg=#d8dee9
  highlight StatuslineGit     guibg=#81a1c1 guifg=#2e3440
  highlight StatuslineGitMod   guifg=#bf616a
  highlight StatuslineGitAdd   guifg=#a3be8c
  highlight StatuslineGitDel   guifg=#bf616a
]])

vim.opt.statusline = '%!v:lua.get_statusline()'
