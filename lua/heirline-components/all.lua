--- ### Heirline-components modules
--
--  DESCRIPTION:
--  We use this file to configure the plugin "Heirline".
--  By having this file, we don't have to require every file separately.

return {
  component = require "heirline-components.core.component",
  condition = require "heirline-components.core.condition",
  env = require "heirline-components.core.env",
  heirline = require "heirline-components.core.heirline",
  hl = require "heirline-components.core.hl",
  init = require "heirline-components.core.init",
  provider = require "heirline-components.core.provider",
  utils = require "heirline-components.core.utils",
}
