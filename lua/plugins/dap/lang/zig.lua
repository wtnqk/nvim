-- codelldb を流用（dap/lang/c.lua と共有）
return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    ft = { "zig" },
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
      dap.configurations.zig = {
        {
          name    = "Launch",
          type    = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/zig-out/bin/", "file")
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },
}
