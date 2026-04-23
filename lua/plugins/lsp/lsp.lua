return {
  -- Rust: rustaceanvim が rust-analyzer を直接管理（Mason 不要）
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    ft = { "rust" },
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, buf)
            local map = vim.keymap.set
            map("n", "<leader>ca", function() vim.cmd.RustLsp("codeAction") end,          { buffer = buf, desc = "Rust Code Action" })
            map("n", "K",          function() vim.cmd.RustLsp({ "hover", "actions" }) end, { buffer = buf, desc = "Rust Hover" })
          end,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" },
            },
          },
        },
      }
    end,
  },
}
