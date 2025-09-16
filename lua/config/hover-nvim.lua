local hover = require("hover")
local borders = require("config.borders")

hover.config({
  -- List of providers to enable
  providers = {
    'hover.providers.lsp',
    'hover.providers.diagnostic',
    'hover.providers.gh',
    'hover.providers.gh_user',
    'hover.providers.dap',
    'hover.providers.fold_preview',
    'hover.providers.man',
  },
  preview_opts = {
    border = borders.get("bold"),
  },
  -- Whether the contents of a currently open hover window should be moved
  -- to a :h preview-window when pressing the hover keymap.
  preview_window = false,
  title = true,
})

-- Keymaps are now defined in lua/mappings.lua
