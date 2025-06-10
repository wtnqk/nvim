local M = {}

function M.setup(lazy_config)
  -- Load options first
  require("config.options")
  
  -- Load keymaps
  require("config.keymaps")
  
  -- Load autocmds
  require("config.autocmds")
  
  -- Setup lazy.nvim with the provided configuration
  if lazy_config then
    require("lazy").setup(lazy_config.spec or lazy_config, lazy_config.opts or {})
  end
end

return M