-- blink.cmp は lazy=false なので、ここで安全に require できる
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})


vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local map = vim.keymap.set
    local buf = args.buf
    -- gd/gr/gi/gt は snacks.picker に委譲
    map("n", "gD",            vim.lsp.buf.declaration,                             { buffer = buf, desc = "Go to Declaration" })
    map("n", "K",             vim.lsp.buf.hover,                                   { buffer = buf, desc = "Hover" })
    map("n", "<C-k>",         vim.lsp.buf.signature_help,                          { buffer = buf, desc = "Signature Help" })
    map("n", "<leader>cr",    vim.lsp.buf.rename,                                  { buffer = buf, desc = "Rename" })
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,                      { buffer = buf, desc = "Code Action" })
    map("n", "<leader>cf",    function() vim.lsp.buf.format({ async = true }) end, { buffer = buf, desc = "Format" })
  end,
})
