--- ### Heirline initializers.
--
-- DESCRIPTION:
-- These functions are used to initialize certain components.

local M = {}

local env = require "heirline-components.core.env"
local provider = require "heirline-components.core.provider"
local core_utils = require "heirline-components.core.utils"

local utils = require "heirline-components.utils"
local extend_tbl = utils.extend_tbl

--- An `init` function to build a set of children components for LSP breadcrumbs.
---@param opts? table # options for configuring the breadcrumbs (default: `{ max_depth = 5, separator = "  ", icon = { enabled = true, hl = false }, padding = { left = 0, right = 0 } }`)
---@return function # The Heirline init function.
-- @usage local heirline_component = { init = require("heirline-components.core").init.breadcrumbs { padding = { left = 1 } } }
function M.breadcrumbs(opts)
  opts = extend_tbl({
    max_depth = 5,
    separator = env.separators.breadcrumbs or "  ",
    icon = { enabled = true, hl = env.icon_highlights.breadcrumbs },
    padding = { left = 0, right = 0 },
  }, opts)
  return function(self)
    local data = require("aerial").get_location(true) or {}
    local children = {}
    -- add prefix if needed, use the separator if true, or use the provided character.
    if opts.prefix and not vim.tbl_isempty(data) then
      table.insert(
        children,
        { provider = opts.prefix == true and opts.separator or opts.prefix }
      )
    end
    local start_idx = 0
    if opts.max_depth and opts.max_depth > 0 then
      start_idx = #data - opts.max_depth
      if start_idx > 0 then
        table.insert(
          children,
          {
            provider = utils.get_icon "Ellipsis"
                .. opts.separator,
          }
        )
      end
    end
    -- create a child for each level.
    for i, d in ipairs(data) do
      if i > start_idx then
        local child = {
          {
            provider = string.gsub(d.name, "%%", "%%%%"):gsub("%s*->%s*", ""),
          },           -- add symbol name
          on_click = { -- add on click function
            minwid = core_utils.encode_pos(d.lnum, d.col, self.winnr),
            callback = function(_, minwid)
              local lnum, col, winnr = core_utils.decode_pos(minwid)
              vim.api.nvim_win_set_cursor(
                vim.fn.win_getid(winnr),
                { lnum, col }
              )
            end,
            name = "heirline_breadcrumbs",
          },
        }
        if opts.icon.enabled then -- add icon and highlight if enabled.
          local hl = opts.icon.hl
          if type(hl) == "function" then hl = hl(self) end
          local hlgroup = string.format("Aerial%sIcon", d.kind)
          table.insert(child, 1, {
            provider = string.format("%s ", d.icon),
            hl = (hl and vim.fn.hlexists(hlgroup) == 1) and hlgroup or nil,
          })
        end
        if #data > 1 and i < #data then
          table.insert(child, { provider = opts.separator })
        end -- add a separator only if needed.
        table.insert(children, child)
      end
    end
    if opts.padding.left > 0 then -- add left padding.
      table.insert(
        children,
        1,
        {
          provider = core_utils.pad_string(
            " ",
            { left = opts.padding.left - 1 }
          ),
        }
      )
    end
    if opts.padding.right > 0 then -- add right padding.
      table.insert(
        children,
        {
          provider = core_utils.pad_string(
            " ",
            { right = opts.padding.right - 1 }
          ),
        }
      )
    end
    -- instantiate the new child.
    self[1] = self:new(children, 1)
  end
end

--- An `init` function to build a set of children components for a separated path to file.
---@param opts? table options for configuring the breadcrumbs (default: `{ max_depth = 3, path_func = provider.unique_path(), separator = "  ", suffix = true, padding = { left = 0, right = 0 } }`)
---@return function # The Heirline init function.
-- @usage local heirline_component = { init = require("heirline-components.core").init.separated_path { padding = { left = 1 } } }
function M.separated_path(opts)
  opts = extend_tbl({
    max_depth = 3,
    path_func = provider.unique_path(),
    separator = env.separators.path or "  ",
    suffix = true,
    padding = { left = 0, right = 0 },
  }, opts)
  if opts.suffix == true then opts.suffix = opts.separator end
  return function(self)
    local path = opts.path_func(self)
    if path == "." then path = "" end -- if there is no path, just replace with empty string.
    local data = vim.fn.split(path, "/")
    local children = {}
    -- add prefix if needed, use the separator if true, or use the provided character.
    if opts.prefix and not vim.tbl_isempty(data) then
      table.insert(
        children,
        { provider = opts.prefix == true and opts.separator or opts.prefix }
      )
    end
    local start_idx = 0
    if opts.max_depth and opts.max_depth > 0 then
      start_idx = #data - opts.max_depth
      if start_idx > 0 then
        table.insert(
          children,
          {
            provider = utils.get_icon "Ellipsis"
                .. opts.separator,
          }
        )
      end
    end
    -- create a child for each level.
    for i, d in ipairs(data) do
      if i > start_idx then
        local child = { { provider = d } }
        local separator = i < #data and opts.separator or opts.suffix
        if separator then table.insert(child, { provider = separator }) end
        table.insert(children, child)
      end
    end
    if opts.padding.left > 0 then -- add left padding.
      table.insert(
        children,
        1,
        {
          provider = core_utils.pad_string(
            " ",
            { left = opts.padding.left - 1 }
          ),
        }
      )
    end
    if opts.padding.right > 0 then -- add right padding.
      table.insert(
        children,
        {
          provider = core_utils.pad_string(
            " ",
            { right = opts.padding.right - 1 }
          ),
        }
      )
    end
    -- instantiate the new child
    self[1] = self:new(children, 1)
  end
end

--- An `init` function to build multiple update events which is not supported yet by Heirline's update field.
---@param opts any[] an array like table of autocmd events as either just a string or a table with custom patterns and callbacks.
---@return function # The Heirline init function.
-- @usage local heirline_component = { init = require("heirline-components.core").init.update_events { "BufEnter", { "User", pattern = "LspProgressUpdate" } } }
function M.update_events(opts)
  if not vim.tbl_islist(opts) then opts = { opts } end
  return function(self)
    if not rawget(self, "once") then
      local clear_cache = function() self._win_cache = nil end
      for _, event in ipairs(opts) do
        local event_opts = { callback = clear_cache }
        if type(event) == "table" then
          event_opts.pattern = event.pattern
          if event.callback then
            local callback = event.callback
            event_opts.callback = function(args)
              clear_cache()
              callback(self, args)
            end
          end
          event = event[1]
        end
        vim.api.nvim_create_autocmd(event, event_opts)
      end
      self.once = true
    end
  end
end

--- An `init` function to be called in the 'config' section of heirline
--- to subscribe to the events necessary for our components to work as expected.
-- @usage local heirline_component = { init = require("heirline-components.core").init.subscribe_to_events()
function M.subscribe_to_events()
  -- 1. Apply colors defined above to heirline after applying a theme
  vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Refresh heirline colors",
    callback = function()
      local hl = require "heirline-components.core.hl"
      require("heirline.utils").on_colorscheme(hl.get_colors())
    end,
  })

  -- 2. Update tabs when adding new buffers
  vim.api.nvim_create_autocmd({ "BufAdd", "BufEnter", "TabNewEntered" }, {
    desc = "Update buffers when adding new buffers",
    callback = function(args)
      if not vim.t.bufs then vim.t.bufs = {} end
      if not utils.is_buf_valid(args.buf) then return end
      if args.buf ~= utils.current_buf then
        utils.last_buf = utils.current_buf
        utils.current_buf = args.buf
      end
      local bufs = vim.t.bufs
      if not vim.tbl_contains(bufs, args.buf) then
        table.insert(bufs, args.buf)
        vim.t.bufs = bufs
      end
      vim.t.bufs = vim.tbl_filter(utils.is_buf_valid, vim.t.bufs)
      utils.trigger_event("User HeirlineComponentsUpdateTabline")
    end,
  })

  -- 3. Update tabs when deleting buffers
  vim.api.nvim_create_autocmd("BufDelete", {
    desc = "Update buffers when deleting buffers",
    callback = function(args)
      local removed
      for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        local bufs = vim.t[tab].bufs
        if bufs then
          for i, bufnr in ipairs(bufs) do
            if bufnr == args.buf then
              removed = true
              table.remove(bufs, i)
              vim.t[tab].bufs = bufs
              break
            end
          end
        end
      end
      vim.t.bufs = vim.tbl_filter(utils.is_buf_valid, vim.t.bufs)
      if removed then utils.trigger_event("User HeirlineComponentsUpdateTabline") end
      vim.cmd.redrawtabline()
    end,
  })
end

--- An `init` function for the lsp_progress provider.
---@return function # The lsp clients progress like  { progres = {} }
function M.lsp_progress()
  local lsp = { progress = {} } -- table to return

  -- clear lingering progress messages
  for id, _ in pairs(lsp.progress) do
    if
      not next(vim.lsp.get_active_clients { id = tonumber(id:match "^%d+") })
    then
      lsp.progress[id] = nil
    end
  end

  -- update lsp progress
  local orig_handler = vim.lsp.handlers["$/progress"]
  vim.lsp.handlers["$/progress"] = function(_, msg, info)
    local progress, id = lsp.progress, ("%s.%s"):format(info.client_id, msg.token)
    progress[id] = progress[id] and utils.extend_tbl(progress[id], msg.value) or msg.value
    if progress[id].kind == "end" then
      vim.defer_fn(function()
        progress[id] = nil
        utils.trigger_event("User HeirlineComponentsUpdateLspProgress")
      end, 100)
    end
    utils.trigger_event("User HeirlineComponentsUpdateLspProgress")
    orig_handler(_, msg, info)
  end

  return lsp
end

return M
