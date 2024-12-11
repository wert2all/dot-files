return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "angular",
                    "bash",
                    "css",
                    "diff",
                    "dockerfile",
                    "dot",
                    "editorconfig",
                    "gitcommit",
                    "gitignore",
                    "go",
                    "graphql",
                    "html",
                    "hyprlang",
                    "javascript",
                    "jsdoc",
                    "json",
                    "lua",
                    "luadoc",
                    "markdown",
                    "markdown_inline",
                    "nginx",
                    "nix",
                    "php",
                    "scss",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    }
}
