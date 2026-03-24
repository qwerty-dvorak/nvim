return {
    "tpope/vim-fugitive",
    lazy = false,
    keys = {
        { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
        { "<leader>ga", "<cmd>Git add %<cr>", desc = "Git add current file" },
        { "<leader>gA", "<cmd>Git add .<cr>", desc = "Git add all files" },
        { "<leader>gr", "<cmd>Git restore %<cr>", desc = "Git revert current file" },
        { "<leader>gR", "<cmd>Git restore .<cr>", desc = "Git revert all files" },
        { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
        { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
        { "<leader>gl", "<cmd>Git log<cr>", desc = "Git log" },
        { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
        { "<leader>gd", "<cmd>Git diff<cr>", desc = "Git diff" },
    },
}
