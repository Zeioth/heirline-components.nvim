# heirline-components.nvim
Distro agnostic components you can use in your Neovim heirline config.

![screenshot_2024-02-10_01-17-04_527153682](https://github.com/Zeioth/heirline-components.nvim/assets/3357792/5b1e8dd7-3ae2-4a45-ba79-b0efd2ae6076)

This is how those heirline components look on the statusline.
![screenshot_2024-02-11_20-55-55_224394701](https://github.com/Zeioth/heirline-components.nvim/assets/3357792/3ce6a449-4a9e-4e20-bb00-51df8e25a616)

## How to install
Add it as a dependency of heirline

```lua
{
  "rebelot/heirline.nvim",
  dependencies = { "Zeioth/heirline-components.nvim" },
  opts = {}
}
```

## Available components

| Component | Description |
|-----------|-------------|
| fill | A Heirline component for filling in the empty space of the bar. |
| file_info | A function to build a set of children components for an entire file information section. |
| file_encoding | Displays operative system and file encoding. |
| tabline_file_info | A function with different file_info defaults specifically for use in the tabline |
| nav | A function to build a set of children components for an entire navigation section |
| cmd_info | A function to build a set of children components for information shown in the cmdline. |
| mode | A function to build a set of children components for a mode section. |
| breadcrumbs | A function to build a set of children components for an LSP breadcrumbs section. |
| separated_path | A function to build a set of children components for the current file path. |
| git_branch | A function to build a set of children components for a git branch section. |
| git_diff | A function to build a set of children components for a git difference section. |
| diagnostics | A function to build a set of children components for a diagnostics section. |
| treesitter | A function to build a set of children components for a Treesitter section. |
| lsp | A function to build a set of children components for an LSP section. |
| virtualenv | A function to get the current python virtual env |
| foldcolumn | A function to build a set of components for a foldcolumn section in a statuscolumn. |
| signcolumn | A function to build a set of components for a signcolumn section in statuscolumn. |
| compiler_state | Display an spinner while compiler.nvim is compiling. |

## Example config
This is a example heirline config that uses heirline-components (WIP).

## Credits
Currently, most of the GPL3 lua components this plugin use come from AstroNvim and NormalNvim. So please support both projects if you enjoy this plugin.

## FAQ
* **How can I contribute with a component?** Go to `core.components` and define yours there. Then send a PR.
* **How do components work?** A component as made of providers. So you can use providers to build your component. Aditionally, conditions are used to decide when a component should be displayed.
* **What nvim version do I need?** These components have been tested on nvim `v0.9.x`.
* **How can I avoid breaking changes?** Always use the components by importing `heirline-components.all`. That way internal changes (that will likely happen) won't affect you.

## Roadmap
* BUXFIX: Currently icons will fail to load. Let's create a config optio so users can pass them (and let's also define defaults).
* Ensure all components are agnostic → Let's ensure there are no external dependencies left.
* Implement an aditional component for overseer.
* On the compiler.nvim component (which we may rebrand, or copy as overseer component), try to remove the hotfix condition that prevents overseer from displaying a error on new buffers. They might have fixed that.
