return {
  "danymat/neogen",
  cmd = "Neogen",
  config = true,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    {
      "<leader>cn",
      function() require("neogen").generate() end,
      desc = "Generate Annotation",
    },
    {
      "<leader>cf",
      function() require("neogen").generate({ type = "func" }) end,
      desc = "Generate Function Annotation",
    },
    {
      "<leader>cc",
      function() require("neogen").generate({ type = "class" }) end,
      desc = "Generate Class Annotation",
    },
    {
      "<leader>ct",
      function() require("neogen").generate({ type = "type" }) end,
      desc = "Generate Type Annotation",
    },
  },
  opts = {
    snippet_engine = "nvim",
    enable_placeholders = true,
    languages = {
      pytyon = {
        template = {
          annotation_convention = "google_docstrings",
        },
      },
      lua = {
        template = {
          annotation_convention = "emmylua",
        },
      },
      typescript = {
        template = {
          annotation_convention = "tsdoc",
        },
      },
      go = {
        template = {
          annotation_convention = "godoc",
        },
      }
    }
  }
  -- Uncomment next line if you want to follow only stable versions
  -- version = "*"
}
