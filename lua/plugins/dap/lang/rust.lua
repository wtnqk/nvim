-- rustaceanvim が codelldb を自動管理するが、dap.configurations.rust を明示設定
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    ft = { "rust" },
    config = function()
      local dap = require("dap")
      if not dap.adapters.codelldb then
        dap.adapters.codelldb = {
          type = "server",
          port = "${port}",
          executable = {
            command = "codelldb",
            args    = { "--port", "${port}" },
          },
        }
      end
      dap.configurations.rust = {
        {
          name    = "Launch",
          type    = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },
}
