-- YAML: enforce 2-space indentation and spaces (no hard tabs)
local bo = vim.bo
bo.shiftwidth = 2
bo.tabstop = 2
bo.softtabstop = 2
bo.expandtab = true

-- If something overrides later, defer a final apply
vim.schedule(function()
  if vim.bo.filetype:match('^yaml') then
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
    vim.bo.expandtab = true
  end
end)

