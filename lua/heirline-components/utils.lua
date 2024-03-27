--- ### Heirline-components general utils.

--    Helpers:
--      -> extend_tbl            → Add the content of a table to another table.
--      -> get_icon              → Return an icon from the icons directory.
--      -> get_spinner           → Like the former but for animated iconns.
--      -> is_available          → Return true if the plugin is available.
--      -> trigger_event         → Triggers the specified user event.

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

--- Convenient wapper to save code when we Trigger events.
--- To listen for a event triggered by this function you can use `autocmd`.
---@param event string Name of the event.
---@param is_urgent boolean|nil If true, trigger directly instead of scheduling. Useful for startup events.
-- @usage To run a User event:   `trigger_event("User MyUserEvent")`
-- @usage To run a Neovim event: `trigger_event("BufEnter")
function M.trigger_event(event, is_urgent)
  -- define behavior
  local function trigger()
    local is_user_event = string.match(event, "^User ") ~= nil
    if is_user_event then
      event = event:gsub("^User ", "")
      vim.api.nvim_exec_autocmds("User", { pattern = event, modeline = false })
    else
      vim.api.nvim_exec_autocmds(event, { modeline = false })
    end
  end

  -- execute
  if is_urgent then
    trigger()
  else
    vim.schedule(trigger)
  end
end

return M
