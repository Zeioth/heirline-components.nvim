--- ### Heirline-components plugin options.

local M = {}
local extend_tbl = require("heirline-components.utils").extend_tbl

---Parse user options, or set the defaults
---@param opts table|nil A table with options to set.
function M.set(opts)
  if opts == nil then opts = {} end

  --- By default we use nerd icons. But you can specify your own icons.
  --- If you only define one icon, defaults will be used for the rest.
  M.icons = extend_tbl({
    -- Heirline-components - tabline
    TabClose = "󰅙",
    BufferClose = "󰅖",
    ArrowLeft = "",
    ArrowRight = "",
    FileModified = "",
    FileReadOnly = "",

    -- Heirline-components - winbar
    CompilerPlay = "",
    CompilerStop = "",
    CompilerRedo = "",
    NeoTree = "",
    Aerial = "",
    ZenMode = "󰰶",
    BufWrite = "",
    BufWriteAll = "",
    Ellipsis = "…",
    BreadcrumbSeparator = "",

    -- Heirline-components - statuscolumn
    FoldClosed = "",
    FoldOpened = "",
    FoldSeparator = " ",

    -- Heirline-components - statusline components
    ActiveLSP = "",
    ActiveTS = "",
    Environment = "",
    DiagnosticError = "",
    DiagnosticHint = "󰌵",
    DiagnosticInfo = "󰋼",
    DiagnosticWarn = "",
    LSPLoading1 = "",
    LSPLoading2 = "󰀚",
    LSPLoading3 = "",
    Find = "",
    MacroRecording = "",
    ToggleResults = "󰑮",

    -- Heirline-components - misc
    Paste = "󰅌",
    PathSeparator = "",

    -- Git
    GitBranch = "",
    GitAdd = "",
    GitChange = "",
    GitDelete = "",
  }, opts.icons)

  --- Table of colors that will be used as defaults for all components.
  --- Be aware if you define the table, you must specify all colors.
  --- Otherwise ugly fallback colors  will be used instead.
  ---
  --- Priority:
  --- user defined > colorscheme → fallback_colors
  M.colors = opts.colors or nil

  -- expose the config as global
  vim.g.heirline_components_config = M
end

return M
