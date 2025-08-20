return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    dependencies = {
      "mason-org/mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
    },
    opts = function()
      return {
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
              [vim.diagnostic.severity.ERROR] = Util.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.HINT] = Util.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = Util.config.icons.diagnostics.Info,
              [vim.diagnostic.severity.WARN] = Util.config.icons.diagnostics.Warn,
            },
          },
        },
        inlay_hints = {
          enabled = false,
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
          -- PHP
          intelephense = {
            init_options = {
              licenceKey = vim.fn.expand("~/intelephense/licence.txt"),
            },
            settings = {
              intelephense = {
                environment = {
                  includePaths = { "/usr/local/lib/php" },
                },
                files = {
                  associations = { "*.php", "*.phtml", "*.blade.php" },
                  maxSize = 5000000,
                },
                stubs = {
                  "apache",
                  "bcmath",
                  "bz2",
                  "calendar",
                  "com_dotnet",
                  "Core",
                  "ctype",
                  "curl",
                  "date",
                  "dba",
                  "dom",
                  "enchant",
                  "exif",
                  "FFI",
                  "fileinfo",
                  "filter",
                  "fpm",
                  "ftp",
                  "gd",
                  "gettext",
                  "gmp",
                  "hash",
                  "iconv",
                  "imap",
                  "intl",
                  "json",
                  "ldap",
                  "libxml",
                  "mbstring",
                  "meta",
                  "mysqli",
                  "oci8",
                  "odbc",
                  "openssl",
                  "pcntl",
                  "pcre",
                  "PDO",
                  "pdo_ibm",
                  "pdo_mysql",
                  "pdo_pgsql",
                  "pdo_sqlite",
                  "pgsql",
                  "Phar",
                  "posix",
                  "pspell",
                  "random",
                  "readline",
                  "Reflection",
                  "session",
                  "shmop",
                  "SimpleXML",
                  "snmp",
                  "soap",
                  "sockets",
                  "sodium",
                  "SPL",
                  "sqlite3",
                  "standard",
                  "superglobals",
                  "sysvmsg",
                  "sysvsem",
                  "sysvshm",
                  "tidy",
                  "tokenizer",
                  "xml",
                  "xmlreader",
                  "xmlrpc",
                  "xmlwriter",
                  "xsl",
                  "Zend OPcache",
                  "zip",
                  "zlib",
                  "wordpress",
                  "wordpress-globals",
                  "wp-cli",
                  "genesis",
                  "polylang",
                },
              },
            },
          },
          -- JSON with SchemaStore
          jsonls = {
            on_new_config = function(new_config)
              new_config.settings.json.schemas = new_config.settings.json.schemas or {}
              vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
            end,
            settings = {
              json = {
                format = {
                  enable = true,
                },
                validate = { enable = true },
              },
            },
          },
          -- YAML with SchemaStore
          yamlls = {
            capabilities = {
              textDocument = {
                foldingRange = {
                  dynamicRegistration = false,
                  lineFoldingOnly = true,
                },
              },
            },
            on_new_config = function(new_config)
              new_config.settings.yaml.schemas = vim.tbl_deep_extend(
                "force",
                new_config.settings.yaml.schemas or {},
                require("schemastore").yaml.schemas()
              )
            end,
            settings = {
              redhat = { telemetry = { enabled = false } },
              yaml = {
                keyOrdering = false,
                format = {
                  enable = true,
                },
                validate = true,
                schemaStore = {
                  enable = false,
                  url = "",
                },
              },
            },
          },
          -- Markdown
          marksman = {},
          -- TOML
          taplo = {
            keys = {
              {
                "K",
                function()
                  if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                    require("crates").show_popup()
                  else
                    vim.lsp.buf.hover()
                  end
                end,
                desc = "Show Crate Documentation",
              },
            },
          },
        },
        setup = {},
      }
    end,
    config = function(_, opts)
      Util.format.register(Util.lsp.formatter())

      Util.lsp.on_attach(function(client, buffer)
        require("plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      Util.lsp.setup()
      Util.lsp.on_dynamic_capability(require("plugins.lsp.keymaps").on_attach)

      Util.lsp.words.setup(opts.document_highlight)

      if vim.fn.has("nvim-0.10.0") == 0 then
        if type(opts.diagnostics.signs) ~= "boolean" then
          for severity, icon in pairs(opts.diagnostics.signs.text) do
            local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
          end
        end
      end

      if vim.fn.has("nvim-0.10") == 1 then
        if opts.inlay_hints.enabled then
          Util.lsp.on_supports_method("textDocument/inlayHint", function(_, buffer)
            if
              vim.api.nvim_buf_is_valid(buffer)
              and vim.bo[buffer].buftype == ""
              and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
            then
              vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            end
          end)
        end

        if opts.codelens.enabled and vim.lsp.codelens then
          Util.lsp.on_supports_method("textDocument/codeLens", function(_, buffer)
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = buffer,
              callback = vim.lsp.codelens.refresh,
            })
          end)
        end
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
          or function(diagnostic)
            for d, icon in pairs(Util.config.icons.diagnostics) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}

      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig").get_mappings().lspconfig_to_mason)
      end

      local exclude_automatic_enable = {}

      local function configure(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
        return server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server)
      end

      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            if configure(server) then
              exclude_automatic_enable[#exclude_automatic_enable + 1] = server
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        local setup_config = {
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            Util.plugin.opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        }

        local function setup(server)
          local server_opts = servers[server] or {}
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false and not vim.tbl_contains(exclude_automatic_enable, server) then
            configure(server)
          end
        end

        setup_config.handlers = { setup }

        mlsp.setup(setup_config)
      end

      if Util.lsp.is_enabled("denols") and Util.lsp.is_enabled("vtsls") then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        Util.lsp.disable("vtsls", is_deno)
        Util.lsp.disable("denols", function(root_dir, config)
          if not is_deno(root_dir) then
            config.settings.deno.enable = false
          end
          return false
        end)
      end
    end,
  },

  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<Leader>cm", "<Cmd>Mason<CR>", desc = "Mason" } },
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "prettier",
        "php-cs-fixer",
        "blade-formatter",
        "phpstan",
        "markdownlint-cli2",
        "markdown-toc",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  {
    "smjonas/inc-rename.nvim",
    event = "LazyFile",
    config = true,
  },

  -- LSP signature help
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded",
      },
      hint_prefix = "󰏪 ",
      hint_enable = false,
      floating_window = true,
      floating_window_above_cur_line = true,
      timer_interval = 200,
      toggle_key = "<M-x>",
    },
    config = function(_, opts)
      require("lsp_signature").setup(opts)
    end,
  },
}

