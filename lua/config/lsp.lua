vim.lsp.config("*", {
  -- capabilities = capabilities,
  capabilities = require("blink-cmp").get_lsp_capabilities(),
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local map = vim.keymap.set
    local buf = args.buf

    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client.name == 'gopls' and not client.server_capabilities.semanticTokensProvider then
      local semantic = client.config.capabilities.textDocument.semanticTokens
      client.server_capabilities.semanticTokensProvider = {
        full = true,
        legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
        range = true,
      }
    end

    -- gd/gr/gi/gt は snacks.picker に委譲
    map("n", "gD", vim.lsp.buf.declaration, { buffer = buf, desc = "Go to Declaration" })
    map("n", "K", function()
      vim.lsp.buf.hover({
        border = "rounded",
        max_width = 80,
        max_height = 20,
      })
    end)
    map("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = buf, desc = "Signature Help" })
    map("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })
    map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, { buffer = buf, desc = "Format" })
  end,
})
