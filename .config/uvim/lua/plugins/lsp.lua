return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "williamboman/mason.nvim", config = true },
        "williamboman/mason-lspconfig.nvim",
        {
            -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            'folke/lazydev.nvim',
            ft = 'lua',
            opts = {
                library = {
                    -- Load luvit types when the `vim.uv` word is found
                    { path = 'luvit-meta/library', words = { 'vim%.uv' } },
                },
            },
        },
        -- Useful status updates for LSP.
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { 'j-hui/fidget.nvim',       opts = {} },
    },

    config = function()
        require("mason").setup({
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls" },
            automatic_installation = true,
        })

        require('mason-lspconfig').setup_handlers({
            function(server_name)
                require("lspconfig")[server_name].setup({})
            end,
        })
    end,
    keys = {
        { "<leader>lf", function() vim.lsp.buf.format() end,      desc = "Format buffer" },
        { "<leader>la", function() vim.lsp.buf.code_action() end, desc = "Code action" }
    }
}
