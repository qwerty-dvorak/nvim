return {
    "f-person/git-blame.nvim",
    lazy = false,
    init = function()
        vim.g.gitblame_enabled = 1
        vim.g.gitblame_display_virtual_text = 0
        vim.g.gitblame_date_format = "%r"
        vim.g.gitblame_message_template = "<summary> • <date> • <author>"
        vim.g.gitblame_message_when_not_committed = "Not committed yet"
    end,
    config = function()
        local lualine = require("lualine")
        local blame = require("gitblame")

        lualine.setup({
            options = {
                theme = "auto",
                section_separators = "",
                component_separators = "",
            },
            sections = {
                lualine_c = {
                    "filename",
                    {
                        function()
                            if vim.b.gitblame_message then
                                return vim.b.gitblame_message
                            end

                            local message = blame.get_current_blame_message()
                            return message ~= "" and message or ""
                        end,
                        icon = "󰊢",
                    },
                },
            },
        })
    end,
}
