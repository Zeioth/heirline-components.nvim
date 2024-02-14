--- ### Heirline-components plugin options.

local M = {}
local extend_tbl = require("heirline-components.utils").extend_tbl

---Parse user options, or set the defaults
---@param opts table|nil A table with options to set.
function M.set(opts)
  if opts == nil then opts = {} end

  --- By default we use nerd icons. But you can specify your own icons.
  --- If you only define one icon, defaults will be used for the rest.
  M.icons =  extend_tbl({
    ActiveLSP = "",
    ActiveTS = "",
    ArrowLeft = "",
    ArrowRight = "",
    Bookmarks = "",
    BufferClose = "󰅖",
    DapBreakpoint = "",
    DapBreakpointCondition = "",
    DapBreakpointRejected = "",
    DapLogPoint = ".>",
    DapStopped = "󰁕",
    Debugger = "",
    DefaultFile = "󰈙",
    Diagnostic = "󰒡",
    DiagnosticError = "",
    DiagnosticHint = "󰌵",
    DiagnosticInfo = "󰋼",
    DiagnosticWarn = "",
    Ellipsis = "…",
    Environment = "",
    FileNew = "",
    FileModified = "",
    FileReadOnly = "",
    FoldClosed = "",
    FoldOpened = "",
    FoldSeparator = " ",
    FolderClosed = "",
    FolderEmpty = "",
    FolderOpen = "",
    Git = "󰊢",
    GitAdd = "",
    GitBranch = "",
    GitChange = "",
    GitConflict = "",
    GitDelete = "",
    GitIgnored = "◌",
    GitRenamed = "➜",
    GitSign = "▎",
    GitStaged = "✓",
    GitUnstaged = "✗",
    GitUntracked = "★",
    LSPLoaded = "",
    LSPLoading1 = "",
    LSPLoading2 = "󰀚",
    LSPLoading3 = "",
    MacroRecording = "",
    Package = "󰏖",
    Paste = "󰅌",
    Refresh = "",
    Run = "󰑮",
    Search = "",
    Selected = "❯",
    Session = "󱂬",
    Sort = "󰒺",
    Spellcheck = "󰓆",
    Tab = "󰓩",
    TabClose = "󰅙",
    Terminal = "",
    Window = "",
    WordFile = "󰈭",
    Test = "󰙨",
    Docs = "",
  }, opts.icons)


  --- Table of colors that will be used as defaults for all components.
  --- Be aware if you define one, you must specify all of them.
  ---
  --- Priority:
  --- user defined > colorscheme → fallback_colors
  M.colors = opts.colors or nil

  -- expose the config as global
  vim.g.heirline_components_config = M
end

return M
