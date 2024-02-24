--- ### Heirline highlights.
--
-- DESCRIPTION:
-- Highlight colors we use on the components.

local M = {}
local env = require "heirline-components.core.env"
local config = vim.g.heirline_components_config

--- Get the highlight background color of the lualine theme for the current colorscheme.
---@param mode string the neovim mode to get the color of.
---@param fallback string the color to fallback on if a lualine theme is not present.
---@return string # The background color of the lualine theme or the fallback parameter if one doesn't exist.
function M.lualine_mode(mode, fallback)
  if not vim.g.colors_name then return fallback end
  local lualine_avail, lualine =
      pcall(require, "lualine.themes." .. vim.g.colors_name)
  local lualine_opts = lualine_avail and lualine[mode]
  return lualine_opts and type(lualine_opts.a) == "table" and lualine_opts.a.bg
      or fallback
end

--- Get the highlight for the current mode.
---@return table # the highlight group for the current mode.
-- @usage local heirline_component = { provider = "Example Provider", hl = require("heirline-components.core").hl.mode },
function M.mode() return { bg = M.mode_bg() } end

--- Get the foreground color group for the current mode, good for usage with Heirline surround utility.
---@return string # the highlight group for the current mode foreground.
-- @usage local heirline_component = require("heirline.utils").surround({ "|", "|" }, require("heirline-components.core").hl.mode_bg, heirline_component),

function M.mode_bg() return env.modes[vim.fn.mode()][2] end

--- Get the foreground color group for the current filetype.
---@return table # the highlight group for the current filetype foreground.
-- @usage local heirline_component = { provider = require("heirline-components.core").provider.fileicon(), hl = require("heirline-components.core").hl.filetype_color },
function M.filetype_color(self)
  local devicons_avail, devicons = pcall(require, "nvim-web-devicons")
  if not devicons_avail then return {} end
  local _, color = devicons.get_icon_color(
    vim.fn.fnamemodify(
      vim.api.nvim_buf_get_name(self and self.bufnr or 0),
      ":t"
    ),
    nil,
    { default = true }
  )
  return { fg = color }
end

--- Merge the color and attributes from user settings for a given name.
---@param name string, the name of the element to get the attributes and colors for.
---@param include_bg? boolean whether or not to include background color (Default: false).
---@return table # a table of highlight information.
-- @usage local heirline_component = { provider = "Example Provider", hl = require("heirline-components.core").hl.get_attributes("treesitter") },
function M.get_attributes(name, include_bg)
  local hl = env.attributes[name] or {}
  hl.fg = name .. "_fg"
  if include_bg then hl.bg = name .. "_bg" end
  return hl
end

--- Enable filetype color highlight if enabled in icon_highlights.file_icon options.
---@param name string the icon_highlights.file_icon table element.
---@return function # for setting hl property in a component.
-- @usage local heirline_component = { provider = "Example Provider", hl = require("heirline-components.core").hl.file_icon("winbar") },
function M.file_icon(name)
  local hl_enabled = env.icon_highlights.file_icon[name]
  return function(self)
    if
        hl_enabled == true
        or (type(hl_enabled) == "function" and hl_enabled(self))
    then
      return M.filetype_color(self)
    end
  end
end

--- Get highlight properties for a given highlight name.
---@param name string The highlight group name.
---@param fallback? table The fallback highlight properties.
---@return table properties # the highlight group properties.
function M.get_hlgroup(name, fallback)
  if vim.fn.hlexists(name) == 1 then
    local hl
    if vim.api.nvim_get_hl then -- check for new neovim 0.9 API
      hl = vim.api.nvim_get_hl(0, { name = name, link = false })
      if not hl.fg then hl.fg = "NONE" end
      if not hl.bg then hl.bg = "NONE" end
    else
      hl = vim.api.nvim_get_hl_by_name(name, vim.o.termguicolors)
      if not hl.foreground then hl.foreground = "NONE" end
      if not hl.background then hl.background = "NONE" end
      hl.fg, hl.bg = hl.foreground, hl.background
      hl.ctermfg, hl.ctermbg = hl.fg, hl.bg
      hl.sp = hl.special
    end
    return hl
  end
  return fallback or {}
end

--- This function return a list of colors that can be passed to `heirline.load_colors()`
function M.get_colors()

  local override_colors = false
  local C = nil
  if config.colors then
    C = config.colors
    override_colors = true
  else
    C = env.fallback_colors
  end

  -- Get hlgroups
  local Normal = M.get_hlgroup("Normal", { fg = C.fg, bg = C.bg })
  local Comment =
      M.get_hlgroup("Comment", { fg = C.bright_grey, bg = C.bg })
  local Error = M.get_hlgroup("Error", { fg = C.red, bg = C.bg })
  local StatusLine =
      M.get_hlgroup("StatusLine", { fg = C.fg, bg = C.dark_bg })
  local TabLine = M.get_hlgroup("TabLine", { fg = C.grey, bg = C.none })
  local TabLineFill =
      M.get_hlgroup("TabLineFill", { fg = C.fg, bg = C.dark_bg })
  local TabLineSel =
      M.get_hlgroup("TabLineSel", { fg = C.fg, bg = C.none })
  local WinBar = M.get_hlgroup("WinBar", { fg = C.bright_grey, bg = C.bg })
  local WinBarNC = M.get_hlgroup("WinBarNC", { fg = C.grey, bg = C.bg })
  local Conditional =
      M.get_hlgroup("Conditional", { fg = C.bright_purple, bg = C.dark_bg })
  local String = M.get_hlgroup("String", { fg = C.green, bg = C.dark_bg })
  local TypeDef =
      M.get_hlgroup("TypeDef", { fg = C.yellow, bg = C.dark_bg })
  local NvimEnvironmentName =
      M.get_hlgroup("NvimEnvironmentName", { fg = C.yellow, bg = C.dark_bg })
  local GitSignsAdd =
      M.get_hlgroup("GitSignsAdd", { fg = C.green, bg = C.dark_bg })
  local GitSignsChange =
      M.get_hlgroup("GitSignsChange", { fg = C.orange, bg = C.dark_bg })
  local GitSignsDelete =
      M.get_hlgroup("GitSignsDelete", { fg = C.bright_red, bg = C.dark_bg })
  local DiagnosticError =
      M.get_hlgroup("DiagnosticError", { fg = C.bright_red, bg = C.dark_bg })
  local DiagnosticWarn =
      M.get_hlgroup("DiagnosticWarn", { fg = C.orange, bg = C.dark_bg })
  local DiagnosticInfo =
      M.get_hlgroup("DiagnosticInfo", { fg = C.white, bg = C.dark_bg })
  local DiagnosticHint = M.get_hlgroup(
    "DiagnosticHint",
    { fg = C.bright_yellow, bg = C.dark_bg }
  )
  local HeirlineInactive = M.get_hlgroup("HeirlineInactive", { bg = nil }).bg
      or M.lualine_mode("inactive", C.dark_grey)
  local HeirlineNormal = M.get_hlgroup("HeirlineNormal", { bg = nil }).bg
      or M.lualine_mode("normal", C.blue)
  local HeirlineInsert = M.get_hlgroup("HeirlineInsert", { bg = nil }).bg
      or M.lualine_mode("insert", C.green)
  local HeirlineVisual = M.get_hlgroup("HeirlineVisual", { bg = nil }).bg
      or M.lualine_mode("visual", C.purple)
  local HeirlineReplace = M.get_hlgroup("HeirlineReplace", { bg = nil }).bg
      or M.lualine_mode("replace", C.bright_red)
  local HeirlineCommand = M.get_hlgroup("HeirlineCommand", { bg = nil }).bg
      or M.lualine_mode("command", C.bright_yellow)
  local HeirlineTerminal = M.get_hlgroup("HeirlineTerminal", { bg = nil }).bg
      or M.lualine_mode("insert", HeirlineInsert)

  -- Assign them
  local colors = {
    close_fg = Error.fg,
    fg = StatusLine.fg,
    bg = StatusLine.bg,
    section_fg = StatusLine.fg,
    section_bg = StatusLine.bg,
    git_branch_fg = Conditional.fg,
    mode_fg = StatusLine.bg,
    treesitter_fg = String.fg,
    virtual_env_fg = NvimEnvironmentName.fg,
    scrollbar = TypeDef.fg,
    git_added = GitSignsAdd.fg,
    git_changed = GitSignsChange.fg,
    git_removed = GitSignsDelete.fg,
    diag_ERROR = DiagnosticError.fg,
    diag_WARN = DiagnosticWarn.fg,
    diag_INFO = DiagnosticInfo.fg,
    diag_HINT = DiagnosticHint.fg,
    winbar_fg = WinBar.fg,
    winbar_bg = WinBar.bg,
    winbarnc_fg = WinBarNC.fg,
    winbarnc_bg = WinBarNC.bg,
    tabline_bg = TabLineFill.bg,
    tabline_fg = TabLineFill.bg,
    buffer_fg = Comment.fg,
    buffer_path_fg = WinBarNC.fg,
    buffer_close_fg = Comment.fg,
    buffer_bg = TabLineFill.bg,
    buffer_active_fg = Normal.fg,
    buffer_active_path_fg = WinBarNC.fg,
    buffer_active_close_fg = Error.fg,
    buffer_active_bg = Normal.bg,
    buffer_visible_fg = Normal.fg,
    buffer_visible_path_fg = WinBarNC.fg,
    buffer_visible_close_fg = Error.fg,
    buffer_visible_bg = Normal.bg,
    buffer_overflow_fg = Comment.fg,
    buffer_overflow_bg = TabLineFill.bg,
    buffer_picker_fg = Error.fg,
    tab_close_fg = Error.fg,
    tab_close_bg = TabLineFill.bg,
    tab_fg = TabLine.fg,
    tab_bg = TabLine.bg,
    tab_active_fg = TabLineSel.fg,
    tab_active_bg = TabLineSel.bg,
    inactive = HeirlineInactive,
    normal = HeirlineNormal,
    insert = HeirlineInsert,
    visual = HeirlineVisual,
    replace = HeirlineReplace,
    command = HeirlineCommand,
    terminal = HeirlineTerminal,
  }

  -- Checkings
  for _, section in ipairs {
    "git_branch",
    "file_info",
    "git_diff",
    "diagnostics",
    "lsp",
    "macro_recording",
    "mode",
    "cmd_info",
    "treesitter",
    "nav",
    "virtual_env",
  } do
    if override_colors or not colors[section .. "_bg"] then
      colors[section .. "_bg"] = colors["section_bg"]
    end
    if override_colors or not colors[section .. "_fg"] then
      colors[section .. "_fg"] = colors["section_fg"]
    end
  end
  return colors
end

return M
