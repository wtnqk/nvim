local function detect_ts_formatter(bufnr)
  local path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  if vim.fs.find({ "biome.json", "biome.jsonc" }, { upward = true, path = path })[1] then
    return { "biome" }
  elseif vim.fs.find({ ".oxfmtrc.jsonc", ".oxfmtrc.json" }, { upward = true, path = path })[1] then
    return { "oxfmt" }
  elseif vim.fs.find({ ".prettierrc", ".prettierrc.js", ".prettierrc.json", ".prettierrc.yaml", ".prettierrc.yml", "prettier.config.js", "prettier.config.cjs" }, { upward = true, path = path })[1] then
    return { "prettier" }
  end
  return {}
end

-- biome は vue/svelte 非対応
local function detect_vue_svelte_formatter(bufnr)
  local path = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  if vim.fs.find({ ".prettierrc", ".prettierrc.js", ".prettierrc.json", ".prettierrc.yaml", ".prettierrc.yml", "prettier.config.js", "prettier.config.cjs" }, { upward = true, path = path })[1] then
    return { "prettier" }
  end
  return {}
end

local ts_fts = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
local vue_svelte_fts = { "vue", "svelte" }

return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        lua        = { "emmylua" },
        go         = { "gofmt", "goimports" },
        rust       = { "rustfmt" },
        python     = { "black" },
        typescript = detect_ts_formatter,
        javascript = detect_ts_formatter,
        tsx        = detect_ts_formatter,
        jsx        = detect_ts_formatter,
        vue        = detect_vue_svelte_formatter,
        svelte     = detect_vue_svelte_formatter,
        json       = { "prettier" },
        yaml       = { "prettier" },
        markdown   = { "prettier" },
        elm        = { "elm_format" },
      },
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if vim.tbl_contains(ts_fts, ft) and #detect_ts_formatter(bufnr) == 0 then
          return
        end
        if vim.tbl_contains(vue_svelte_fts, ft) and #detect_vue_svelte_formatter(bufnr) == 0 then
          return
        end
        return { timeout_ms = 500, lsp_fallback = true }
      end,
    },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format" },
    },
  },
}
