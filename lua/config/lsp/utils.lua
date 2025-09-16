local M = {}

M.get_default_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- required by nvim-ufo
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  -- Add blink.cmp capabilities if available
  local has_blink, blink = pcall(require, "blink.cmp")
  if has_blink then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  return capabilities
end

return M
