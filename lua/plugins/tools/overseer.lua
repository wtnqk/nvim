return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerBuild" },
    opts = {},
    keys = {
      { "<leader>ro", "<cmd>OverseerToggle<cr>",  desc = "Overseer Toggle" },
      { "<leader>rr", "<cmd>OverseerRun<cr>",     desc = "Overseer Run" },
      { "<leader>rb", "<cmd>OverseerBuild<cr>",   desc = "Overseer Build" },
    },
  },
}
