return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      local plugin_dir = vim.fn.stdpath("data") .. "/lazy/fff.nvim"
      local binary = plugin_dir .. "/target/release/libfff_nvim.dylib"
      if vim.fn.filereadable(binary) == 1 then return end
      local cargo = vim.fn.exepath("cargo")
      if cargo == "" then
        cargo = vim.fn.expand("~/.cargo/bin/cargo")
      end
      if vim.fn.filereadable(cargo) == 0 then
        error("fff.nvim: cargo not found. Install Rust from https://rustup.rs/")
      end
      vim.notify("fff.nvim: building binary (this may take a few minutes)...", vim.log.levels.INFO)
      local result = vim.system({ cargo, "build", "--release" }, { cwd = plugin_dir }):wait(300000)
      if result.code ~= 0 then
        error("fff.nvim: build failed\n" .. (result.stderr or ""))
      end
      vim.notify("fff.nvim: build complete!", vim.log.levels.INFO)
    end,
    lazy = true,
    keys = {
      { "<leader>ff", function() require("fff").find_files() end,                                          desc = "Find Files" },
      { "<leader>fg", function() require("fff").live_grep() end,                                           desc = "Grep" },
      { "<leader>fw", function() require("fff").live_grep({ query = vim.fn.expand("<cword>") }) end,       desc = "Grep Word" },
      { "<leader>fw", function() require("fff").live_grep({ query = vim.fn.expand("<cword>") }) end,       desc = "Grep Word", mode = "v" },
    },
  },
}
