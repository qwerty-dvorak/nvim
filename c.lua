local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.h",
    desc = "Auto-generate header guards for .h files",
    callback = function()
        local name = vim.fn.expand("%:t"):upper():gsub("%.", "_")
        local lines = {
            "#ifndef " .. name,
            "#define " .. name,
            "",
            "",
            "#endif // " .. name
        }
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        vim.api.nvim_win_set_cursor(0, {3, 0})
    end,
})

keymap("n", "<leader>m", ":make<CR>", { desc = "Run make" })
keymap("n", "<leader>cn", ":cnext<CR>", { desc = "Next quickfix item" })
keymap("n", "<leader>cp", ":cprev<CR>", { desc = "Previous quickfix item" })
keymap("n", "<leader>co", ":copen<CR>", { desc = "Open quickfix window" })
keymap("n", "<leader>cc", ":cclose<CR>", { desc = "Close quickfix window" })

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = "[^l]*",
    desc = "Open quickfix after make",
    callback = function()
        vim.cmd("copen")
    end,
})

local hex_mode = false
keymap("n", "<leader>hx", function()
  if not hex_mode then
    vim.cmd("%!xxd")
    hex_mode = true
  else
    vim.cmd("%!xxd -r")
    hex_mode = false
  end
end, { desc = "Toggle hex view" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  desc = "Enable C/C++ autocomplete",
  callback = function()
    vim.bo.omnifunc = "ccomplete#Complete"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "h" },
  desc = "Set C/C++ tab options",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

keymap("n", "<leader>ds", ":!valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./a.out 2>&1 | less -R<CR>", { desc = "Run valgrind memory check" })
keymap("n", "<leader>run", ":!./a.out 2>&1; echo; read -p 'Press Enter to continue'", { desc = "Run compiled executable" })
