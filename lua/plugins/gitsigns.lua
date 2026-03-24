return {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
        },
        current_line_blame = false,
        numhl = false,
        linehl = false,
        word_diff = false,
        on_attach = function(bufnr)
            local gitsigns = require("gitsigns")
            local keymap = vim.keymap.set
            local opts = { buffer = bufnr, silent = true }

            keymap("n", "]c", function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(gitsigns.next_hunk)
                return "<Ignore>"
            end, { expr = true, silent = true })

            keymap("n", "[c", function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(gitsigns.prev_hunk)
                return "<Ignore>"
            end, { expr = true, silent = true })

            keymap("n", "<leader>hs", gitsigns.stage_hunk, opts)
            keymap("n", "<leader>hr", gitsigns.reset_hunk, opts)
            keymap("v", "<leader>hs", function()
                gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, opts)
            keymap("v", "<leader>hr", function()
                gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
            end, opts)
            keymap("n", "<leader>hS", gitsigns.stage_buffer, opts)
            keymap("n", "<leader>hu", gitsigns.undo_stage_hunk, opts)
            keymap("n", "<leader>hR", gitsigns.reset_buffer, opts)
            keymap("n", "<leader>hp", gitsigns.preview_hunk, opts)
            keymap("n", "<leader>hb", function()
                gitsigns.blame_line({ full = true })
            end, opts)
            keymap("n", "<leader>tb", gitsigns.toggle_current_line_blame, opts)
            keymap("n", "<leader>hd", gitsigns.diffthis, opts)
            keymap("n", "<leader>hD", function()
                gitsigns.diffthis("~")
            end, opts)
            keymap("n", "<leader>td", gitsigns.toggle_deleted, opts)
        end,
    },
}
