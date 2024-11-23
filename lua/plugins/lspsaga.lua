local keymap = vim.keymap

return {
  {
    lazy = true,
    "nvimdev/lspsaga.nvim",
    event = { "LspAttach" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lspsaga").setup({
        finder = {
          max_height = 0.6,
          -- これは必須です / REQUIRED
          default = "tyd+ref+imp+def",
          -- ここは任意でお好きなキーバインドにしてください / optional
          keys = {
            toggle_or_open = "<CR>",
            vsplit = "v",
            split = "s",
            tabnew = "t",
            tab = "T",
            quit = "q",
            close = "<Esc>",
          },
          -- これは必須です / REQUIRED
          methods = {
            tyd = "textDocument/typeDefinition",
          },
        },
      })

      -- ここで `leader` キーと `,` で、ポップアップで表示されます
      -- 私の場合の `leader` キーは `,` なので、 `,,` で出てきてくれます
      -- うれしい
      keymap.set("n", "<leader>,", "<Cmd>Lspsaga finder<CR>", { desc = "Telescope: live grep args" })
    end,
  },
}
