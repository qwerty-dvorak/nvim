return function(formatters_list)
    return {
        "nvimtools/none-ls.nvim",
        main = "null-ls",
        dependencies = {
            "mason-org/mason.nvim",
            "nvim-lua/plenary.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        opts = function()
            local helpers = require("null-ls.helpers")
            local methods = require("null-ls.methods")
            local null_ls = require("null-ls")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            local formatting = methods.internal.FORMATTING

            local mbake = helpers.make_builtin({
                name = "mbake",
                meta = {
                    url = "https://github.com/Ephemien/mbake",
                    description = "Format Makefiles according to style rules.",
                },
                method = formatting,
                filetypes = { "make", "makefile" },
                generator_opts = {
                    command = "mbake",
                    args = { "format", "--stdin" },
                    to_stdin = true,
                },
                factory = helpers.formatter_factory,
            })

            return {
                on_attach = function(client, bufnr)
                    if client:supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr, async = false })
                            end,
                        })
                    end
                end,
                sources = {
                    null_ls.builtins.formatting.stylua,
                    mbake,
                },
            }
        end,
    }
end
