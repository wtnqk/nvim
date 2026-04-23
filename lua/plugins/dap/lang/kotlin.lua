return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    ft = { "kotlin" },
    config = function()
      local dap = require("dap")
      dap.adapters.kotlin = {
        type    = "executable",
        command = "kotlin-debug-adapter",
      }
      dap.configurations.kotlin = {
        {
          type    = "kotlin",
          name    = "Launch",
          request = "launch",
          mainClass = function()
            return vim.fn.input("Main class (e.g. com.example.MainKt): ")
          end,
          projectRoot = "${workspaceFolder}",
        },
      }
    end,
  },
}
