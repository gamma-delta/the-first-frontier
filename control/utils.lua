local utils = {}

---@return table
utils.storage_table = function(key)
  if not storage[key] then
    storage[key] = {}
  end
  return storage[key]
end

-- Return a table associated with the entity for extra data.
-- This stores it by unit number! So be careful when iterating
utils.extra = function(entity)
  local entity_key
  if type(entity) == "number" then
    entity_key = entity
  else
    entity_key = entity.unit_number
    if entity_key == nil then
      error("Entity " .. tostring(entity) .. " did not have a unit number!"
        .. " Remember to give it a unit number in prototypes")
    end
  end

  if not storage.extras then storage.extras = {} end
  if not storage.extras[entity_key] then storage.extras[entity_key] = {} end
  return storage.extras[entity_key]
end

utils.smash_events = function(events_lists)
  local evt_to_handlers = {}
  for _,event_pack in ipairs(events_lists) do
    for event,handler in pairs(event_pack) do
      if not evt_to_handlers[event] then evt_to_handlers[event] = {} end
      table.insert(evt_to_handlers[event], handler)
    end
  end
  local out = {}
  for evt,handlers in pairs(evt_to_handlers) do
    out[evt] = function(evt_object)
      for _,handler in ipairs(handlers) do
        handler(evt_object)
      end
    end
  end
  return out
end

-- Return a table that you can splice into a vanilla event handler "veh"
utils.on_any_built = function(callback)
  local cb2 = function(evt)
    evt["entity"] = evt.entity or evt.destination
    callback(evt)
  end
  return {
    [defines.events.on_built_entity] = cb2,
    [defines.events.on_robot_built_entity] = cb2,
    [defines.events.on_entity_cloned] = cb2,
    [defines.events.on_space_platform_built_entity] = cb2,
    [defines.events.script_raised_built] = cb2,
    [defines.events.script_raised_revive] = cb2,
  }
end
utils.on_any_removed = function(callback)
  return {
    [defines.events.on_entity_died] = callback,
    [defines.events.on_player_mined_entity] = callback,
    [defines.events.on_robot_mined_entity] = callback,
    [defines.events.on_space_platform_mined_entity] = callback,
    [defines.events.script_raised_destroy] = callback,
  }
end

-- Returns a table for events and a table for on_nth_ticks
utils.on_type_by_tick = function(entity_name, ticks, fn)
  local events_tbl = utils.on_any_built(function(evt)
    -- This happens if someone places entities on tick 0,
    -- such as tips and tricks
    if not storage.on_type_by_tick then
      storage.on_type_by_tick = {}
    end
    if not storage.on_type_by_tick[entity_name] then
    -- A set of all those entities
      storage.on_type_by_tick[entity_name] = {}
    end

    -- and now for the actual logic
    local entity = evt.entity or evt.destination
    if entity.name == entity_name then
      -- game.print("Registering " .. tostring(entity) .. " for tick evts")
      storage.on_type_by_tick[entity_name][entity] = true
      -- game.print(serpent.block(storage.on_type_by_tick))
    end
  end)

  local function the_handler()
    -- i think storage doesn't exist properly until this point
    if not storage.on_type_by_tick then
      storage.on_type_by_tick = {}
    end
    if not storage.on_type_by_tick[entity_name] then
      -- No entities of this type have been placed
      return
    end
    local to_remove = {}
    for entity,_ in pairs(storage.on_type_by_tick[entity_name]) do
      if entity.valid then
        fn(entity)
      end
      -- in case the function kills the entity
      if not entity.valid then
        table.insert(to_remove, entity)
      end
    end

    for _,entity in ipairs(to_remove) do
      storage.on_type_by_tick[entity_name][entity] = nil
    end
  end
  return events_tbl, {[ticks] = the_handler}
end

return utils
