return {
  {
    "gbprod/yanky.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
    keys = {
      { "p",         "<Plug>(YankyPutAfter)",              desc = "Put After",          mode = { "n", "x" } },
      { "P",         "<Plug>(YankyPutBefore)",             desc = "Put Before",         mode = { "n", "x" } },
      { "gp",        "<Plug>(YankyGPutAfter)",             desc = "GPut After",         mode = { "n", "x" } },
      { "gP",        "<Plug>(YankyGPutBefore)",            desc = "GPut Before",        mode = { "n", "x" } },
      { "<C-p>",     "<Plug>(YankyCycleForward)",          desc = "Cycle Forward Yank" },
      { "<C-n>",     "<Plug>(YankyCycleBackward)",         desc = "Cycle Backward Yank" },
      { "<leader>p", function() Snacks.picker.yanky() end, desc = "Yank History" },
    },
  },
}
