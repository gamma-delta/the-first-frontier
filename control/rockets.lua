local util = require "__core__/lualib/util"
local putil = require("__petraspace__/control/utils")
local pglobals = require("__petraspace__/globals")

local on_any_built = putil.on_any_built(function(evt)
  if evt.entity.name ~= "lunar-rocket-silo" and evt.entity.name ~= "rocket-silo" 
  then
    return
  end

  local gravity = evt.entity.surface.get_property("gravity")
  evt.entity.set_recipe("ps-rocket-part-gravity-" .. tostring(gravity))
  evt.entity.recipe_locked = true
  -- CBA to have the right technology unlock all of it.
  -- If you have a rocket silo you can craft it
  
  if evt.entity.name == "lunar-rocket-silo" then
    local moony_dest = pglobals.planet_moon_map[evt.entity.surface.name]
    if not moony_dest or not evt.entity.force.is_space_location_unlocked(moony_dest) then
      -- https://github.com/danielmartin0/Space-Age-Hardcore-Mode/blob/main/Rocs-Hardcore-Space-Tweaks/data.lua
      -- This is a little janky

      -- This spams it to everyone in the force, a little annoying,
      -- but works for now. Who has friends anyways
      evt.entity.force.print({"text.lunar-rocket-fail-local-system"}, {color=warning_color})
      -- destroy it last so i can print to its user
      evt.entity.destroy()
      return
    end
  end
end)

local function on_rocket_launch(evt)
  local pod = evt.rocket.attached_cargo_pod
  if pod.name == "lunar-cargo-pod" then
    local origin_surface_name = 
      pod.cargo_pod_origin
      and pod.cargo_pod_origin.surface
      and pod.cargo_pod_origin.surface.name
    local moony_dest = pglobals.planet_moon_map[origin_surface_name]
    -- game.print("Found cargo pod " .. tostring(pod) .. ", sending to " .. tostring(moony_dest))
    if moony_dest then
      pod.cargo_pod_destination = {
        type = defines.cargo_destination.surface,
        surface = moony_dest
      }
    else
      -- Bruh
      pod.cargo_pod_destination = {
        type = defines.cargo_destination.surface,
        surface = origin_surface_name
      }
      game.print("How did you manage to launch a lunar rocket on [planet=" .. origin_surface_name .. "] which doesn't have a partner body??? Stop that. You're *lucky* I let you get your items back. Please open a bug report")
    end
  end
end

return {
  events = putil.smash_events{
    on_any_built,
    {
      -- [defines.events.on_rocket_launch_ordered] = on_rocket_launch,
      [defines.events.on_cargo_pod_finished_ascending] = uppies,
   }
  },
}
