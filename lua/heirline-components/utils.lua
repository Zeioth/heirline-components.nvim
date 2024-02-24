--- ### Heirline-components general utils.

--    Helpers:
--      -> extend_tbl            → Add the content of a table to another table.
--      -> get_icon              → Return an icon from the icons directory.
--      -> get_spinner           → Like the former but for animated iconns.
--      -> is_available          → Return true if the plugin is available.
--      -> trigger_event         → Triggers the specified user event.
--      -> is_buf_valid          → Check if a buffer is valid.
--      -> close_buf             → Closes the specified buffer.
--      -> close_tab             → Closes the current tab.

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

--- Trigger a user event.
---@param event string The event name to be appended to HeirlineComponents.
-- @usage If you pass the event 'Foo' to this method, it will trigger.
--        the autocmds including the pattern 'HeirineComponentsFoo'.
function M.trigger_event(event)
  vim.schedule(
    function()
      vim.api.nvim_exec_autocmds(
        "User",
        { pattern = "HeirlineComponents" .. event, modeline = false }
      )
    end
  )
end

--- Check if a buffer is valid.
---@param bufnr number The buffer to check.
---@return boolean # Whether the buffer is valid or not.
function M.is_buf_valid(bufnr)
  if not bufnr then bufnr = 0 end
  return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
end

--- Close a given buffer.
--- If the plugin `mini.bufremove` is present, nvim will enter the
--- last accessed buffer automatically after closing.
---@param bufnr? number The buffer to close or the current buffer
---                     if not provided.
---@param force? boolean Whether or not to foce close the buffers,
---                      or confirm changes (default: false).
function M.close_buf(bufnr, force)
  if not bufnr or bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  if M.is_available "mini.bufremove" and M.is_buf_valid(bufnr) and #vim.t.bufs > 1 then
    if not force and vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
      local bufname = vim.fn.expand "%"
      local empty = bufname == ""
      if empty then bufname = "Untitled" end
      local confirm = vim.fn.confirm(
        ('Save changes to "%s"?'):format(bufname),
        "&Yes\n&No\n&Cancel",
        1,
        "Question"
      )
      if confirm == 1 then
        if empty then return end
        vim.cmd.write()
      elseif confirm == 2 then
        force = true
      else
        return
      end
    end
    require("mini.bufremove").delete(bufnr, force)
  else
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = bufnr })
    vim.cmd(("silent! %s %d"):format((force or buftype == "terminal") and "bdelete!" or "confirm bdelete", bufnr))
  end
end

--- Close the current tab.
function M.close_tab()
  if #vim.api.nvim_list_tabpages() > 1 then
    vim.t.bufs = nil
    M.trigger_event "BufsUpdated"
    vim.cmd.tabclose()
  end
end

return M
