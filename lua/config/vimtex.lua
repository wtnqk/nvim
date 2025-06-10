-- init.luaに追加
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk = {
  options = {
    "-pdfdvi", -- DVI経由でPDF生成（日本語LaTeXに適切）
    "-latex=platex", -- platexエンジンを使用
    "-synctex=1",
    "-interaction=nonstopmode",
    "-file-line-error",
  },
}
