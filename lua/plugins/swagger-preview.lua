return {
  "vinnymeller/swagger-preview.nvim",
  config = function()
    require("swagger-preview").setup({
      port = 8100,
      host = "localhost",
    })
  end,
}
