return {
    "stevearc/oil.nvim",
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    lazy = false,
    cmd = { "Oil" },
    keys = {
        { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
        skip_confirm_for_simple_edits = true,
        view_options = {
            show_hidden = true,
        },
        win_options = {
            signcolumn = "yes:2",
        },
        keymaps = {
            ["g?"] = "actions.show_help",
            ["<CR>"] = "actions.select",
            ["<C-s>"] = "actions.select_split",
            ["<C-v>"] = "actions.select_vsplit",
            ["<C-t>"] = "actions.select_tab",
            ["<C-p>"] = "actions.preview",
            ["<Backspace>"] = "actions.parent",
            ["_"] = "actions.open_cwd",
            ["`"] = "actions.cd",
            ["~"] = "actions.tcd",
            ["g."] = "actions.toggle_hidden",
            ["q"] = "actions.close",
        },
        use_default_keymaps = false,
    },
}
