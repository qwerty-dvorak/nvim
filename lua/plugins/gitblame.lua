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
        local gitblame = require("gitblame")

        local function blame_text()
            if vim.b.gitblame_enabled == 0 then
                return ""
            end

            if gitblame.is_blame_text_available() then
                return gitblame.get_current_blame_text()
            end

            return ""
        end

        local function update_blame_state()
            if vim.b.gitblame_enabled == 0 then
                vim.b.gitblame_message = nil
                return
            end

            if gitblame.is_blame_text_available() then
                vim.b.gitblame_message = gitblame.get_current_blame_text()
            else
                vim.b.gitblame_message = nil
            end
        end

        vim.keymap.set("n", "<leader>gB", function()
            vim.b.gitblame_enabled = vim.b.gitblame_enabled == 0 and 1 or 0
            update_blame_state()
            vim.cmd.redrawstatus()
        end, { desc = "Toggle Git blame in lualine" })

        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorMoved", "BufWritePost" }, {
            callback = function()
                if vim.bo.filetype == "" then
                    return
                end

                update_blame_state()
            end,
        })

        local ok, lualine = pcall(require, "lualine")
        if ok then
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
                            blame_text,
                            cond = function()
                                return vim.b.gitblame_enabled ~= 0 and gitblame.is_blame_text_available()
                            end,
                            icon = "󰊢",
                        },
                    },
                },
            })
        end
    end,
}
