return {
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "prettier",
        "hadolint",
        "phpcs",
        "phpstan",
        "php-cs-fixer",
        "stylelint",
        -- "flake8",
      },
    },
  },
}