local get_intelephense_license = function()
  local f = assert(io.open(os.getenv("HOME") .. "/.config/intelephense/license.txt", "rb"))
  local content = f:read("*a")
  f:close()
  return (string.gsub(content, "%s+", ""))
end

require("lspconfig").intelephense.setup({
  filetypes = { "php", "blade", "php_only" },
  init_options = {
    licenceKey = get_intelephense_license(),
  },
  settings = {
    intelephense = {
      filetypes = { "php", "blade", "php_only" },
      files = {
        associations = { "*.php", "*.blade.php" }, -- Associating .blade.php files as well
        maxSize = 5000000,
      },
      format = {
        enable = true,
      },
    },
  },
})
