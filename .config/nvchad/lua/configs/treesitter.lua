local options = {
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

    highlight = {
        enable = true,
        use_languagetree = true,
    },

    indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
