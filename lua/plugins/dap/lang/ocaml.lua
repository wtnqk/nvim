return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    ft = { "ocaml" },
    config = function()
      local dap = require("dap")
      dap.adapters.ocaml = {
        type    = "executable",
        command = "ocamlearlybird",
        args    = { "debug" },
      }
      dap.configurations.ocaml = {
        {
          name    = "Launch",
          type    = "ocaml",
          request = "launch",
          program = function()
            return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/_build/default/", "file")
          end,
          cwd         = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },
}
