local util = require "__core__/lualib/util"
local putil = require("__petraspace__/control/utils")
local pglobals = require("__petraspace__/globals")

local on_any_built = putil.on_any_built(function(evt)
  if evt.entity.name ~= "rocket-silo" then return end

  local gravity = evt.entity.surface.get_property("gravity")
  evt.entity.set_recipe("ps-rocket-part-gravity-" .. tostring(gravity))
  evt.entity.recipe_locked = true
  -- CBA to have the right technology unlock all of it.
  -- If you have a rocket silo you can craft it
end)

return {
  events = on_any_built,
}
