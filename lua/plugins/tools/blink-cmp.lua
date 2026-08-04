return {
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "1.*",
    dependencies = {
      -- multi-language aggregation (already sources from official extensions)
      "rafamadriz/friendly-snippets",
      -- official VS Code extension snippets
      { "golang/vscode-go",                           build = false },
      { "hashicorp/vscode-terraform",                 build = false },
      { "ziglang/vscode-zig",                         build = false },
      { "elixir-lsp/vscode-elixir-ls",                build = false },
      { "fwcd/vscode-kotlin",                         build = false },
      { "ocamllabs/vscode-ocaml-platform",            build = false },
      { "dsznajder/vscode-react-javascript-snippets", build = false },
      { "honojs/vscode",                              build = false },
    },
    opts = {
      keymap = { preset = "default", ["<CR>"] = { "accept", "fallback" } },
      completion = {
        list = { selection = { preselect = true } },
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
        menu = {
          draw = {
            columns = {
              { "kind_icon" },
              { "label",    "label_description", gap = 1 },
              { "kind" }
            }
          }
        }
      },
      appearance = {
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      signature = {
        enabled = true,
        trigger = {
          show_on_trigger_character = true,
          show_on_insert = false,
        }
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}
