return function()
    vim.opt.completeopt = { "menuone", "noselect", "popup" }
    vim.opt.shortmess:append("c")

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
        callback = function(event)
            local opts = { buffer = event.buf }
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
            vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
            vim.keymap.set('n', '<leader>la', vim.diagnostic.setqflist,
                { buffer = event.buf, desc = "List All Diagnostics" })
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
            if client and client:supports_method("textDocument/formatting", event.buf) then
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = event.buf,
                    callback = function()
                        vim.lsp.buf.format({ id = client.id, bufnr = event.buf, async = false })
                    end,
                })
            end
        end,
    })
end
