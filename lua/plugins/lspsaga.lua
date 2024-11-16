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
          default = "tyd+ref+imp+def",
          keys = {
            toggle_or_open = "<CR>",
            vsplit = { "v", "[" },
            split = { "s", "]" },
            tabnew = "t",
            tab = "T",
            quit = "q",
            close = "<Esc>",
          },
          methods = {
            tyd = "textDocument/typeDefinition",
          },
        },
        ui = {
          code_action = "",
        },
      })

      keymap.set("n", "<leader>,", "<Cmd>Lspsaga finder<CR>", { desc = "Telescope: live grep args" })
    end,
  },
}
