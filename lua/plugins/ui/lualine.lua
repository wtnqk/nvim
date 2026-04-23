return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "SmiteshP/nvim-navic",
    },
    opts = {
      options = {
        theme = "everforest",
        globalstatus = true,
        component_separators = "|",
        section_separators = "",
      },
      winbar = {
        lualine_c = {
          {
            function() return require("nvim-navic").get_location() end,
            cond = function() return require("nvim-navic").is_available() end,
          },
        },
      },
      inactive_winbar = {
        lualine_c = {
          {
            function() return require("nvim-navic").get_location() end,
            cond = function() return require("nvim-navic").is_available() end,
          },
        },
      },
    },
  },
}
