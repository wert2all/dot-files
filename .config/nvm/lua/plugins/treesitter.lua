return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "css",
          "diff",
          "dockerfile",
          "gitignore",
          "go",
          "graphql",
          "html",
          "javascript",
          "jsdoc",
          "json",
          "lua",
          "luadoc",
          "markdown",
          "php",
          "scss",
          "typescript",
          "vim",
          "vimdoc",
          "yaml",
        },
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
