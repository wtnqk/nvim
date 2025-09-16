-- volar configuration
return {
  name = "volar",
  cmd = { "vue-language-server", "--stdio" },
  filetypes = { "vue", "typescript", "javascript", "javascriptreact", "typescriptreact" },
  root_dir = function(filename)
    return vim.fs.root(filename, { "package.json", "vue.config.js", "nuxt.config.ts", "nuxt.config.js", ".git" })
  end,
  format_on_save = false,  -- Disable format on save for Vue files by default
  init_options = {
    typescript = {
      -- Path to TypeScript lib, will be automatically detected if not set
      tsdk = "",
    },
    vue = {
      hybridMode = false,
    },
  },
  settings = {
    -- Volar settings
  },
}