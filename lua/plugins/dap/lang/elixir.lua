return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    ft = { "elixir", "eelixir", "heex" },
    config = function()
      local dap = require("dap")
      dap.adapters.mix_task = {
        type    = "executable",
        command = "elixir-ls-debugger",
      }
      dap.configurations.elixir = {
        {
          type    = "mix_task",
          name    = "mix test",
          request = "launch",
          task    = "test",
          taskArgs           = { "--trace" },
          startApps          = true,
          projectDir         = "${workspaceFolder}",
          requireFiles       = { "test/**/test_helper.exs", "test/**/*_test.exs" },
          excludeModules     = {},
          debugAutoInterpretAllModules = false,
        },
        {
          type      = "mix_task",
          name      = "mix run",
          request   = "launch",
          task      = "run",
          projectDir = "${workspaceFolder}",
        },
      }
    end,
  },
}
