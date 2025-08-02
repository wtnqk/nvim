local function augroup(name)
  return vim.api.nvim_create_augroup("userconf_" .. name, { clear = true })
end


-- Auto create directory when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    local force = vim.v.cmdbang
    local dir = vim.fn.fnamemodify(file, ":p:h")
    if vim.fn.isdirectory(dir) == 0 then
      if force == 1 or vim.fn.confirm(("%q does not exist. Create?"):format(dir), "&Yes\n&No") == 1 then
        vim.fn.mkdir(dir, "p")
      end
    end
  end,
})

-- Show relative line numbers in visual mode
local visual_mode_relnum = augroup("visual_mode_relnum")
vim.api.nvim_create_autocmd("ModeChanged", {
  group = visual_mode_relnum,
  pattern = "*:[V\x16]*",
  callback = function()
    vim.wo.relativenumber = vim.wo.number
  end,
  desc = "Show relative line numbers",
})
vim.api.nvim_create_autocmd("ModeChanged", {
  group = visual_mode_relnum,
  pattern = "[V\x16]*:*",
  callback = function()
    vim.wo.relativenumber = string.find(vim.fn.mode(), "^[V\22]") ~= nil
  end,
  desc = "Hide relative line numbers",
})

-- Set colorcolumn for markdown files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("markdown_colorcolumn"),
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.colorcolumn = "80"
  end,
})

-- Disable conceallevel for markdown files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("markdown_conceal"),
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Disable conceallevel for JSON files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- WSL-specific: Disable fixeol for mounted Windows drives
if os.getenv("WSL_DISTRO_NAME") then
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("disable_fixeol"),
    pattern = "/mnt/*",
    callback = function()
      vim.opt_local.fixendofline = false
    end,
    desc = "Do not fix end of line",
  })
end