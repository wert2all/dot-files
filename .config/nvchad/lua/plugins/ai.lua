return {
    {
        "Exafunction/codeium.vim",
        cmd = {
            "Codeium",
            "CodeiumEnable",
            "CodeiumDisable",
            "CodeiumToggle",
            "CodeiumAuto",
            "CodeiumManual",
        },
        event = "BufEnter",
        keys = {
            {
                "<leader>;",
                "<cmd> CodeiumToggle <cr>",
                desc = "toggle Codeium",
            },
        },
        config = function()
            vim.keymap.set("i", "<C-g>", function()
                return vim.fn["codeium#Accept"]()
            end, { expr = true, silent = true })
        end,
    },
    -- "supermaven-inc/supermaven-nvim",
    -- config = function()
    --   require("supermaven-nvim").setup {
    --     keymap = { accept_suggestion = "<C-g>" },
    --   }
    -- end,
}
