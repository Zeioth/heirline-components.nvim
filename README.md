# heirline-components.nvim
Distro agnostic components you can use in your Neovim heirline config.

![screenshot_2024-02-11_23-51-30_787037604](https://github.com/Zeioth/heirline-components.nvim/assets/3357792/74361413-e0cc-4896-8219-dd6fda63dc9a)

This is how the components above look on the statusline.
![screenshot_2024-02-11_20-55-55_224394701](https://github.com/Zeioth/heirline-components.nvim/assets/3357792/3ce6a449-4a9e-4e20-bb00-51df8e25a616)

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
  opts = {}
}
```

## Available components (statusline)

| Component | Description |
|-----------|-------------|
| fill | A Heirline component for filling in the empty space of the bar. |
| file_info | A function to build a set of children components for an entire file information section. |
| file_encoding | Displays operative system and file encoding. |
| tabline_conditional_padding | A function to add padding to the tabine under certain conditions. The amount of padding is defined by the provider, which by default is self-caltulated based on the opened panel. |
| tabline_file_info | A function with different file_info defaults specifically for use in the tabline |
| tabline_tabpages | A function to build a visual component to display the available tabpages. |
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
| breadcrumbs | A function to build a set of children components for an LSP breadcrumbs section. |

## Available components (tabline)
We don't have components for the tabline, but you can use `heirline-components.heirline` that contain helpers for this section.

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
* **What contributions would be very appreciated?** A `mode` component that looks like classic vim would be appreciated by many users.
* **How do components work?** A component is made of providers. So you can use providers to build your component. Aditionally, conditions are used to decide when a component should be displayed.
* **What nvim version do I need?** These components have been tested on nvim `v0.9.x`.
* **How can I avoid breaking changes?** Always use the components by importing `heirline-components.all`. That way internal changes won't affect you. If you wanna be extra sure, you can also lock the plugin version in your package manager to avoid getting updates.
* **Icons look weird:** Make sure you are using nerd fonts. Otherwise you can set the option `icons` to pass a table with your own icons. Chech [here](https://github.com/Zeioth/heirline-components.nvim/blob/main/lua/heirline-components/config.lua).
* **I've found a bug!** Please [report it](https://github.com/Zeioth/heirline-components.nvim/issues) so I can fix it, and make sure you send a screenshot. 
