-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

return {
  spec = {
    -- Import your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, plugins will load during startup unless specified otherwise
    lazy = false,
    -- Use the latest git commit
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  colorscheme = "kanagawa",
  install = {
    -- Install missing plugins on startup
    missing = true,
    -- Try to load one of these colorschemes when starting an installation during startup
    colorscheme = { "kanagawa", "habamax" },
  },
  checker = {
    -- Automatically check for plugin updates
    enabled = true,
    notify = false, -- Disable notifications when updates are available
    frequency = 3600, -- Check for updates every hour
  },
  performance = {
    cache = {
      enabled = true,
    },
    reset_packpath = true, -- Reset the packpath
    rtp = {
      reset = true, -- Reset the runtime path to $VIMRUNTIME and your config directory
      paths = {}, -- Add any custom paths here that you want to include in the rtp
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = "⌘",
      config = "🛠",
      event = "📅",
      ft = "📂",
      init = "⚙",
      keys = "🗝",
      plugin = "🔌",
      runtime = "💻",
      require = "🌙",
      source = "📄",
      start = "🚀",
      task = "📌",
      lazy = "💤 ",
    },
  },
}