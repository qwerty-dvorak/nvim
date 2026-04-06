return {
    "echasnovski/mini.pick",
    version = false,
    lazy = false,
    keys = {
        { "<leader>ff", function() require("mini.pick").builtin.files() end,   desc = "Find Files" },
        {
            "<leader>fg",
            function()
                require("mini.pick").builtin.grep()
            end,
            desc = "Grep Project"
        },
        { "<leader>fb", function() require("mini.pick").builtin.buffers() end, desc = "Find Buffers" },
        { "<leader>fr", function() require("mini.pick").builtin.resume() end,  desc = "Resume Last Pick" },
        { "<leader>fh", function() require("mini.pick").builtin.help() end,    desc = "Find Help" },
        {
            "<leader>fw",
            function()
                require("mini.pick").builtin.grep({ pattern = vim.fn.expand("<cword>") })
            end,
            desc = "Find Word under cursor"
        },
        {
            "<leader>fs",
            function()
                require("mini.pick").builtin.grep({ scope = "current" })
            end,
            desc = "Find in Current File"
        },
    },
    config = function()
        require("mini.pick").setup({
            window = {
                config = {
                    border = "single",
                },
            },
        })
    end,
}
