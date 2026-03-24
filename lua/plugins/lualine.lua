local theme = {
    normal = {
        a = { fg = "#000000", bg = "#ffff00", gui = "bold" },
        b = { fg = "#ffffff", bg = "#000000" },
        c = { fg = "#ffffff", bg = "#000000" },
    },
    insert = {
        a = { fg = "#000000", bg = "#00cccc", gui = "bold" },
        b = { fg = "#ffffff", bg = "#000000" },
        c = { fg = "#ffffff", bg = "#000000" },
    },
    visual = {
        a = { fg = "#000000", bg = "#ff00ff", gui = "bold" },
        b = { fg = "#ffffff", bg = "#000000" },
        c = { fg = "#ffffff", bg = "#000000" },
    },
    replace = {
        a = { fg = "#000000", bg = "#cc0000", gui = "bold" },
        b = { fg = "#ffffff", bg = "#000000" },
        c = { fg = "#ffffff", bg = "#000000" },
    },
    command = {
        a = { fg = "#000000", bg = "#00ff00", gui = "bold" },
        b = { fg = "#ffffff", bg = "#000000" },
        c = { fg = "#ffffff", bg = "#000000" },
    },
    inactive = {
        a = { fg = "#cccccc", bg = "#555555", gui = "bold" },
        b = { fg = "#cccccc", bg = "#555555" },
        c = { fg = "#cccccc", bg = "#555555" },
    },
}

return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        options = {
            theme = theme,
            section_separators = "",
            component_separators = "",
        },
    },
}
