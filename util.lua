vim.api.nvim_create_user_command("ToggleNetrwExplorer", function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "netrw" then
      if vim.fn.winnr("$") > 1 then vim.api.nvim_win_close(win, true) end
      return
    end
  end
  vim.cmd("Lexplore")
end, { desc = "Toggle netrw explorer" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "<C-l>", "<C-w>l", { buffer = true })
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  callback = function()
    if vim.opt.number:get() and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  callback = function()
    if vim.opt.number:get() then vim.opt.relativenumber = false end
  end,
})

vim.opt.undofile = true
local undodir = vim.fn.expand("~/.config/nvim/undodir")
if vim.fn.isdirectory(undodir) == 0 then vim.fn.mkdir(undodir, "p") end
vim.opt.undodir = undodir

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(e)
    if e.match:match("^%w%w+:[\\/][\\/]") then return end
    local file = vim.uv.fs_realpath(e.match) or e.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function() vim.opt_local.formatoptions:remove({ 'r', 'o' }) end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    local cursor = vim.fn.getcurpos()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', cursor)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "qf",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("VimResized", { callback = function() vim.cmd("wincmd =") end })
vim.api.nvim_create_autocmd("FocusLost", {
  callback = function() if vim.opt.autowrite:get() then vim.cmd("silent! wall") end end,
})
