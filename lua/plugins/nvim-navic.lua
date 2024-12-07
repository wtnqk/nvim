return {
  "SmiteshP/nvim-navic",
  dependencies = { "neovim/nvim-lspconfig" }, -- lspconfigも必要です
  config = function()
    require("nvim-navic").setup({
      highlight = true,
      separator = " > ",
      depth_limit = 0, -- 深度制限なし
    })
  end,
}
