--- ### Heirline-components plugin options.

local M = {}

---Parse user options, or set the defaults
---@param opts table|nil A table with options to set.
function M.set(opts)
  if opts == nil then opts = {} end

  M.icons = opts.icons or {
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
  }

  M.colors = opts.colors or {
    none = "NONE",
    fg = "#abb2bf",
    bg = "#1e222a",
    dark_bg = "#2c323c",
    blue = "#61afef",
    green = "#98c379",
    grey = "#5c6370",
    bright_grey = "#777d86",
    dark_grey = "#5c5c5c",
    orange = "#ff9640",
    purple = "#c678dd",
    bright_purple = "#a9a1e1",
    red = "#e06c75",
    bright_red = "#ec5f67",
    white = "#c9c9c9",
    yellow = "#e5c07b",
    bright_yellow = "#ebae34",
  }

  -- expose the config as global
  vim.g.heirline_components_config = M
end

return M
