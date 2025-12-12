local util = require "__core__/lualib/util"
local putil = require("__pk-the-first-frontier__/control/utils")

local special_dust_immune = {
  ["pktff-dust-secret-beacon"] = true,
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
  if surface.pollutant_type and surface.pollutant_type.name == "pktff-dust"
    and not is_dust_immune(entity)
  then
    local secret_beacon = surface.create_entity{
      name = "pktff-dust-secret-beacon",
      position = entity.position,
      force = evt.force,
      raise_built = true,
    }
    -- Map destroy ID to child beacon
    local destroy_id,_,_ = script.register_on_object_destroyed(entity)
    putil.storage_table("dust-beacon-parents")[destroy_id] = secret_beacon
    table.insert(putil.storage_table("dust-beacon-tickers"), secret_beacon)
    game.print("Created beacon " .. tostring(secret_beacon) .. " parented to " .. tostring(entity))
  end
end

---@param evt EventData.on_object_destroyed
local function check_kill_child_beacon(evt)
  local dbp = putil.storage_table("dust-beacon-parents")
  if
    evt.type == defines.target_type.entity
    and dbp[evt.registration_number]
  then
    dbp[evt.registration_number].die()
    dbp[evt.registration_number] = nil
  end
end

---@param evt NthTickEventData
local function beacon_tick(evt)
  local buckets = 10
  local offset = math.floor(evt.tick / evt.nth_tick) % buckets
  local dbt = putil.storage_table("dust-beacon-tickers")
  -- Iterate backwards so that removing is safe
  for i = #dbt - offset, 1, -buckets do
    local beacon = dbt[i]
    if not beacon.valid then
      table.remove(dbt, i)
    else
      local pollution_to_slowdown_percent = settings.global["pktff-dust-to-1percent-slower"].value
      local pollution_amt = beacon.surface.get_pollution(beacon.position)
      local module_count = math.floor(pollution_amt / pollution_to_slowdown_percent)
      local mi = beacon.get_module_inventory()
      game.print("Putting " .. module_count .. " modules in " .. serpent.line(beacon))
      mi.clear()
      if module_count > 0 then
        mi.insert({ name="pktff-dust-secret-module", count=module_count })
      end
    end
  end
end

return {
  events = util.merge{
    putil.on_any_built(create_secret_beacon),
    {[defines.events.on_object_destroyed] = check_kill_child_beacon}
  },
  on_nth_tick = {[6] = beacon_tick},
}
