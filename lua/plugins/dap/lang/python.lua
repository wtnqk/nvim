return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup("python")
    end,
    keys = {
      { "<leader>dtt", function() require("dap-python").test_method() end, ft = "python", desc = "Debug Test" },
      { "<leader>dtc", function() require("dap-python").test_class() end,  ft = "python", desc = "Debug Test Class" },
    },
  },
}
