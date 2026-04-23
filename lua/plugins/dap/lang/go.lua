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
      { "<leader>dgt", function() require("dap-go").debug_test() end,        ft = "go", desc = "Debug Go Test" },
      { "<leader>dgl", function() require("dap-go").debug_last_test() end,   ft = "go", desc = "Debug Last Go Test" },
    },
  },
}
