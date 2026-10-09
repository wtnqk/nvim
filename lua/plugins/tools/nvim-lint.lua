local function detect_ts_linter(bufnr)
  local path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  if vim.fs.find({ "biome.json", "biome.jsonc" }, { upward = true, path = path })[1] then
    return { "biomejs" }
  elseif vim.fs.find({ "oxlintrc.json", ".oxlintrc.json" }, { upward = true, path = path })[1] then
    return { "oxlint" }
  elseif vim.fs.find({ ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml", "eslint.config.js", "eslint.config.mjs" }, { upward = true, path = path })[1] then
    return { "eslint" }
  end
  return {}
end

-- biome は vue/svelte 非対応
local function detect_vue_svelte_linter(bufnr)
  local path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  if vim.fs.find({ ".eslintrc", ".eslintrc.js", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml", "eslint.config.js", "eslint.config.mjs" }, { upward = true, path = path })[1] then
    return { "eslint" }
  end
  return {}
end

return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local lint = require("lint")
      local ts_fts = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
      local vue_svelte_fts = { "vue", "svelte" }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local linters = {}
          if vim.tbl_contains(ts_fts, ft) then
            linters = detect_ts_linter(args.buf)
          elseif vim.tbl_contains(vue_svelte_fts, ft) then
            linters = detect_vue_svelte_linter(args.buf)
          elseif ft == "markdown" or ft == "markdown.mdx" then
            linters = { "markdownlint" }
          end
          if #linters > 0 then
            lint.try_lint(linters)
          end
        end,
      })
    end,
  },
}
