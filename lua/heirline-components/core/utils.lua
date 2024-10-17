--- ### Heirline components core utils.

local M = {}

local env = require("heirline-components.core.env")
local utils = require("heirline-components.utils")

--- Convert a component parameter table to a table
--- that can be used with the component builder.
---@param opts? table a table of provider options.
---@param provider? function|string a provider in `M.providers`.
---@return table|false # the provider table
---                      that can be used in `M.component.builder`.
function M.build_provider(opts, provider, _)
  return opts
      and {
        provider = provider,
        opts = opts,
        condition = opts.condition,
        on_click = opts.on_click,
        update = opts.update,
        hl = opts.hl,
      }
      or false
end

--- Convert key/value table of options to an array of providers
--- for the component builder.
---@param opts table the table of options for the components.
---@param providers string[] an ordered list like array of providers
---                          that are configured in the options table.
---@param setup? function a function that takes provider options table,
---                       provider name, provider index and returns
---                       the setup provider table, optional,
---                       default is `M.build_provider`.
---@return table # the fully setup options table
---                with the appropriately ordered providers.
function M.setup_providers(opts, providers, setup)
  setup = setup or M.build_provider
  for i, provider in ipairs(providers) do
    opts[i] = setup(opts[provider], provider, i)
  end
  return opts
end

--- A utility function to get the width of the bar.
---@param is_winbar? boolean true if you want the width of the winbar,
---                          false if you want the statusline width.
---@return integer # the width of the specified bar.
function M.width(is_winbar)
  return vim.o.laststatus == 3 and not is_winbar and vim.o.columns
      or vim.api.nvim_win_get_width(0)
end

--- Add left and/or right padding to a string.
---@param str string the string to add padding to.
---@param padding table a table of the format `{ left = 0, right = 0}` that defines the number of spaces to include to the left and the right of the string.
---@return string # the padded string.
function M.pad_string(str, padding)
  padding = padding or {}
  return str
      and str ~= ""
      and string.rep(" ", padding.left or 0) .. str .. string.rep(
        " ",
        padding.right or 0
      )
      or ""
end

local function escape(str) return str:gsub("%%", "%%%%") end

--- A utility function to stylize a string with an icon from lspkind,
--- separators, and left/right padding.
---@param str? string the string to stylize.
---@param opts? table options of `{ padding = { left = 0, right = 0 }, separator = { left = "|", right = "|" }, escape = true, show_empty = false, icon = { kind = "NONE", padding = { left = 0, right = 0 } } }`.
---@return string # the stylized string.
-- @usage local string = require("heirline-components.core").utils.stylize("Hello", { padding = { left = 1, right = 1 }, icon = { kind = "String" } })
function M.stylize(str, opts)
  opts = utils.extend_tbl({
    padding = { left = 0, right = 0 },
    separator = { left = "", right = "" },
    show_empty = false,
    escape = true,
    icon = { kind = "NONE", padding = { left = 0, right = 0 } },
  }, opts)
  local icon = M.pad_string(utils.get_icon(opts.icon.kind), opts.icon.padding)
  return str
      and (str ~= "" or opts.show_empty)
      and opts.separator.left .. M.pad_string(
        icon .. (opts.escape and escape(str) or str),
        opts.padding
      ) .. opts.separator.right
      or ""
end

--- Surround component with separator and color adjustment
---@param separator string|string[] the separator index to use in the `separators` table
---@param color function|string|table the color to use as the separator foreground/component background
---@param component table the component to surround
---@param condition boolean|function the condition for displaying the surrounded component
---@param update events? control updating of separators, either a list of events or true to update freely
---@return table # the new surrounded component
function M.surround(separator, color, component, condition, update)
  local function surround_color(self)
    local colors = type(color) == "function" and color(self) or color
    return type(colors) == "string" and { main = colors } or colors
  end

  separator = type(separator) == "string" and env.separators[separator]
      or separator
  local surrounded = { condition = condition }
  local base_separator = {
    update = (update or type(color) ~= "function") and function() return false end,
    init = update and require("heirline-components.core.init").update_events(update),
  }
  if separator[1] ~= "" then
    table.insert(
      surrounded,
      utils.extend_tbl {
        provider = separator[1], --bind alt-j:down,alt-k:up
        hl = function(self)
          local s_color = surround_color(self)
          if s_color then return { fg = s_color.main, bg = s_color.left } end
        end,
      }
    )
  end
  local component_hl = component.hl
  component.hl = function(self)
    local hl = {}
    if component_hl then hl = type(component_hl) == "table" and vim.deepcopy(component_hl) or component_hl(self) end
    local s_color = surround_color(self)
    if s_color then hl.bg = s_color.main end
    return hl
  end
  table.insert(surrounded, component)
  if separator[2] ~= "" then
    table.insert(
      surrounded,
      utils.extend_tbl(base_separator, {
        provider = separator[2],
        hl = function(self)
          local s_color = surround_color(self)
          if s_color then return { fg = s_color.main, bg = s_color.right } end
        end,
      })
    )
  end
  return surrounded
end

---@type false|fun(bufname: string, filetype: string, buftype: string): string?,string?
local cached_icon_provider
--- Resolve the icon and color information for a given buffer
---@param bufnr integer the buffer number to resolve the icon and color of
---@return string? icon the icon string
---@return string? color the hex color of the icon
function M.icon_provider(bufnr)
  if not bufnr then bufnr = 0 end
  local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")
  local filetype = vim.bo[bufnr].filetype
  local buftype = vim.bo[bufnr].buftype
  if cached_icon_provider then return cached_icon_provider(bufname, filetype, buftype) end
  if cached_icon_provider == false then return end

  local _, mini_icons = pcall(require, "mini.icons")
  -- mini.icons
  if _G.MiniIcons then
    cached_icon_provider = function(_bufname, _filetype)
      local icon, hl, is_default = mini_icons.get("file", _bufname)
      if is_default then
        icon, hl, is_default = mini_icons.get("filetype", _filetype)
      end
      local color = require("heirline-components.core.hl").get_hlgroup(hl).fg
      if type(color) == "number" then color = string.format("#%06x", color) end
      return icon, color
    end
    return cached_icon_provider(bufname, filetype, bufname)
  end

  -- nvim-web-devicons
  local devicons_avail, devicons = pcall(require, "nvim-web-devicons")
  if devicons_avail then
    cached_icon_provider = function(_bufname, _filetype, _buftype)
      local icon, color = devicons.get_icon_color(_bufname)
      if not color then
        icon, color = devicons.get_icon_color_by_filetype(_filetype, { default = _buftype == "" })
      end
      return icon, color
    end
    return cached_icon_provider(bufname, filetype, buftype)
  end

  -- fallback to no icon provider
  cached_icon_provider = false
end

--- Encode a position to a single value that can be decoded later.
---@param line integer line number of position.
---@param col integer column number of position.
---@param winnr integer a window number.
---@return integer the encoded position.
function M.encode_pos(line, col, winnr)
  return bit.bor(bit.lshift(line, 16), bit.lshift(col, 6), winnr)
end

--- Decode a previously encoded position to it's sub parts.
---@param c integer the encoded position.
---@return integer line, integer column, integer window
function M.decode_pos(c)
  return bit.rshift(c, 16), bit.band(bit.rshift(c, 6), 1023), bit.band(c, 63)
end

--- Get a list of registered null-ls providers for a given filetype
---@param params table parameters to use for null-ls providers
---@return table # a table of null-ls sources
function M.null_ls_providers(params)
  local registered = {}
  -- try to load null-ls
  local sources_avail, sources = pcall(require, "null-ls.sources")
  if sources_avail then
    -- get the available sources of a given filetype
    for _, source in ipairs(sources.get_available(params.filetype)) do
      -- get each source name
      local runtime_condition = vim.tbl_get(source, "generator", "opts", "runtime_condition")
      for method in pairs(source.methods) do
        local source_activated = true
        if runtime_condition then -- try to calculate runtime_condition with supported parameters
          params.source_id = vim.tbl_get(source, "generator", "source_id")
          local condition_calculated, condition = pcall(runtime_condition, params)
          if condition_calculated then source_activated = condition == true end
        end
        if source_activated then
          registered[method] = registered[method] or {}
          table.insert(registered[method], source.name)
        end
      end
    end
  end
  -- return the found null-ls sources
  return registered
end

--- Get the null-ls sources for a given null-ls method
---@param params table parameters to use for checking null-ls sources
---@return string[] # the available sources for the given filetype and method
function M.null_ls_sources(params)
  local methods_avail, methods = pcall(require, "null-ls.methods")
  return methods_avail and M.null_ls_providers(params)[methods.internal[params.method]] or {}
end

--- A helper function for decoding statuscolumn click events with
--- mouse click pressed, modifier keys,
--- as well as which signcolumn sign was clicked if any.
---@param self any the self parameter from Heirline component on_click.callback function call.
---@param minwid any the minwid parameter from Heirline component on_click.callback function call.
---@param clicks any the clicks parameter from Heirline component on_click.callback function call.
---@param button any the button parameter from Heirline component on_click.callback function call.
---@param mods any the button parameter from Heirline component on_click.callback function call.
---@return table # the argument table with the decoded mouse information and signcolumn signs information.
-- @usage local heirline_component = { on_click = { callback = function(...) local args = require("heirline-components.core").utils.statuscolumn_clickargs(...) end } }
function M.statuscolumn_clickargs(self, minwid, clicks, button, mods)
  local args = {
    minwid = minwid,
    clicks = clicks,
    button = button,
    mods = mods,
    mousepos = vim.fn.getmousepos(),
  }
  if not self.signs then self.signs = {} end
  args.char =
      vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol)
  if args.char == " " then
    args.char =
        vim.fn.screenstring(args.mousepos.screenrow, args.mousepos.screencol - 1)
  end
  args.sign = self.signs[args.char]
  if not args.sign then -- update signs if not found on first click
    for _, sign_def in ipairs(vim.fn.sign_getdefined()) do
      if sign_def.text then
        self.signs[sign_def.text:gsub("%s", "")] = sign_def
      end
    end
    args.sign = self.signs[args.char]
  end
  vim.api.nvim_set_current_win(args.mousepos.winid)
  vim.api.nvim_win_set_cursor(0, { args.mousepos.line, 0 })
  return args
end

return M
