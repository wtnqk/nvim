-- settings for lua-language-server can be found on https://luals.github.io/wiki/settings/
return {
  filetypes = { "lua" },
  cmd = { "lua-language-server" },
  format_on_save = true,  -- Enable format on save for Lua files
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
      },
      hint = {
        enable = true,
      },
    },
  },
}
