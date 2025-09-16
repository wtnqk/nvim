-- intelephense configuration
return {
  name = "intelephense",
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_dir = function(filename)
    return vim.fs.root(filename, { 'composer.json', '.git' })
  end,
  format_on_save = false,  -- Disable format on save for PHP files
  init_options = {
    -- License key for premium features (optional)
    -- Get your license from: https://intelephense.com/
    -- Uncomment and add your license key:
    -- licenseKey = "YOUR_LICENSE_KEY_HERE",

    -- Storage path for cache
    storagePath = vim.fn.stdpath("cache") .. "/intelephense",
  },
  settings = {
    intelephense = {
      files = {
        maxSize = 5000000,
      },
      -- Only basic features are available without license
      -- Premium features require a valid license key
    },
  },
}
