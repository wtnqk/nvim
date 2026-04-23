-- nvim-treesitter + Neovim 0.12: match[capture_id] can return a list of nodes
-- instead of a single TSNode, causing get_node_text to crash via node:range().
do
  local orig = vim.treesitter.get_node_text
  vim.treesitter.get_node_text = function(node, source, opts)
    if node == nil or type(node) ~= "userdata" then return "" end
    return orig(node, source, opts)
  end
end
