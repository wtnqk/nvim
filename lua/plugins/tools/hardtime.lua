return {
  {
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      enabled = true,
      disable_mouse = false,
      hint = true,
      notification = true,
      -- hints only, no blocking
      restriction_mode = "hint",
      max_time = 1000,
      max_count = 1,
    },
  },
}
