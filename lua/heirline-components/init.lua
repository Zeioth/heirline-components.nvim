--- ### Heirline-components config.
--
--  DESCRIPTION:
--  We use this file to apply user options.

local M = {}

local config = require("heirline-components.config")

M.setup = function(opts)
  config.set(opts)
end

return M
