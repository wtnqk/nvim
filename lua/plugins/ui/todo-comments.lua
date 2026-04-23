return {
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next Todo" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Prev Todo" },
      { "<leader>ft", "<cmd>TodoTrouble<cr>",                              desc = "Todo (Trouble)" },
      { "<leader>fT", "<cmd>TodoSnacks<cr>",                               desc = "Todo (Snacks)" },
    },
  },
}
