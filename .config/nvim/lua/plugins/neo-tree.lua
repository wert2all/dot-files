return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = false })
        end,
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true })
        end,
      },
    },
  },
}
