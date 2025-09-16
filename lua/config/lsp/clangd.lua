-- clangd configuration
return {
  name = "clangd",
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "cc", "objc", "objcpp", "cuda" },
  root_dir = function(filename)
    return vim.fs.root(filename, { "compile_commands.json", "compile_flags.txt", ".clangd", ".clang-tidy", ".clang-format", "configure.ac", ".git" })
  end,
  format_on_save = false,  -- Disable format on save for C/C++ files
}
