return {
  "neovim/nvim-lspconfig",
  opts = function()
    ---@class PluginLspOpts
    local ret = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
            [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
            [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
          },
        },
      },
      inlay_hints = {
        enabled = true,
        exclude = { "vue" },
      },
      codelens = {
        enabled = false,
      },
      document_highlight = {
        enabled = true,
      },
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        intelephense = {
          cmd = { "intelephense", "--stdio" },
          filetypes = { "php", "blade" },
          init_options = {
            licenceKey = vim.fn.trim(
              vim.fn.system("cat " .. os.getenv("HOME") .. "/.config/intelephense/license.txt 2>/dev/null || echo ''")
            ),
          },
          settings = {
            intelephense = {
              files = {
                associations = { "*.php", "*.blade.php" },
                maxSize = 5000000,
              },
              format = {
                enable = true,
              },
              completion = {
                fullyQualifyGlobalConstantsAndFunctions = false,
                suggestObjectOperatorStaticMethods = true,
                insertUseDeclaration = true,
              },
              diagnostics = {
                enable = true,
              },
            },
          },
        },
        volar = {},
        tsserver = {},
        vtsls = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
      setup = {},
    }

    return ret
  end,
}
