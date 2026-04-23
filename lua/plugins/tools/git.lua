return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(buf)
        local gs = package.loaded.gitsigns
        local map = vim.keymap.set
        map("n", "]h",          gs.next_hunk,                               { buffer = buf, desc = "Next Hunk" })
        map("n", "[h",          gs.prev_hunk,                               { buffer = buf, desc = "Prev Hunk" })
        map("n", "<leader>ghs", gs.stage_hunk,                              { buffer = buf, desc = "Stage Hunk" })
        map("n", "<leader>ghr", gs.reset_hunk,                              { buffer = buf, desc = "Reset Hunk" })
        map("n", "<leader>ghp", gs.preview_hunk,                            { buffer = buf, desc = "Preview Hunk" })
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, { buffer = buf, desc = "Blame Line" })
      end,
    },
  },
}
