vim.lsp.config("ocamllsp", {
  cmd = { "ocamllsp" },
  filetypes = { "ocaml", "ocaml.interface", "ocaml.ocamllex", "dune" },
  root_markers = { "*.opam", ".ocamlformat", "dune-project", ".git" },
})

vim.lsp.enable("ocamllsp")

return {}
