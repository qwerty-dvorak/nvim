return function(langs)
    require("config.autocmds.treesitter")(langs)
    require("config.autocmds.lsp")()
end
