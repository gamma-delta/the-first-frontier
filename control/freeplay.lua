-- https://codeberg.org/raiguard/Krastorio2/src/branch/master/scripts/freeplay.lua
-- see also __base__/script/freeplay/freeplay.lua for the API
local function add_items()
  if game.simulation then return end
  
  local ship_items = remote.call("freeplay", "get_ship_items")
  -- it looks like these are distributed across all the debris
  local debris_items = remote.call("freeplay", "get_debris_items")
  -- to get you started, and because that's probably what the ship is made out of.
  -- save these for later!
  ship_items["pktff-precision-optical-component"] = 25
  ship_items["transport-belt"] = 20
  ship_items["iron-gear-wheel"] = 100
  debris_items["pktff-aluminum-plate"] = 20
  debris_items["low-density-structure"] = 50
  debris_items["iron-plate"] = 200
  debris_items["electronic-circuit"] = 100
  remote.call("freeplay", "set_debris_items", debris_items)
  remote.call("freeplay", "set_ship_items", ship_items)
end

-- ?????
return {
  on_init = add_items
}
