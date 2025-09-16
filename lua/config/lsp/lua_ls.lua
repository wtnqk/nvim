-- lua_ls configuration
-- settings for lua-language-server can be found on https://luals.github.io/wiki/settings/
return {
  name = "lua_ls",
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_dir = function(filename)
    return vim.fs.root(filename, { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" })
  end,
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
