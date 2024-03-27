# [heirline-components.nvim](https://github.com/Zeioth/heirline-components.nvim)
Distro agnostic components for your Neovim heirline config.

![screenshot_2024-02-24_01-22-19_324713023](https://github.com/Zeioth/heirline-components.nvim/assets/3357792/ef95f670-4289-4435-bed9-7e74f8ea67af)

This is how the components above look on the statusline.
![screenshot_2024-02-24_01-24-08_523136078](https://github.com/Zeioth/heirline-components.nvim/assets/3357792/14b8a9bf-5ecc-4230-b7a6-9a20911e7628)

<div align="center">
  <a href="https://discord.gg/ymcMaSnq7d" rel="nofollow">
      <img src="https://img.shields.io/discord/1121138836525813760?color=azure&labelColor=6DC2A4&logo=discord&logoColor=black&label=Join the discord server&style=for-the-badge" data-canonical-src="https://img.shields.io/discord/1121138836525813760">
    </a>
</div>

## Table of contents

- [Why](#why)
- [How to install](#how-to-install)
- [How to use](#how-to-use)
- [Example config](#example-config)
- [Components](#components)
- [Available options](#available-options)
- [Events (optional)](https://github.com/Zeioth/heirline-components.nvim?tab=readme-ov-file#events-optional)
- [FAQ](#faq)

## Why
[Heirline](https://github.com/rebelot/heirline.nvim) is a engine to create your own Neovim user interface. This comes at a price though: increased complexity. To avoid that problem, I've decided to compile this collection of components you can fork and modify. That way you have a safe and well tested starting point to hopefuly save you a lot of time.

## How to install
Add it as a dependency of heirline

```lua
{
  "rebelot/heirline.nvim",
  dependencies = { "Zeioth/heirline-components.nvim" }
  opts = {},
    config = function(_, opts)
      local heirline = require "heirline"
      local heirline_components = require "heirline-components.all"

      -- Setup
      heirline_components.init.subscribe_to_events()
      heirline.load_colors(heirline_components.hl.get_colors())
      heirline.setup(opts)
    end,
}
```

Some extra features will only be available if you have the next plugins installed:

* `lewis6991/gitsigns.nvim`
* `nvim-telescope/telescope.nvim`
* `zeioth/compiler.nvim`
* `mfussenegger/nvim-dap`
* `echasnovski/mini.bufremove`
* `nvim-neo-tree/neo-tree.nvim`
* `stevearc/aerial.nvim`
* `folke/zen-mode.nvim`

## How to use
You can add a component to your heirline config as
```lua
require("heirline-components.all").component.some_component()
```
Normally you will use components directly like in this example. But in some cases you can customize a component. Refer to every specific component for more info.

## Example config
You can find the example config we use for NormalNvim [here](https://github.com/NormalNvim/NormalNvim/blob/5d300efbf1d9a06edd3bf6e492e3f8178958edf6/lua/plugins/2-ui.lua#L309).

## Components

### Tabline components
This is the heirline line you see at the top of the screen.

| Component | Description |
|-----------|-------------|
| [tabline_buffers](https://github.com/Zeioth/heirline-components.nvim/wiki/tabline_buffers) | Tabline component to display the listed buffers of the current tabpage. |
| [tabline_tabpages](https://github.com/Zeioth/heirline-components.nvim/wiki/tabline_tabpages) | Tabline component to display the available tabpages. |
| [tabline_conditional_padding](https://github.com/Zeioth/heirline-components.nvim/wiki/tabline_conditional_padding) | Tabine component to add padding under certain conditions. By default it adds padding when you open a side panel like neotree, or aerial, according to the panel width. |

You can control the tabline from your keymappings with [heirline-components.buffer](https://github.com/Zeioth/heirline-components.nvim/wiki/buffer).

### Winbar components
This is the heirline line you see under the tabline.

| Component | Description |
|-----------|-------------|
| [winbar_when_inactive](https://github.com/Zeioth/heirline-components.nvim/wiki/winbar_when_inactive) | If present, it will empty the winbar while the buffer doesn't have the focus (like in the terminal, neotree, etc). |
| [breadcrumbs](https://github.com/Zeioth/heirline-components.nvim/wiki/breadcrumbs) | Winbar component to display a LSP based breadcrumbs section. |
| [compiler_play](https://github.com/Zeioth/heirline-components.nvim/wiki/compiler_play) | Winbar component to display a button to open `compiler.nvim`. |
| [compiler_stop](https://github.com/Zeioth/heirline-components.nvim/wiki/compiler_stop) | Winbar component to display a button to dispose all `compiler.nvim` tasks. |
| [compiler_redo](https://github.com/Zeioth/heirline-components.nvim/wiki/compiler_redo) | Winbar component to display a button to redo the last selected `compiler.nvim` action. |
| [compiler_build_type](https://github.com/Zeioth/heirline-components.nvim/wiki/compiler_build_type) | Winbar component to toggle the current build type of your cmake or gradle project on `compiler.nvim`. |
| [neotree](https://github.com/Zeioth/heirline-components.nvim/wiki/neotree) | Winbar component to display a button to toggle `neotree`. |
| [aerial](https://github.com/Zeioth/heirline-components.nvim/wiki/aerial) | Winbar component to display a button to toggle `aerial`. |
| [zen_mode](https://github.com/Zeioth/heirline-components.nvim/wiki/zen_mode) | Winbar component to display a button to toggle `zen-mode`. |
| [write_buffer](https://github.com/Zeioth/heirline-components.nvim/wiki/write_buffer) | Winbar component to display a button to write the current buffer. |
| [write_all_buffers](https://github.com/Zeioth/heirline-components.nvim/wiki/write_all_buffers) | Winbar component to display a button to write all loaded buffers. |

### Statuscolumn components
This is the heirline column you see at the left of the screen.

| Component | Description |
|-----------|-------------|
| [foldcolumn](https://github.com/Zeioth/heirline-components.nvim/wiki/foldcolumn) | Statuscolumn component to fold/unfold lines. |
| [numbercolumn](https://github.com/Zeioth/heirline-components.nvim/wiki/numbercolumn) | Statuscolumn component to display the line numbers. |
| [signcolumn](https://github.com/Zeioth/heirline-components.nvim/wiki/signcolumn) | Statuscolumn component to indicate the lines that have been changed since the last commit (gitsigns hunks). |

### Statusline components
This is the heirline line you see at the bottom of the screen.

| Component | Description |
|-----------|-------------|
| [fill](https://github.com/Zeioth/heirline-components.nvim/wiki/fill) | Statusline component to fill the empty space of the bar. |
| [file_info](https://github.com/Zeioth/heirline-components.nvim/wiki/file_info) | Statusline component to display the filetype of the current buffer. |
| [file_encoding](https://github.com/Zeioth/heirline-components.nvim/wiki/file_encoding) | Statusline component to display operative system and file encoding. |
| [nav](https://github.com/Zeioth/heirline-components.nvim/wiki/nav) | Statusline component to display a nativation area, with line number, and the current navigation %. |
| [cmd_info](https://github.com/Zeioth/heirline-components.nvim/wiki/cmd_info-component) | Statusline component to display information about some commands, like a macro recording indicator, or the search results. |
| [mode](https://github.com/Zeioth/heirline-components.nvim/wiki/mode-component) | Statusline component for a mode chage. By default it only show colors, but it can be configured to show NORMAL, INSERT... etc like in classic vim. |
| [git_branch](https://github.com/Zeioth/heirline-components.nvim/wiki/git-branch) | Statusline component to display the current git branch. |
| [git_diff](https://github.com/Zeioth/heirline-components.nvim/wiki/git-diff) | Statusline component to display the current git diff (added, removed, changed). |
| [diagnostics](https://github.com/Zeioth/heirline-components.nvim/wiki/diagnostics) | Statusline component to display a diagnostics section (errors, warnings, info). |
| [treesitter](https://github.com/Zeioth/heirline-components.nvim/wiki/treesitter) | Statusline component to display a indicator when Treesitter is enabled. |
| [lsp](https://github.com/Zeioth/heirline-components.nvim/wiki/lsp%E2%80%90component) | Statusline component to display the loaded lsp clients. Or their current load % if they haven't loaded yet. Similar to the plugin [noice.nvim](https://github.com/folke/noice.nvim). |
| [virtual_env](https://github.com/Zeioth/heirline-components.nvim/wiki/virtual_env) | Statusline component to display the current python virtual env. |
| [compiler_state](https://github.com/Zeioth/heirline-components.nvim/wiki/compiler_state) | Statusline component to display a spinner while [compiler.nvim](https://github.com/Zeioth/compiler.nvim) is running. This component is also compatible with [overseer](https://github.com/stevearc/overseer.nvim). |

## Available options
You can customize icons and colors in a easy way.

| Option |
|--------|
| [icons](https://github.com/Zeioth/heirline-components.nvim/wiki/icons) |
| [colors](https://github.com/Zeioth/heirline-components.nvim/wiki/colors) |

For example:
```lua
"rebelot/heirline.nvim",
dependencies = {
  {
    "Zeioth/heirline-components.nvim",
    opts = {
      icons = { DiagnosticError = ";D" }
      colors = nil
    }
  }
}
```

## Events (Optional)
Heirline-components listen for two different events:

| Event | Description |
|--------|------------|
| [ColorScheme](https://neovim.io/doc/user/autocmd.html#ColorScheme) | When you trigger this event, Heirline-components will reload its colors. |
| `User HeirlineComponentsTablineBuffersUpdated` | This event is automatically triggered every time a buffer is added or deleted from the component tabline_buffers (which is ruled by vim.t.bufs). This is useful if you only want to show the tabline when more that 1 buffer is opened. To do so, you can create a autocmd to listen to this event. Then make it set the `vim.opt.showtabline = 2` when `#vim.t.bufs > 1`. |

So if you experience issues with colors or outdated tabline info, trigger these events with `:doautocmd`.

## Credits
Currently, most of the GPL3 lua components this plugin use come from AstroNvim and NormalNvim. So please support both projects if you enjoy this plugin.

## FAQ
* **How can I contribute with a component?** Clone this repo. Go to [core.component.lua](https://github.com/Zeioth/heirline-components.nvim/blob/main/lua/heirline-components/core/component.lua) and create yours there. Then open a PR.
* **How do components work?** A component is made of providers. So you can use providers to build your component. Aditionally, conditions are used to decide when a component should be displayed. These components have been tested on nvim `v0.9.x`
* **How can I avoid breaking changes?** Always use the components by importing `heirline-components.all`. That way internal changes won't affect you. If you wanna be extra sure, you can also lock the plugin version in your package manager to avoid getting updates.

## 🌟 Support the project
If you want to help me, please star this repository to increase the visibility of the project.

[![Stargazers over time](https://starchart.cc/Zeioth/heirline-components.nvim.svg)](https://starchart.cc/Zeioth/heirline-components.nvim)
