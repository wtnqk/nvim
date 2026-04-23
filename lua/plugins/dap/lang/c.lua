return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    ft = { "c", "cpp" },
    config = function()
      local dap = require("dap")
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = "codelldb",
          args    = { "--port", "${port}" },
        },
      }
      local config = {
        {
          name    = "Launch",
          type    = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd          = "${workspaceFolder}",
          stopOnEntry  = false,
        },
      }
      dap.configurations.c   = config
      dap.configurations.cpp = config
    end,
  },
}
