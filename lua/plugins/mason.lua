return function(lsp_list)
    return {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
            ensure_installed = lsp_list,
            automatic_installation = true,
        },
        config = function(_, opts)
            require("mason").setup()
            require("mason-lspconfig").setup(opts)
            for _, server in ipairs(lsp_list) do
                vim.lsp.enable(server)
            end
        end,
    }
end
