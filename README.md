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

## Credits
Many of the GPL3 lua components this plugin use come from AstroNvim > NormalNvim. So please support both projects if you enjoy this plugin.

## Roadmap
* Cleanup utils → Delete functions that are not used in the code from `init.lua` and `buffer.lua`.
* Refactor → Let's try to organize the code in a more semantically meaningful way.
* In the compiler.nvim component (which we may rebrand, or copy as overseer component), try to remove the condition that prevents overseer from displaying a error on new buffers. They might have fixed that.
