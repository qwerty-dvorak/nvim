return function(lsp_list)
    return {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = lsp_list,
            automatic_enable = false,
        },
        config = function(_, opts)
            require("mason").setup()
            require("mason-lspconfig").setup(opts)

            local blink_ok, blink = pcall(require, "blink.cmp")
            if blink_ok and type(blink.get_lsp_capabilities) == "function" then
                vim.lsp.config("*", {
                    capabilities = blink.get_lsp_capabilities(),
                })
            end

            for _, server in ipairs(lsp_list) do
                local ok, cfg = pcall(require, "lsp." .. server)
                if ok and type(cfg) == "function" then
                    cfg = cfg()
                end
                if ok and type(cfg) == "table" then
                    vim.lsp.config(server, cfg)
                end
            end

            vim.lsp.enable(lsp_list)
        end,
    }
end
