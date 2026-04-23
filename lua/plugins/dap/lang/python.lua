return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-python").setup("python")
    end,
    keys = {
      { "<leader>dpt", function() require("dap-python").test_method() end, ft = "python", desc = "Debug Python Test Method" },
      { "<leader>dpc", function() require("dap-python").test_class() end,  ft = "python", desc = "Debug Python Test Class" },
    },
  },
}
