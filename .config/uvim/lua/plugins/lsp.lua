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

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                map("K", vim.lsp.buf.hover, "Hover Documentation")
                map("gD", vim.lsp.buf.declaration, "Goto Declaration")

                require("which-key").add({
                    { "<leader>l",  desc = "Lsp" },
                    { "<leader>lf", vim.lsp.buf.format,         desc = "Format buffer" },
                    { "<leader>la", vim.lsp.buf.code_action,    desc = "Code action" },
                    { "<leader>ls", vim.lsp.buf.signature_help, desc = "Display Signature Information" },
                    { "<leader>lr", vim.lsp.buf.rename,         desc = "Rename all references" }, })
            end,
        })

        require('mason-lspconfig').setup_handlers({
            function(server_name)
                require("lspconfig")[server_name].setup({})
            end,
        })
    end,
}
