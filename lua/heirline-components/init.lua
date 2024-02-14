--- ### Heirline-components config.
--
--  DESCRIPTION:
--  We use this file to apply user options.

local M = {}

local config = require "heirline-components.config"

M.setup = function(opts)
  config.set(opts)
  require("heirline-components.all").init.subscribe_to_events()

end

return M

