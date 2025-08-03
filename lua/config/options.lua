local ftadd = vim.filetype.add
local g, opt = vim.g, vim.opt

vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH

g.mapleader = " "
g.maplocalleader = "\\"
g.markdown_recommended_style = 0

g.autoformat = false
g.ai_cmp = true

g.root_spec = { "lsp", { ".git", "lua", ".svn" }, "cwd" }
g.root_lsp_ignore = { "copilot" }

opt.autowrite = true
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.colorcolumn = "120"
opt.conceallevel = 3
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fileencodings = { "ucs-bom", "utf-8", "iso-2022-jp", "cp932", "euc-jp", "latin1" }
opt.fileformats = { "unix", "dos", "mac" }
opt.fillchars = {
  fold = " ",
  foldclose = ">",
  foldopen = "v",
  foldsep = " ",
}
opt.foldcolumn = "1"
opt.foldenable = true
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.formatexpr = "v:lua.require'util'.format.formatexpr()"
opt.formatoptions = "jcqlnt"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true
opt.laststatus = 3
opt.list = true
opt.mouse = "a"
opt.number = true
opt.pumblend = 10
opt.pumheight = 10
opt.relativenumber = false
opt.scrolloff = 4
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true
opt.shiftwidth = 0
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showcmdloc = "statusline"
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = -1
opt.spelllang = { "en" }
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.textwidth = 0
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 4000
opt.wildignorecase = true
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false

ftadd({ extension = { aspx = "html" } })