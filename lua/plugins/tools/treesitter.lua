return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = { enable = true },
        indent = { enable = true },
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",
          "go", "gomod", "gosum", "gowork",
          "rust",
          "python",
          "typescript", "tsx", "javascript",
          "elm",
          "ocaml", "ocaml_interface",
          "erlang",
          "elixir", "heex",
          "gleam",
          "clojure",
          "kotlin",
          "zig",
          "typst",
          "c", "cpp",
          "sql",
          "hcl", "terraform",
          "dockerfile",
          "bash", "fish",
          "json", "yaml", "toml",
          "markdown", "markdown_inline",
          "gitcommit", "gitignore", "git_rebase",
          "html", "css",
          "regex",
        },
      })
    end,
  },
}
