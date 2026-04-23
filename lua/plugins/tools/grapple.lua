return {
  {
    "cbochs/grapple.nvim",
    event = "BufReadPost",
    cmd = "Grapple",
    keys = {
      { "<leader>ha", "<cmd>Grapple tag<cr>",      desc = "Tag file" },
      { "<leader>hd", "<cmd>Grapple untag<cr>",    desc = "Untag file" },
      { "<leader>hl", "<cmd>Grapple open_tags<cr>", desc = "List tags" },
      { "<C-h>",      "<cmd>Grapple cycle_tags -1<cr>", desc = "Prev tag" },
      { "<C-l>",      "<cmd>Grapple cycle_tags 1<cr>",  desc = "Next tag" },
      { "<leader>h1", "<cmd>Grapple select index=1<cr>", desc = "Tag 1" },
      { "<leader>h2", "<cmd>Grapple select index=2<cr>", desc = "Tag 2" },
      { "<leader>h3", "<cmd>Grapple select index=3<cr>", desc = "Tag 3" },
      { "<leader>h4", "<cmd>Grapple select index=4<cr>", desc = "Tag 4" },
    },
    opts = {
      scope = "git",
    },
  },
}
