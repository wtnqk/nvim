vim.lsp.config("clojure_lsp", {
  cmd = { "clojure-lsp" },
  filetypes = { "clojure", "edn" },
  root_markers = { "deps.edn", "project.clj", "bb.edn", ".git" },
})
vim.lsp.enable("clojure_lsp")
return {}
