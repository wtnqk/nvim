vim.lsp.config("tailwindcss", {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    "html", "css",
    "javascript", "typescript", "typescriptreact", "javascriptreact",
    "vue", "svelte",
  },
  root_markers = {
    "tailwind.config.js", "tailwind.config.ts",
    "tailwind.config.cjs", "tailwind.config.mjs",
    ".git",
  },
})
vim.lsp.enable("tailwindcss")
return {}
