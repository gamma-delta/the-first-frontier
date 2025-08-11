local util = require "__core__/lualib/util"
local putil = require("__petraspace__/control/utils")

local special_dust_immune = {
  ["dust-secret-beacon"] = true,
}
local function is_dust_immune(entity)
  return
    special_dust_immune[entity.name]
    or entity.prototype.effect_receiver == nil
    or entity.prototype.module_inventory_size == 0
end

local function create_secret_beacon(evt)
  local entity = evt.entity
  local surface = entity.surface

  -- TODO: how to mark entity as immune to dust?
  -- ancillary keys don't get carried through to the runtime stage
  if surface.pollutant_type and surface.pollutant_type.name == "dust" 
    and not is_dust_immune(entity)
  then
    local secret_beacon = surface.create_entity{
      name = "dust-secret-beacon",
      position = entity.position,
      force = evt.force,
      raise_built = true,
    }
    game.print("Created beacon " .. tostring(secret_beacon) .. " parented to " .. tostring(entity))
    local extra = putil.extra(secret_beacon)
    extra.parent = entity
  end
end

local otbt_events, otbt_nth = putil.on_type_by_tick(
  "dust-secret-beacon", 60 * 10,
  function(secret_beacon)
    local dat = putil.extra(secret_beacon)
    -- game.print("Secret beacon extra: " .. serpent.block(dat))
    if dat.parent and dat.parent.valid then
      local pollution_to_slowdown_percent = settings.global["ps-dust-to-1percent-slower"].value
      local pollution_amt = secret_beacon.surface.get_pollution(secret_beacon.position)
      local module_count = math.floor(pollution_amt / pollution_to_slowdown_percent)
      local mi = secret_beacon.get_module_inventory()
      -- game.print("Putting " .. module_count .. " modules in " .. serpent.line(secret_beacon))
      mi.clear()
      if module_count > 0 then
        mi.insert({ name="dust-secret-module", count=module_count })
      end
    else
      -- game.print("Beacon " .. tostring(secret_beacon) .. " was invalid, killing")
      secret_beacon.die()
    end
  end)

return {
  events = putil.smash_events{
    putil.on_any_built(create_secret_beacon),
    otbt_events
  },
  on_nth_tick = otbt_nth
}
