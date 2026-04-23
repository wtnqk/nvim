return {
  {
    "folke/sidekick.nvim",
    opts = {},
    keys = {
      {
        "<Tab>",
        function()
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      { "<C-.>",      function() require("sidekick.cli").focus() end,                                  desc = "Sidekick Focus",         mode = { "n", "t", "i", "x" } },
      { "<leader>aa", function() require("sidekick.cli").toggle() end,                                 desc = "Sidekick Toggle CLI" },
      { "<leader>as", function() require("sidekick.cli").select() end,                                 desc = "Select CLI" },
      { "<leader>ad", function() require("sidekick.cli").close() end,                                  desc = "Detach CLI Session" },
      { "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end,                 desc = "Send This",              mode = { "n", "x" } },
      { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end,                 desc = "Send File" },
      { "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end,            desc = "Send Selection",         mode = "x" },
      { "<leader>ap", function() require("sidekick.cli").prompt() end,                                 desc = "Select Prompt",          mode = { "n", "x" } },
      { "<leader>ac", function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end, desc = "Toggle Claude" },
    },
  },
}
