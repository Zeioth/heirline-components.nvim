# heirline-components.nvim
Distro agnostic components you can use in your Neovim heirline config.

![screenshot_2024-02-14_00-54-13_735661835](https://github.com/Zeioth/heirline-components.nvim/assets/3357792/f6d732f9-48b4-46e7-a15d-9fc03c68d434)

This is how the components above look on the statusline.
![screenshot_2024-02-14_00-54-54_383307921](https://github.com/Zeioth/heirline-components.nvim/assets/3357792/5f61572f-4f92-418e-8d67-cb5d7937b388)

<div align="center">
  <a href="https://discord.gg/ymcMaSnq7d" rel="nofollow">
      <img src="https://img.shields.io/discord/1121138836525813760?color=azure&labelColor=6DC2A4&logo=discord&logoColor=black&label=Join the discord server&style=for-the-badge" data-canonical-src="https://img.shields.io/discord/1121138836525813760">
    </a>
</div>

## How to install
Add it as a dependency of heirline

```lua
{
  "rebelot/heirline.nvim",
  dependencies = { "Zeioth/heirline-components.nvim" },
  opts = {},
    config = function(_, opts)
      local heirline = require "heirline"
      local lib = require "heirline-components.all"

      -- Heirline-componets events
      lib.init.subscribe_to_events()

      -- Heirline colors
      heirline.load_colors(lib.hl.get_colors())
      heirline.setup(opts)
    end,
}
```

## Available components (statusline)

| Component | Description |
|-----------|-------------|
| fill | A Heirline component for filling in the empty space of the bar. |
| file_info | A function to build a set of children components for an entire file information section. |
| file_encoding | Displays operative system and file encoding. |
| nav | A function to build a set of children components for an entire navigation section |
| cmd_info | A function to build a set of children components for information shown in the cmdline. |
| mode | A function to build a set of children components for a mode section. |
| separated_path | A function to build a set of children components for the current file path. |
| git_branch | A function to build a set of children components for a git branch section. |
| git_diff | A function to build a set of children components for a git difference section. |
| diagnostics | A function to build a set of children components for a diagnostics section. |
| treesitter | A function to build a set of children components for a Treesitter section. |
| lsp | A function to build a set of children components for an LSP section. |
| virtualenv | A function to get the current python virtual env |
| compiler_state | Display a spinner while [compiler.nvim](https://github.com/Zeioth/compiler.nvim) is running ([overseer](https://github.com/stevearc/overseer.nvim), actually) . |

## Available components (winbar)

| Component | Description |
|-----------|-------------|
| breadcrumbs_when_inactive | A function to build an alternative breadcrumbs component when the window is inactive. |
| breadcrumbs | A function to build a set of children components for an LSP breadcrumbs section. |

## Available components (tabline)

| Component | Description |
|-----------|-------------|
| tabline_conditional_padding | A function to add padding to the tabine under certain conditions. The amount of padding is defined by the provider, which by default is self-caltulated based on the opened panel. |
| tabline_buffers | A function to build a visual component to display the available listed buffers of the current tab. |
| tabline_tabpages | A function to build a visual component to display the available tabpages. |

## Available components (statuscolumn)

| Component | Description |
|-----------|-------------|
| foldcolumn | A function to build a set of components for a foldcolumn section in a statuscolumn. |
| numbercolumn | A function to build a set of components for a numbercolumn section in statuscolumn. |
| signcolumn | A function to build a set of components for a signcolumn section in statuscolumn. |

## Example config
You can find the example config we use for NormalNvim [here](https://github.com/NormalNvim/NormalNvim/blob/75cb58366cc7b143ee0a0ed15499feff44c4555a/lua/plugins/2-ui.lua#L276).

## (Optional) Available options
This is not necessary, but if you want you can customize the icons used by heirline-components

| Option | Accepted values |
|--------|-------------|
| icons  | A table like in [this example](https://github.com/Zeioth/heirline-components.nvim/blob/main/lua/heirline-components/config.lua) |

For example:
```lua
"rebelot/heirline.nvim",
dependencies = {
  {
    "Zeioth/heirline-components.nvim",
    opts = {
      icons = { DiagnosticError = ";D" }
    }
  }
}
```
## Credits
Currently, most of the GPL3 lua components this plugin use come from AstroNvim and NormalNvim. So please support both projects if you enjoy this plugin.

## FAQ
* **How can I contribute with a component?** Clone this repo. Go to [core.component.lua](https://github.com/Zeioth/heirline-components.nvim/blob/main/lua/heirline-components/core/component.lua) and create yours there. Then open a PR.
* **How do components work?** A component is made of providers. So you can use providers to build your component. Aditionally, conditions are used to decide when a component should be displayed.
* **What nvim version do I need?** These components have been tested on nvim `v0.9.x`
* **How can I avoid breaking changes?** Always use the components by importing `heirline-components.all`. That way internal changes won't affect you. If you wanna be extra sure, you can also lock the plugin version in your package manager to avoid getting updates.
* **Icons look weird:** Make sure you are using nerd fonts. Otherwise you can set the option `icons` to pass a table with your own icons. Chech [here](https://github.com/Zeioth/heirline-components.nvim/blob/main/lua/heirline-components/config.lua).
* **I've found a bug!** Please [report it](https://github.com/Zeioth/heirline-components.nvim/issues) so I can fix it, and make sure you send a screenshot. 

## 🌟 Support the project
If you want to help me, please star this repository to increase the visibility of the project.

[![Stargazers over time](https://starchart.cc/Zeioth/heirline-components.nvim.svg)](https://starchart.cc/Zeioth/heirline-components.nvim)

## Roadmap
* ~~wip for `v0.3.0`: new component `tabline_buffers` so we can use it directly.~~
* wip `v0.3.0`: new option `opts.colors` to pass the colors used by the components.
* idea: Maybe there is some way we can automatically do the things we are currently doing in `config` in lazy, so users can further simplify their configs.
* idea: Consider making every component a different file. → Every file is loaded by core.component so we don't get breaking changes.
* idea: Consider adding hyperlinks to the readme, so users can quickly navigate the code of every component, as we did in compiler.nivm → This should greatly increate user participation.
