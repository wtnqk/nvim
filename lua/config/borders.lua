-- Custom border styles for floating windows
local M = {}

-- Single line border (default)
M.single = {
  {"┌", "FloatBorder"},
  {"─", "FloatBorder"},
  {"┐", "FloatBorder"},
  {"│", "FloatBorder"},
  {"┘", "FloatBorder"},
  {"─", "FloatBorder"},
  {"└", "FloatBorder"},
  {"│", "FloatBorder"},
}

-- Double line border
M.double = {
  {"╔", "FloatBorder"},
  {"═", "FloatBorder"},
  {"╗", "FloatBorder"},
  {"║", "FloatBorder"},
  {"╝", "FloatBorder"},
  {"═", "FloatBorder"},
  {"╚", "FloatBorder"},
  {"║", "FloatBorder"},
}

-- Bold/Heavy line border
M.bold = {
  {"┏", "FloatBorder"},
  {"━", "FloatBorder"},
  {"┓", "FloatBorder"},
  {"┃", "FloatBorder"},
  {"┛", "FloatBorder"},
  {"━", "FloatBorder"},
  {"┗", "FloatBorder"},
  {"┃", "FloatBorder"},
}

-- Rounded border (for reference)
M.rounded = {
  {"╭", "FloatBorder"},
  {"─", "FloatBorder"},
  {"╮", "FloatBorder"},
  {"│", "FloatBorder"},
  {"╯", "FloatBorder"},
  {"─", "FloatBorder"},
  {"╰", "FloatBorder"},
  {"│", "FloatBorder"},
}

-- Mixed style (bold horizontal, single vertical)
M.mixed = {
  {"┏", "FloatBorder"},
  {"━", "FloatBorder"},
  {"┓", "FloatBorder"},
  {"│", "FloatBorder"},
  {"┘", "FloatBorder"},
  {"━", "FloatBorder"},
  {"└", "FloatBorder"},
  {"│", "FloatBorder"},
}

-- Get border style by name
function M.get(style)
  if type(style) == "string" then
    -- Built-in styles
    if style == "single" or style == "rounded" or style == "double" or style == "shadow" or style == "none" then
      return style
    end
    -- Custom styles
    return M[style] or "single"
  end
  return style
end

return M