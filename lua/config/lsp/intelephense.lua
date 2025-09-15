-- Intelephense (PHP) Language Server configuration
return {
  cmd = { 'intelephense', '--stdio' },
  filetypes = { 'php' },
  root_markers = { '.git', 'composer.json' },
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
