local function find_netrw_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "netrw" then
      return win
    end
  end
end

local function setup_netrw_layout()
  local netrw_win = find_netrw_win()
  if not netrw_win then
    return
  end

  if vim.fn.winnr("$") == 1 then
    vim.cmd("rightbelow vnew")
    vim.cmd("wincmd h")
    netrw_win = vim.api.nvim_get_current_win()
  end

  local current_win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(netrw_win)
  vim.cmd("wincmd H")
  vim.api.nvim_win_set_width(netrw_win, math.max(20, math.floor(vim.o.columns * 0.20 + 0.5)))

  if vim.api.nvim_win_is_valid(current_win) then
    vim.api.nvim_set_current_win(current_win)
  end
end

local function schedule_netrw_layout()
  vim.schedule(setup_netrw_layout)
end

local function toggle_netrw_explorer()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local netrw_win = find_netrw_win()

  if netrw_win then
    if #wins > 1 then
      vim.api.nvim_win_close(netrw_win, true)
    end
    return
  end

  vim.cmd("Lexplore 20")
  schedule_netrw_layout()
end

vim.api.nvim_create_user_command("ToggleNetrwExplorer", toggle_netrw_explorer, {
  desc = "Toggle left netrw explorer",
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  desc = "Configure netrw window",
  callback = function()
    vim.keymap.set("n", "<C-l>", "<C-w>l", {
      buffer = true,
      noremap = true,
      silent = true,
      desc = "Navigate to right window",
    })
    schedule_netrw_layout()
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
  pattern = "*",
  desc = "Keep netrw on left at 20% width",
  callback = function()
    schedule_netrw_layout()
  end,
})

vim.api.nvim_create_autocmd("VimEnter", {
  desc = "Apply netrw layout immediately on startup",
  callback = function()
    schedule_netrw_layout()
  end,
})

local number_group = vim.api.nvim_create_augroup("numbertoggle", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    pattern = "*",
    group = number_group,
    desc = "Enable relative line numbers",
    callback = function()
        if vim.opt.number:get() and vim.api.nvim_get_mode().mode ~= "i" then
            vim.opt.relativenumber = true
        end
    end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
    pattern = "*",
    group = number_group,
    desc = "Disable relative line numbers",
    callback = function()
        if vim.opt.number:get() then
            vim.opt.relativenumber = false
        end
    end,
})

vim.opt.undofile = true
local undodir = vim.fn.expand("~/.config/nvim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_mkdir", { clear = true }),
  desc = "Create parent directories on save",
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  desc = "Disable auto-comment continuation",
  callback = function()
    vim.opt_local.formatoptions:remove({ 'r', 'o' })
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Restore last cursor position",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  group = vim.api.nvim_create_augroup("remove_trailing_whitespace", { clear = true }),
  desc = "Remove trailing whitespace on save",
  callback = function()
    local save_cursor = vim.fn.getcurpos()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "diff",
  desc = "Enable scrollbind in diff mode",
  callback = function()
    vim.opt_local.scrollbind = true
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "qf",
  desc = "Hide line numbers in quickfix window",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  desc = "Equalize window sizes on resize",
  callback = function()
    vim.cmd("wincmd =")
    schedule_netrw_layout()
  end,
})

vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  desc = "Auto-write buffers when losing focus",
  callback = function()
    if vim.opt.autowrite:get() then
      vim.cmd("silent! wall")
    end
  end,
})
