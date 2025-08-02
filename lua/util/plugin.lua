---@class util.plugin
local M = {}

function M.has(name)
  return require("lazy.core.config").spec.plugins[name] ~= nil
end

function M.is_loaded(name)
  local config = require("lazy.core.config")
  return config.spec.plugins[name] ~= nil and config.spec.plugins[name]._.loaded ~= nil
end

function M.opts(name)
  local plugin = require("lazy.core.config").spec.plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

return M