return function(langs)
  return {
    {
      'nvim-treesitter/nvim-treesitter',
      lazy = false,
      build = ':TSUpdate',
      config = function()
        require('nvim-treesitter').install(langs)
      end,
    },
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      lazy = true,
    },
  }
end
