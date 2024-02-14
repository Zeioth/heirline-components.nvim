--- ### Heirline components.
--
-- DESCRIPTION:
-- Components we can use on the plugin heirline on any of the opts
-- 'statusline', 'winbar', 'tabline', and 'statuscolumn' options.

-- A component is made of providers.
-- So it is very easy to create your own components!

-- EXAMPLE:
-- Here we create a component that uses the provider 'filename'
-- to show the current filename on heirline:

-- function M.my_component(opts)
--  opts = extend_tbl({ filename = { padding = { left = 1, right = 1 } } }, opts)
--  return M.builder(core_utils.setup_providers(opts, { "filename" }))
-- end

-- NOTE:
-- Because components use the builder design pattern, we don't need to
-- manually require the providers from 'providers.lua'.

--    Components:
--      -> fill
--      -> file_info
--      -> file_encoding
--      -> tabline_conditional_padding
--      -> tabline_buffers
--      -> tabline_tabpages
--      -> nav
--      -> cmd_info
--      -> mode
--      -> breadcrumbs
--      -> breadcrumbs_when_inactive
--      -> separated_path
--      -> git_branch
--      -> git_diff
--      -> diagnostics
--      -> treesitter
--      -> lsp
--      -> virtualenv
--      -> foldcolumn
--      -> numbercolumn
--      -> signcolumn
--      -> compiler_state
--      -> builder

local M = {}

local condition = require "heirline-components.core.condition"
local env = require "heirline-components.core.env"
local hl = require "heirline-components.core.hl"
local init = require "heirline-components.core.init"
local provider = require "heirline-components.core.provider"
local heirline = require "heirline-components.core.heirline"
local core_utils = require "heirline-components.core.utils"

local utils = require "heirline-components.utils"
local extend_tbl = utils.extend_tbl
local get_icon = utils.get_icon
local is_available = utils.is_available

--- A Heirline component for filling in the empty space of the bar.
---@param opts? table options for configuring the other fields
---                   of the heirline component.
---@return table # The heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.fill()
function M.fill(opts)
  return extend_tbl({
    provider = provider.fill(),
    -- Due to a bug in heirline, using update = function on a component present
    -- in "heirline > tabline > statuscolumn" will cause a error.
    -- uncomment the next line once this is fixed (nvim 0.10?).
    -- This is a minor optimization and it is not really important.
    -- update = function() return false end
  },
  opts)
end

--- A function to build a set of children components
--- for an entire file information section.
---@param opts? table options for configuring file_icon, filename, filetype,
---                   file_modified, file_read_only, and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.file_info()
function M.file_info(opts)
  opts = extend_tbl({
    file_icon = {
      hl = hl.file_icon "statusline",
      padding = { left = 1, right = 1 },
      condition = condition.is_file
    },
    filename = false,
    filetype = {},
    file_modified = false,
    file_read_only = {
      padding = { left = 1, right = 1 },
      condition = condition.is_file
    },
    surround = {
      separator = "left",
      color = "file_info_bg",
      condition = condition.has_filetype,
    },
    hl = hl.get_attributes "file_info",
  }, opts)
  return M.builder(core_utils.setup_providers(opts, {
    "file_icon",
    "unique_path",
    "filename",
    "filetype",
    "file_modified",
    "file_read_only",
    "close_button",
  }))
end

--- Displays operative system and file encoding.
---@param opts? table options for configuring file_format, encoding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.file_encoding()
function M.file_encoding(opts)
  opts = extend_tbl({
    file_format = { padding = { left = 1, right = 0 } },
    file_encoding = { padding = { left = 1, right = 0 } },
  }, opts)
  return M.builder(core_utils.setup_providers(opts, {
    "file_format",
    "file_encoding",
  }))
end

--- A function to add padding to the tabine under certain conditions.
--- The amount of padding is defined by the provider, which by default
--- is self-caltulated based on the opened panel.
---@param opts? table Such as: `{ pattern = { filetype = { "", ... }, buftype = { "", ... } } }`
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.tabline_conditional_padding()
function M.tabline_conditional_padding(opts)
  return extend_tbl({
    -- If it returns 1 or more, add padding. If return false, don't.
    condition = function(self)
      self.winid = vim.api.nvim_tabpage_list_wins(0)[1]
      local pattern = (opts and opts.pattern) or {
        filetype = { "aerial", "dapui_.", "dap%-repl", "neo%-tree", "NvimTree", "edgy" },
        buftype = {}
      }
      return condition.buffer_matches(
        pattern,
        vim.api.nvim_win_get_buf(self.winid)
      )
    end,
    -- Amount of padding is self-caltulated based on the opened panel.
    provider = function(self)
      return string.rep(" ", vim.api.nvim_win_get_width(self.winid) + 1)
    end,
    hl = { bg = "tabline_bg" },
  }, opts)
end

--- A function to build a visual component to display the available tabpages.
---@param opts? table Options for configuring the component.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.tabline_tabpages()
function M.tabline_tabpages(opts)
  return extend_tbl({      -- tab list
    condition = function() -- display if more than 1 tab.
      return #vim.api.nvim_list_tabpages() > 1
    end,
    heirline.make_tablist { -- create 1 component per tab.
      provider = provider.tabnr(),
      hl = function(self)
        return hl.get_attributes(heirline.tab_type(self, "tab"), true)
      end,
    },
    { -- close button for current tab
      provider = provider.close_button {
        kind = "TabClose",
        padding = { left = 1, right = 1 },
      },
      hl = hl.get_attributes("tab_close", true),
      on_click = {
        callback = function() utils.close_tab() end,
        name = "heirline_tabline_close_tab_callback",
      },
    },
  }, opts)
end

--- A function to build a visual component to display
--- the available listed buffers of the current tab.
---@param opts? table Options for configuring every individual tabline_file_info() component that form part of this component.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.tabline_buffers()
function M.tabline_buffers(opts)
  return heirline.make_buflist(M.file_info(extend_tbl({
    file_icon = {
      condition = function(self) return not self._show_picker end,
      hl = hl.file_icon "tabline",
    },
    filename = {},
    filetype = false,
    file_modified = {
      padding = { left = 1, right = 1 },
      condition = condition.is_file
    },
    unique_path = {
      hl = function(self) return hl.get_attributes(self.tab_type .. "_path") end,
    },
    close_button = {
      hl = function(self) return hl.get_attributes(self.tab_type .. "_close") end,
      padding = { left = 1, right = 1 },
      on_click = {
        callback = function(_, minwid) utils.close_buf(minwid) end,
        minwid = function(self) return self.bufnr end,
        name = "heirline_tabline_close_buffer_callback",
      },
    },
    padding = { left = 1, right = 1 },
    hl = function(self)
      local tab_type = self.tab_type
      if self._show_picker and self.tab_type ~= "buffer_active" then
        tab_type = "buffer_visible"
      end
      return hl.get_attributes(tab_type)
    end,
    surround = false,
  }, opts)))
end

--- A function to build a set of children components for an entire navigation section
---@param opts? table options for configuring ruler, percentage, scrollbar,
---                   and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.nav()
function M.nav(opts)
  opts = extend_tbl({
    ruler = {},
    percentage = { padding = { left = 1 } },
    scrollbar = { padding = { left = 1 }, hl = { fg = "scrollbar" } },
    surround = { separator = "right", color = "nav_bg" },
    hl = hl.get_attributes "nav",
    update = { "CursorMoved", "CursorMovedI", "BufEnter" },
  }, opts)
  return M.builder(
    core_utils.setup_providers(opts, { "ruler", "percentage", "scrollbar" })
  )
end

--- A function to build a set of children components for information shown
--- in the cmdline.
---@param opts? table options for configuring macro recording, search count,
---                   and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.cmd_info()
function M.cmd_info(opts)
  opts = extend_tbl({
    macro_recording = {
      icon = { kind = "MacroRecording", padding = { right = 1 } },
      condition = condition.is_macro_recording,
      update = {
        "RecordingEnter",
        "RecordingLeave",
        callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
      },
    },
    search_count = {
      icon = { kind = "Search", padding = { right = 1 } },
      padding = { left = 1 },
      condition = condition.is_hlsearch,
    },
    showcmd = {
      padding = { left = 1 },
      condition = condition.is_statusline_showcmd,
    },
    surround = {
      separator = "center",
      color = "cmd_info_bg",
      condition = function()
        return condition.is_hlsearch()
          or condition.is_macro_recording()
          or condition.is_statusline_showcmd()
      end,
    },
    condition = function() return vim.opt.cmdheight:get() == 0 end,
    hl = hl.get_attributes "cmd_info",
  }, opts)
  return M.builder(
    core_utils.setup_providers(
      opts,
      { "macro_recording", "search_count", "showcmd" }
    )
  )
end

--- A function to build a set of children components for a mode section.
---@param opts? table options for configuring mode_text, paste, spell, and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.mode { mode_text = true }
function M.mode(opts)
  opts = extend_tbl({
    mode_text = false,
    paste = false,
    spell = false,
    surround = {
      separator = "left",
      color = hl.mode_bg,
      update = { "ModeChanged",
        pattern = "*:*" }
    },
    hl = hl.get_attributes "mode",
    update = {
      "ModeChanged",
      pattern = "*:*",
      callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
    },
  }, opts)
  if not opts["mode_text"] then opts.str = { str = " " } end
  return M.builder(
    core_utils.setup_providers(
      opts,
      { "mode_text", "str", "paste", "spell" }
    )
  )
end

--- A function to build a set of children components for an LSP breadcrumbs section.
---@param opts? table options for configuring breadcrumbs and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.breadcumbs()
function M.breadcrumbs(opts)
  opts = extend_tbl({
    padding = { left = 1 },
    condition = condition.aerial_available,
    update = "CursorMoved",
  }, opts)
  opts.init = init.breadcrumbs(opts)
  return opts
end

--- This is a alternative version of the breadcrumbs component to show when the window is inactive.
--- In order to work it must be the first component passed to `opts.winbar`.
---@param opts? table options for configuring breadcrumbs and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.breadcrumbs_when_inactive()
function M.breadcrumbs_when_inactive(opts)
  opts = extend_tbl(          {
    condition = function()
      -- don't show on inactive windows.
      local is_win_not_currently_active = not condition.is_active()
      return is_win_not_currently_active
    end,
    M.separated_path(),
    M.file_info {
      file_icon = { hl = hl.file_icon "winbar", padding = { left = 0 } },
      file_modified = false,
      file_read_only = false,
      hl = hl.get_attributes("winbarnc", true),
      surround = false,
      update = "BufEnter",
    },
  }, opts)
  return opts
end

--- A function to build a set of children components for the current file path.
---@param opts? table options for configuring path and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.separated_path()
function M.separated_path(opts)
  opts = extend_tbl(
    { padding = { left = 1 }, update = { "BufEnter", "DirChanged" } },
    opts
  )
  opts.init = init.separated_path(opts)
  return opts
end

--- A function to build a set of children components for a git branch section.
---@param opts? table options for configuring git branch and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.git_branch()
function M.git_branch(opts)
  opts = extend_tbl({
    git_branch = { icon = { kind = "GitBranch", padding = { right = 1 } } },
    surround = {
      separator = "left",
      color = "git_branch_bg",
      condition = condition.is_git_repo,
    },
    hl = hl.get_attributes "git_branch",
    on_click = {
      name = "heirline_branch",
      callback = function()
        if is_available "telescope.nvim" then
          require("telescope.builtin").git_branches { use_file_path = true }
        end
      end,
    },
    update = { "User", pattern = "GitSignsUpdate" },
    init = init.update_events { "BufEnter" },
  }, opts)
  return M.builder(core_utils.setup_providers(opts, { "git_branch" }))
end

--- A function to build a set of children components for a git difference section.
---@param opts? table options for configuring git changes and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.git_diff()
function M.git_diff(opts)
  opts = extend_tbl({
    added = { icon = { kind = "GitAdd", padding = { left = 1, right = 1 } } },
    changed = {
      icon = { kind = "GitChange", padding = { left = 1, right = 1 } },
    },
    removed = {
      icon = { kind = "GitDelete", padding = { left = 1, right = 1 } },
    },
    hl = hl.get_attributes "git_diff",
    on_click = {
      name = "heirline_git",
      callback = function()
        if is_available "telescope.nvim" then
          require("telescope.builtin").git_status { use_file_path = true }
        end
      end,
    },
    surround = {
      separator = "left",
      color = "git_diff_bg",
      condition = condition.git_changed,
    },
    update = { "User", pattern = "GitSignsUpdate" },
    init = init.update_events { "BufEnter" },
  }, opts)
  return M.builder(
    core_utils.setup_providers(
      opts,
      { "added", "changed", "removed" },
      function(p_opts, p)
        local out = core_utils.build_provider(p_opts, p)
        if out then
          out.provider = "git_diff"
          out.opts.type = p
          if out.hl == nil then out.hl = { fg = "git_" .. p } end
        end
        return out
      end
    )
  )
end

--- A function to build a set of children components for a diagnostics section.
---@param opts? table options for configuring diagnostic providers and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.diagnostics()
function M.diagnostics(opts)
  opts = extend_tbl({
    ERROR = {
      icon = { kind = "DiagnosticError", padding = { left = 1, right = 1 } },
    },
    WARN = {
      icon = { kind = "DiagnosticWarn", padding = { left = 1, right = 1 } },
    },
    INFO = {
      icon = { kind = "DiagnosticInfo", padding = { left = 1, right = 1 } },
    },
    HINT = {
      icon = { kind = "DiagnosticHint", padding = { left = 1, right = 1 } },
    },
    surround = {
      separator = "left",
      color = "diagnostics_bg",
      condition = condition.has_diagnostics,
    },
    hl = hl.get_attributes "diagnostics",
    on_click = {
      name = "heirline_diagnostic",
      callback = function()
        if is_available "telescope.nvim" then
          require("telescope.builtin").diagnostics()
        end
      end,
    },
    update = { "DiagnosticChanged", "BufEnter" },
  }, opts)
  return M.builder(
    core_utils.setup_providers(
      opts,
      { "ERROR", "WARN", "INFO", "HINT" },
      function(p_opts, p)
        local out = core_utils.build_provider(p_opts, p)
        if out then
          out.provider = "diagnostics"
          out.opts.severity = p
          if out.hl == nil then out.hl = { fg = "diag_" .. p } end
        end
        return out
      end
    )
  )
end

--- A function to build a set of children components for a Treesitter section.
---@param opts? table options for configuring diagnostic providers and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.treesitter()
function M.treesitter(opts)
  opts = extend_tbl({
    str = { str = "TS", icon = { kind = "ActiveTS", padding = { right = 1 } } },
    surround = {
      separator = "right",
      color = "treesitter_bg",
      condition = condition.treesitter_available,
    },
    hl = hl.get_attributes "treesitter",
    update = { "OptionSet", pattern = "syntax" },
    init = init.update_events { "BufEnter" },
  }, opts)
  return M.builder(core_utils.setup_providers(opts, { "str" }))
end

--- A function to build a set of children components for an LSP section.
---@param opts? table options for configuring lsp progress and client_name providers and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.lsp()
function M.lsp(opts)
  opts = extend_tbl({
    lsp_progress = {
      str = "",
      padding = { right = 1 },
      update = {
        "User",
        pattern = { "BaseLspProgress" },
        callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
      },
    },
    lsp_client_names = {
      str = "LSP",
      update = {
        "LspAttach",
        "LspDetach",
        "BufEnter",
        "VimResized",
        callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
      },
      icon = { kind = "ActiveLSP", padding = { right = 2 } },
    },
    hl = hl.get_attributes "lsp",
    surround = {
      separator = "right",
      color = "lsp_bg",
      condition = condition.lsp_attached,
    },
    on_click = {
      name = "heirline_lsp",
      callback = function() vim.schedule(vim.cmd.LspInfo) end,
    },
  }, opts)
  return M.builder(
    core_utils.setup_providers(
      opts,
      { "lsp_progress", "lsp_client_names" },
      function(p_opts, p, i)
        return p_opts
            and {
              flexible = i,
              core_utils.build_provider(p_opts, provider[p](p_opts)),
              core_utils.build_provider(p_opts, provider.str(p_opts)),
            }
          or false
      end
    )
  )
end

--- A function to get the current python virtual env
---@param opts? table options for configuring the virtual env indicator.
---@return table # The Heirline component table
-- @usage local heirline_component = require("heirline-components.core").virtual_env()
function M.virtual_env(opts)
  opts = extend_tbl({
    virtual_env = { icon = { kind = "Environment", padding = { right = 1 } } },
    surround = {
      separator = "right",
      color = "virtual_env_bg",
      condition = condition.has_virtual_env,
    },
    hl = hl.get_attributes "virtual_env",
  }, opts)
  return M.builder(core_utils.setup_providers(opts, { "virtual_env" }))
end

--- A function to build a set of components for a foldcolumn section in a statuscolumn.
---@param opts? table options for configuring foldcolumn and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.foldcolumn()
function M.foldcolumn(opts)
  opts = extend_tbl({
    foldcolumn = { padding = { right = 1 } },
    condition = condition.foldcolumn_enabled,
    on_click = {
      name = "fold_click",
      callback = function(...)
        local char = core_utils.statuscolumn_clickargs(...).char
        local fillchars = vim.opt_local.fillchars:get()
        if char == (fillchars.foldopen or get_icon "FoldOpened") then
          vim.cmd "norm! zc"
        elseif char == (fillchars.foldclose or get_icon "FoldClosed") then
          vim.cmd "norm! zo"
        end
      end,
    },
  }, opts)
  return M.builder(core_utils.setup_providers(opts, { "foldcolumn" }))
end

--- A function to build a set of components for a numbercolumn section in statuscolumn.
---@param opts? table options for configuring numbercolumn and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.numbercolumn()
function M.numbercolumn(opts)
  opts = extend_tbl({
    numbercolumn = { padding = { right = 1 } },
    condition = condition.numbercolumn_enabled,
    on_click = {
      name = "line_click",
      callback = function(...)
        local args = core_utils.statuscolumn_clickargs(...)
        if args.mods:find "c" then
          if is_available "nvim-dap" then require("dap").toggle_breakpoint() end
        end
      end,
    },
  }, opts)
  return M.builder(core_utils.setup_providers(opts, { "numbercolumn" }))
end

--- A function to build a set of components for a signcolumn section in statuscolumn.
---@param opts? table options for configuring signcolumn and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.signcolumn()
function M.signcolumn(opts)
  opts = extend_tbl({
    signcolumn = {},
    condition = condition.signcolumn_enabled,
    on_click = {
      name = "sign_click",
      callback = function(...)
        local args = core_utils.statuscolumn_clickargs(...)
        if
          args.sign
          and args.sign.name
          and env.sign_handlers[args.sign.name]
        then
          env.sign_handlers[args.sign.name](args)
        end
          vim.cmd(":silent! Gitsigns preview_hunk") -- Show hunk on click
      end,
    },
  }, opts)
  return M.builder(core_utils.setup_providers(opts, { "signcolumn" }))
end

--- Display a spinner while the compiler.nvim is compiling.
---@param opts? table options for configuring compiler_state and the overall padding.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").component.compiler_state()
function M.compiler_state(opts)
  opts = extend_tbl({
    compiler_state = {
      condition = function()
        return is_available "compiler.nvim"
      end,
      padding = { left = 1, right = 0 },
    },
    hl = hl.get_attributes "treesitter",
    on_click = {
      name = "compiler_open",
      callback = function()
        if is_available "compiler.nvim" then
          vim.defer_fn(function() vim.cmd("CompilerToggleResults") end, 100)
        end
      end,
    },
  }, opts)
  return M.builder(core_utils.setup_providers(opts, {
    "compiler_state",
  }))
end

--- A general function to build a section of Heirline providers with highlights,
--- conditions, and section surrounding.
---@param opts? table a list of components to build into a section.
---@return table # The Heirline component table.
-- @usage local heirline_component = require("heirline-components.core").components.builder({ { provider = "file_icon", opts = { padding = { right = 1 } } }, { provider = "filename" } })
function M.builder(opts)
  opts = extend_tbl({ padding = { left = 0, right = 0 } }, opts)
  local children = {}
  if opts.padding.left > 0 then -- add left padding
    table.insert(children, {
      provider = core_utils.pad_string(
        " ",
        { left = opts.padding.left - 1 }
      ),
    })
  end
  for key, entry in pairs(opts) do
    if
      type(key) == "number"
      and type(entry) == "table"
      and provider[entry.provider]
      and (entry.opts == nil or type(entry.opts) == "table")
    then
      entry.provider = provider[entry.provider](entry.opts)
    end
    children[key] = entry
  end
  if opts.padding.right > 0 then -- add right padding
    table.insert(children, {
      provider = core_utils.pad_string(
        " ",
        { right = opts.padding.right - 1 }
      ),
    })
  end
  return opts.surround
      and core_utils.surround(
        opts.surround.separator,
        opts.surround.color,
        children,
        opts.surround.condition,
        opts.surround.update
      )
    or children
end

return M
