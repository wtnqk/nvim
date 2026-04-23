return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- language adapters
      "nvim-neotest/neotest-go",
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-python",
    },
    keys = {
      { "<leader>Tt", function() require("neotest").run.run() end,                        desc = "Run Nearest Test" },
      { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end,      desc = "Run File Tests" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end,                 desc = "Toggle Test Summary" },
      { "<leader>To", function() require("neotest").output.open({ enter = true }) end,    desc = "Open Test Output" },
      { "<leader>TO", function() require("neotest").output_panel.toggle() end,            desc = "Toggle Output Panel" },
      { "<leader>TS", function() require("neotest").run.stop() end,                       desc = "Stop Test" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-go"),
          require("neotest-rust"),
          require("neotest-python"),
        },
      })
    end,
  },
}
