return {
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      delve = {
        path = "dlv",
      },
    },
    keys = {
      { "<leader>dtt", function() require("dap-go").debug_test() end,      ft = "go", desc = "Debug Test" },
      { "<leader>dtl", function() require("dap-go").debug_last_test() end, ft = "go", desc = "Debug Last Test" },
    },
  },
}
