return {
    {
        "folke/which-key.nvim",
        dependencies = {
            'echasnovski/mini.icons',
        },
        event = "VimEnter",
        opts = {
            icons = {
                mappings = true,
            },
            spec = {
                { "<leader>g", icon = "", group = "Git" }
            }
        },
    }
}
