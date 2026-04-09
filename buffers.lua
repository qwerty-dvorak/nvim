local keymap = vim.keymap.set

vim.opt.hidden = true
vim.opt.switchbuf = "usetab,newtab"
vim.opt.eadirection = "hor"

vim.api.nvim_create_autocmd("BufAdd", {
  desc = "Show buffer in tabline after creation",
  callback = function()
    vim.schedule(function()
      vim.cmd("redrawtabline")
    end)
  end,
})

vim.api.nvim_create_autocmd("BufDelete", {
  desc = "Update tabline when buffer is deleted",
  callback = function()
    vim.schedule(function()
      vim.cmd("redrawtabline")
    end)
  end,
})

keymap("n", "<leader>bd", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(bufnr)
  local modified = vim.api.nvim_buf_get_option(bufnr, "modified")

  if modified then
    vim.ui.input({ prompt = "Buffer has unsaved changes. Close anyway? [y/N]: " }, function(input)
      if input == "y" or input == "Y" then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end)
  else
    vim.api.nvim_buf_delete(bufnr, { force = false })
  end
end, { desc = "Delete current buffer (prompt if unsaved)" })

keymap("n", "<leader>bD", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_delete(bufnr, { force = true })
end, { desc = "Force delete current buffer" })

keymap("n", "<leader>ba", function()
  local bufs = vim.tbl_filter(function(bufnr)
    return vim.api.nvim_buf_is_loaded(bufnr)
  end, vim.api.nvim_list_bufs())

  for _, bufnr in ipairs(bufs) do
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end, { desc = "Delete all buffers" })

keymap("n", "<leader>bh", function()
  local bufs = vim.tbl_filter(function(bufnr)
    local name = vim.api.nvim_buf_get_name(bufnr)
    return name ~= "" and vim.api.nvim_buf_get_option(bufnr, "buflisted")
  end, vim.api.nvim_list_bufs())

  if #bufs == 0 then return end

  vim.ui.select(bufs, {
    prompt = "Hidden buffers:",
    format_item = function(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      return string.format("%d: %s", bufnr, vim.fn.fnamemodify(name, ":~:."))
    end,
  }, function(bufnr)
    if bufnr then
      vim.api.nvim_set_current_buf(bufnr)
    end
  end)
end, { desc = "Show and switch to hidden buffer" })

keymap("n", "<leader>bl", function()
  local bufs = vim.tbl_filter(function(bufnr)
    return vim.api.nvim_buf_get_option(bufnr, "buflisted")
  end, vim.api.nvim_list_bufs())

  vim.ui.select(bufs, {
    prompt = "Listed buffers:",
    format_item = function(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      local modified = vim.api.nvim_buf_get_option(bufnr, "modified") and " [modified]" or ""
      return string.format("%d: %s%s", bufnr, vim.fn.fnamemodify(name, ":~:."), modified)
    end,
  }, function(bufnr)
    if bufnr then
      vim.api.nvim_set_current_buf(bufnr)
    end
  end)
end, { desc = "List and switch buffers" })

keymap("n", "<leader>bn", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_get_option(b, "buflisted") and b > bufnr
  end, vim.api.nvim_list_bufs())

  if #bufs > 0 then
    vim.api.nvim_set_current_buf(bufs[1])
  else
    local all_bufs = vim.tbl_filter(function(b)
      return vim.api.nvim_buf_get_option(b, "buflisted")
    end, vim.api.nvim_list_bufs())
    if #all_bufs > 0 then
      vim.api.nvim_set_current_buf(all_bufs[1])
    end
  end
end, { desc = "Next buffer" })

keymap("n", "<leader>bp", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_get_option(b, "buflisted") and b < bufnr
  end, vim.api.nvim_list_bufs())

  if #bufs > 0 then
    vim.api.nvim_set_current_buf(bufs[#bufs])
  else
    local all_bufs = vim.tbl_filter(function(b)
      return vim.api.nvim_buf_get_option(b, "buflisted")
    end, vim.api.nvim_list_bufs())
    if #all_bufs > 0 then
      vim.api.nvim_set_current_buf(all_bufs[#all_bufs])
    end
  end
end, { desc = "Previous buffer" })

keymap("n", "<leader>bf", function()
  vim.cmd("bfirst")
end, { desc = "First buffer" })

keymap("n", "<leader>bl", function()
  vim.cmd("blast")
end, { desc = "Last buffer" })

keymap("n", "<leader>bb", function()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_get_option(b, "buflisted")
  end, vim.api.nvim_list_bufs())

  local current = vim.api.nvim_get_current_buf()
  local idx = vim.tbl_index(bufs, current)

  if idx == -1 then return end

  local next_idx = (idx % #bufs) + 1
  vim.api.nvim_set_current_buf(bufs[next_idx])
end, { desc = "Toggle last buffer" })

keymap("n", "<leader>bs", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local modified = vim.api.nvim_buf_get_option(bufnr, "modified")

  if modified then
    vim.cmd("w")
  end

  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_loaded(b) and b ~= bufnr
  end, vim.api.nvim_list_bufs())

  if #bufs > 0 then
    vim.api.nvim_set_current_buf(bufs[1])
  end
end, { desc = "Save and switch to next buffer" })

keymap("n", "<leader>bw", function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.cmd("w")
end, { desc = "Write current buffer" })

keymap("n", "<leader>bwn", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local modified = vim.api.nvim_buf_get_option(bufnr, "modified")

  if modified then
    vim.cmd("w")
  end

  vim.cmd("bnext")
end, { desc = "Write and next buffer" })

keymap("n", "<leader>bwp", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local modified = vim.api.nvim_buf_get_option(bufnr, "modified")

  if modified then
    vim.cmd("w")
  end

  vim.cmd("bprevious")
end, { desc = "Write and previous buffer" })

keymap("n", "<leader>br", function()
  vim.cmd("edit")
end, { desc = "Reload current buffer from disk" })

keymap("n", "<leader>b1", function()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_get_option(b, "buflisted")
  end, vim.api.nvim_list_bufs())
  if bufs[1] then vim.api.nvim_set_current_buf(bufs[1]) end
end, { desc = "Go to buffer 1" })

keymap("n", "<leader>b2", function()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_get_option(b, "buflisted")
  end, vim.api.nvim_list_bufs())
  if bufs[2] then vim.api.nvim_set_current_buf(bufs[2]) end
end, { desc = "Go to buffer 2" })

keymap("n", "<leader>b3", function()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_get_option(b, "buflisted")
  end, vim.api.nvim_list_bufs())
  if bufs[3] then vim.api.nvim_set_current_buf(bufs[3]) end
end, { desc = "Go to buffer 3" })

keymap("n", "<leader>bk", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local changed = vim.api.nvim_buf_get_option(bufnr, "changed")

  if changed then
    vim.ui.input({ prompt = "Buffer has unsaved changes. Delete? [y/N]: " }, function(input)
      if input == "y" or input == "Y" then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end)
  else
    vim.api.nvim_buf_delete(bufnr, { force = false })
    vim.cmd("bprevious")
  end
end, { desc = "Kill buffer and go to previous" })

keymap("n", "<leader>bm", function()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_get_option(b, "buflisted")
  end, vim.api.nvim_list_bufs())

  vim.ui.input({
    prompt = "Move to buffer number: ",
    default = tostring(vim.fn.bufnr()),
    completion = "number"
  }, function(input)
    local num = tonumber(input)
    if num and vim.api.nvim_buf_is_loaded(num) then
      vim.api.nvim_set_current_buf(num)
    end
  end)
end, { desc = "Move to buffer by number" })

local function buffer_stats()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_loaded(b)
  end, vim.api.nvim_list_bufs())

  local listed = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_get_option(b, "buflisted")
  end, bufs)

  local modified = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_get_option(b, "modified")
  end, bufs)

  return {
    total = #bufs,
    listed = #listed,
    modified = #modified
  }
end

vim.api.nvim_create_user_command("BufferStats", function()
  local stats = buffer_stats()
  print(string.format("Buffers: %d total, %d listed, %d modified",
    stats.total, stats.listed, stats.modified))
end, {})

vim.api.nvim_create_user_command("BufferList", function()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_get_option(b, "buflisted")
  end, vim.api.nvim_list_bufs())

  local current = vim.api.nvim_get_current_buf()

  for _, bufnr in ipairs(bufs) do
    local name = vim.api.nvim_buf_get_name(bufnr)
    local modified = vim.api.nvim_buf_get_option(bufnr, "modified") and "%" or " "
    local marker = bufnr == current and ">" or " "
    local shortname = vim.fn.fnamemodify(name, ":~:.")
    if shortname == "" then shortname = "[No Name]" end
    print(string.format("%s %s %d: %s", marker, modified, bufnr, shortname))
  end
end, {})

vim.api.nvim_create_user_command("BufferOnly", function()
  local bufs = vim.tbl_filter(function(b)
    return vim.api.nvim_buf_is_loaded(b) and b ~= vim.api.nvim_get_current_buf()
  end, vim.api.nvim_list_bufs())

  for _, bufnr in ipairs(bufs) do
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end, { desc = "Close all buffers except current" })
