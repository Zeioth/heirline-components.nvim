--- ### Heirline-components general utils.

--    Helpers:
--      -> extend_tbl            → Add the content of a table to another table.
--      -> get_icon              → Return an icon from the icons directory.
--      -> get_spinner           → Like the former but for animated iconns.
--      -> is_available          → Return true if the plugin is available.
--      -> cmd                   → Run a shell command and return true/false
--      -> is_buf_valid          → Check if a buffer is valid.

local M = {}

--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
function M.extend_tbl(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end

--- Get an icon from `lspkind` if it is available and return it.
---@param kind string The kind of icon in `lspkind` to retrieve.
---@return string icon.
function M.get_icon(kind, padding)
  local icon_pack = "icons"
  M.icons = vim.g.heirline_components_config.icons
  local icon = M[icon_pack] and M[icon_pack][kind]
  return icon and icon .. string.rep(" ", padding or 0) or ""
end

--- Get a icon spinner table if it is available in the Nvim icons.
--- Icons in format `kind1`,`kind2`, `kind3`, ...
---@param kind string The kind of icon to check for sequential entries of.
---@return string[]|nil spinners # A collected table of spinning icons
---                                in sequential order or nil if none exist.
function M.get_spinner(kind, ...)
  local spinner = {}
  local counter = 1
  repeat
    local icon = M.get_icon(("%s%d"):format(kind, counter), ...)
    if icon ~= "" then spinner[counter] = icon end
    counter = counter + 1
  until not icon or icon == ""
  if #spinner > 0 then return spinner end
end

--- Check if a plugin is defined in lazy. Useful with lazy loading
--- when a plugin is not necessarily loaded yet.
---@param plugin string The plugin to search for.
---@return boolean available # Whether the plugin is available.
function M.is_available(plugin)
  local lazy_config_avail, lazy_config = pcall(require, "lazy.core.config")
  return lazy_config_avail and lazy_config.spec.plugins[plugin] ~= nil
end

--- Check if a buffer is valid.
---@param bufnr number The buffer to check.
---@return boolean # Whether the buffer is valid or not.
function M.is_buf_valid(bufnr)
  if not bufnr then bufnr = 0 end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

return M
