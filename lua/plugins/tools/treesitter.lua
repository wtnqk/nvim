return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      local function attach(buf)
        if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
          return
        end

        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang then
          return
        end
        local ok, available = pcall(vim.treesitter.language.add, lang)
        if not ok or not available then
          return
        end

        local highlights_ok, highlights = pcall(vim.treesitter.query.get, lang, "highlights")
        if highlights_ok and highlights then
          pcall(vim.treesitter.start, buf, lang)
        end
        local indents_ok, indents = pcall(vim.treesitter.query.get, lang, "indents")
        if indents_ok and indents then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("TreesitterFeatures", { clear = true }),
        callback = function(event)
          attach(event.buf)
        end,
      })

      treesitter.install({
        "lua",
        "vim",
        "vimdoc",
        "query",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "rust",
        "python",
        "typescript",
        "tsx",
        "javascript",
        "elm",
        "ocaml",
        "ocaml_interface",
        "erlang",
        "elixir",
        "heex",
        "gleam",
        "clojure",
        "kotlin",
        "java",
        "zig",
        "typst",
        "c",
        "cpp",
        "sql",
        "hcl",
        "terraform",
        "dockerfile",
        "bash",
        "fish",
        "json",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
        "gitcommit",
        "gitignore",
        "git_rebase",
        "html",
        "css",
        "regex",
      }):await(vim.schedule_wrap(function(err)
        if err then
          vim.notify("Tree-sitter installation failed: " .. tostring(err), vim.log.levels.WARN)
        end
        -- Retry loaded buffers even when only some parsers installed successfully.
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          attach(buf)
        end
      end))
    end,
  },
}
