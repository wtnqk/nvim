return {
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
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
      local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name
      local debug_jar = vim.env.JDTLS_JAVA_DEBUG_JAR
      if not debug_jar or debug_jar == "" then
        debug_jar = vim.fn.glob(
          vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
        )
      end
      local bundles = {}
      if debug_jar ~= "" then
        bundles = { debug_jar }
      end

      jdtls.start_or_attach({
        cmd = { "jdtls", "-data", workspace_dir },
        root_dir = root_dir,
        capabilities = require("blink-cmp").get_lsp_capabilities(),
        init_options = { bundles = bundles },
        settings = {
          java = {
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
    end,
  },
}
