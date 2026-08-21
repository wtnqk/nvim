local function delete_range(start_line, end_line)
  local items = vim.fn.getqflist()
  for index = end_line, start_line, -1 do
    table.remove(items, index)
  end

  if #items == 0 then
    vim.fn.setqflist({}, "r")
    vim.cmd("cclose")
    return
  end

  vim.fn.setqflist({}, "r", { items = items })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function(args)
    vim.keymap.set("n", "dd", function()
      local line = vim.fn.line(".")
      delete_range(line, line)
    end, { buffer = args.buf, desc = "Delete Quickfix Item" })

    vim.keymap.set("x", "d", function()
      local start_line = vim.fn.line("'<")
      local end_line = vim.fn.line("'>")
      delete_range(math.min(start_line, end_line), math.max(start_line, end_line))
    end, { buffer = args.buf, desc = "Delete Quickfix Items" })
  end,
})
