local jdtls = require("jdtls")

local root_dir = jdtls.setup.find_root({
  "mvnw",
  "gradlew",
  "pom.xml",
  "build.gradle",
  "build.gradle.kts",
  ".git",
})

if not root_dir then
  return
end

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local project_hash = vim.fn.sha256(root_dir):sub(1, 12)
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name .. "-" .. project_hash

local jdtls_java_home = vim.fn.expand("~/.local/share/mise/installs/java/25.0.2")
local project_java_home = vim.fn.expand("~/.jdk8")
local jdtls_home = vim.fn.expand("~/.local/share/nvim/jdtls")
local jdtls_launcher = vim.fn.glob(jdtls_home .. "/plugins/org.eclipse.equinox.launcher_*.jar")
local jdtls_config = jdtls_home .. "/config_linux"

local debug_jar = vim.env.JDTLS_JAVA_DEBUG_JAR
if not debug_jar or debug_jar == "" then
  debug_jar = vim.fn.glob(
    vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
    true,
    true
  )[1]
end

local bundles = {}
if debug_jar and debug_jar ~= "" then
  bundles = { debug_jar }
end

jdtls.start_or_attach({
  cmd = {
    jdtls_java_home .. "/bin/java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dosgi.checkConfiguration=true",
    "-Dosgi.sharedConfiguration.area=" .. jdtls_config,
    "-Dosgi.sharedConfiguration.area.readOnly=true",
    "-Dosgi.configuration.cascaded=true",
    "-Xms256m",
    "-Xmx1536m",
    "-XX:ActiveProcessorCount=4",
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    "-jar",
    jdtls_launcher,
    "-data",
    workspace_dir,
  },
  cmd_env = {
    JAVA_HOME = jdtls_java_home,
    PATH = jdtls_java_home .. "/bin:" .. vim.env.PATH,
  },
  root_dir = root_dir,
  exit_timeout = 2000,
  extendedClientCapabilities = {
    skipProjectConfiguration = true,
  },
  on_attach = function(client)
    -- JDTLS serves definitions but recent snapshots omit this capability.
    client.server_capabilities.definitionProvider = true
  end,
  capabilities = require("blink-cmp").get_lsp_capabilities(),
  init_options = {
    bundles = bundles,
    settings = {
        java = {
          import = {
            gradle = {
              enabled = false,
              java = { home = project_java_home },
            },
        },
      },
    },
  },
  settings = {
    java = {
      home = jdtls_java_home,
      configuration = {
        updateBuildConfiguration = "interactive",
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = project_java_home,
            default = true,
          },
        },
      },
      import = {
        gradle = {
          enabled = false,
          java = { home = project_java_home },
        },
      },
      project = {
        sourcePaths = {
          vim.fs.joinpath(root_dir, "src/main/java"),
          vim.fs.joinpath(root_dir, "src/test/java"),
        },
      },
      autobuild = { enabled = false },
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = { favoriteStaticMembers = {} },
    },
  },
})

if #bundles > 0 then
  jdtls.setup_dap({ hotcodereplace = "auto" })
  jdtls.setup_dap_main_class_configs()
end
