local get_intelephense_license = function()
  local f = assert(io.open(os.getenv("HOME") .. "/.config/intelephense/license.txt", "rb"))
  local content = f:read("*a")
  f:close()
  return (string.gsub(content, "%s+", ""))
end

require("lspconfig").intelephense.setup({
  filetypes = { "php" },
  init_options = {
    licenceKey = get_intelephense_license(),
  },
  settings = {
    intelephense = {
      format = {
        enable = true,
      },
    },
  },
})
