# heirline-components.nvim
Distro agnostic components you can use in your Neovim heirline config.

![screenshot_2024-02-10_01-17-04_527153682](https://github.com/Zeioth/heirline-components.nvim/assets/3357792/5b1e8dd7-3ae2-4a45-ba79-b0efd2ae6076)

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
WIP: Please be patient.

## Example config
This is a example heirline config that uses heirline-components (WIP).

## Credits
Currently, most of the GPL3 lua components this plugin use come from AstroNvim and NormalNvim. So please support both projects if you enjoy this plugin.

## FAQ
* **How can I contribute with a component?** Go to `core.components` and define yours there. Then send a PR.
* **How do components work?** A component as made of providers. So you can use providers to build your component. Aditionally, conditions are used to decide when a component should be displayed.

## Roadmap
* Ensure all components are agnostic → Let's ensure there are no external dependencies left.
* Implement an aditional component for overseer.
* On the compiler.nvim component (which we may rebrand, or copy as overseer component), try to remove the hotfix condition that prevents overseer from displaying a error on new buffers. They might have fixed that.
