return function(langs)
    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true }),
        pattern = langs,
        callback = function(args)
            vim.treesitter.start(args.buf)
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo.foldlevel = 15
            vim.wo.foldenable = true
            vim.keymap.set('n', '<Tab>', 'za', { buffer = args.buf, desc = "Toggle Fold" })
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            vim.bo[args.buf].tabstop = 4
            vim.bo[args.buf].shiftwidth = 4
            vim.bo[args.buf].expandtab = true
        end,
    })
end
