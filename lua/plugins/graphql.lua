return {
  -- GraphQLシンタックスハイライト
  {
    "jparise/vim-graphql",
    ft = { "graphql", "javascript", "typescript", "javascriptreact", "typescriptreact" },
  },

  -- LSP設定
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        graphql = {
          filetypes = { "graphql", "javascript", "typescript", "javascriptreact", "typescriptreact" },
          root_dir = function(fname)
            return require("lspconfig").util.find_git_ancestor(fname)
          end,
        },
      },
    },
  },

  -- TreesitterでGraphQLサポート
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "graphql",
      })
    end,
  },
}
