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
	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
		callback = function(event)
			local opts = { buffer = event.buf }
			local client = vim.lsp.get_client_by_id(event.data.client_id)

			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
			vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

			vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)

			vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
			vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)

			vim.keymap.set('n', '<leader>la', vim.diagnostic.setqflist,
				{ buffer = event.buf, desc = "List All Diagnostics" })

			if client and client:supports_method("textDocument/formatting", event.buf) then
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = event.buf,
					callback = function()
						vim.lsp.buf.format({
							id = client.id,
							bufnr = event.buf,
							async = false
						})
					end,
				})
			end
		end,
	})
end
