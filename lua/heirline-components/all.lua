--- ### Heirline-components modules
--
--  DESCRIPTION:
--  We use this file to configure the plugin "Heirline".
--  By having this file, we don't have to require every file separately.

-- if no options were passed, set the default options.
if vim.g.heirline_components_config == nil then
  require("heirline-components.config").set()
end

-- Then return all modules so the user can use them to configure heirline.
return {
  component = require("heirline-components.core.component"),
  condition = require("heirline-components.core.condition"),
  env = require("heirline-components.core.env"),
  heirline = require("heirline-components.core.heirline"),
  hl = require("heirline-components.core.hl"),
  init = require("heirline-components.core.init"),
  provider = require("heirline-components.core.provider"),
  utils = require("heirline-components.core.utils"),
}
