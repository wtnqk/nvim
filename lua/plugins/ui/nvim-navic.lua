return {
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/documentSymbols") then
            require("nvim-navic").attach(client, args.buf)
          end
        end,
      })
    end,
    opts = {
      separator = " > ",
      highlight = true,
      depth_limit = 5,
    },
  },
}
