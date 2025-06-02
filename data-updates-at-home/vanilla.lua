local pglobals = require("__petraspace__/globals")
local rocket_cap = 1000 * kg;

-- Move gasses to be gasses
local function togas(name, order)
  local gas = data.raw["fluid"][name]
  gas.subgroup = "gasses"
  gas.order = "a[existing-gas]-" .. order
end
togas("steam", "a")
togas("petroleum-gas", "b")
togas("ammonia", "c")
togas("fluorine", "d")
-- i guess it's a "gas"
-- source: they might be giants
togas("fusion-plasma", "e")

-- Assign crafting categories
table.insert(data.raw["assembling-machine"]["chemical-plant"].crafting_categories, "electrochemistry")
table.insert(data.raw["assembling-machine"]["electromagnetic-plant"].crafting_categories, "electrochemistry")
table.insert(data.raw["furnace"]["stone-furnace"].crafting_categories, "dirty-smelting")
table.insert(data.raw["furnace"]["steel-furnace"].crafting_categories, "dirty-smelting")

-- Make flamethrower turrets have Consequences
-- It looks like each individual blob of flame in a stream is a separate object.
-- They last for 2-3 seconds each.
-- Let's make it as bad as a normal mining drill?
for _,path in ipairs{"flamethrower-fire-stream", "handheld-flamethrower-fire-stream"} do
  local obj = data.raw["stream"][path]
  obj.emissions_per_second = {pollution=10/60}
end

-- Make uranium require more H2SO4
local uore = data.raw["resource"]["uranium-ore"]
-- default is 10
uore.minable.fluid_amount = 50

-- Make heating towers pollute more than burners
-- Wiki says that HTs make 24MJ/pollution, boilers make 3.6MJ
-- So HTs are 6 2/3 times better.
local ht = data.raw["reactor"]["heating-tower"]
ht.energy_source.emissions_per_minute.pollution = 100 * 20

-- Make the nuclear reactor get hot enough to power the foundry
data.raw["reactor"]["nuclear-reactor"].heat_buffer.max_temperature = 2000
local heat_pipe = data.raw["heat-pipe"]["heat-pipe"].heat_buffer
-- it takes a WHOLE MEGAWATT to heat a heat pipe by 1 degree in vanilla.
-- Jesus, no wonder reactors take so long to spin up.
heat_pipe.specific_heat = "100kJ"
heat_pipe.max_transfer = "100MW"

-- Let you place the rocket silo on airless moons but not space platforms
data.raw["rocket-silo"]["rocket-silo"].surface_conditions = 
  {{property="gravity", min=1}}
-- Thruster only on splatform
data.raw["thruster"]["thruster"].surface_conditions = 
  {{property="gravity", max=0}}

-- Augh
-- Stick anything in a lunar rocket silo
local item_types = {
  "item", "ammo", "capsule", "gun",
  "item-with-entity-data", "item-with-label",
  "item-with-inventory", "item-with-tags",
  "module", "rail-planner", "tool", "armor", "repair-tool"
  -- Omitting blueprint books, selection tools, and the
  -- splatform starter pack
}
for _,item in pairs(data.raw["item"]) do
  if item.send_to_orbit_mode == nil or item.send_to_orbit_mode == "not-sendable" then
    item.send_to_orbit_mode = "manual"
  end
end

-- Make slower items easier to ship up to space
data.raw["item"]["transport-belt"].weight = rocket_cap / 200
data.raw["item"]["fast-transport-belt"].weight = rocket_cap / 100
data.raw["item"]["express-transport-belt"].weight = rocket_cap / 100
-- turbo is already 50
data.raw["item"]["inserter"].weight = rocket_cap / 100
data.raw["item"]["long-handed-inserter"].weight = rocket_cap / 50
data.raw["item"]["bulk-inserter"].weight = rocket_cap / 25
data.raw["item"]["stack-inserter"].weight = rocket_cap / 10

data.raw["item"]["assembling-machine-1"].weight = rocket_cap / 100
-- you use chemmy plants much more than in vanilla,
-- frankly i'm surprised they didn't already update it
data.raw["item"]["chemical-plant"].stack_size = 50
data.raw["item"]["chemical-plant"].weight = rocket_cap / 50

-- Remove OG rocket juice recipes
data.raw["recipe"]["thruster-fuel"].hidden = true
data.raw["recipe"]["thruster-oxidizer"].hidden = true
data.raw["recipe"]["advanced-thruster-fuel"].hidden = true
data.raw["recipe"]["advanced-thruster-oxidizer"].hidden = true

-- Make oxide asteroids drop quicklime
-- It turns out that we don't actually know very much about the makeup
-- of comets, so this is 100% alright (lies)
data.raw["recipe"]["advanced-oxide-asteroid-crushing"].results[2].name = "quicklime"

-- Greatly reduce the number of asteroids between the inner planets,
-- and somewhat reduce the amount in orbit.
for _,planet in ipairs{"nauvis", "vulcanus", "fulgora", "gleba"} do
  local planet_proto = data.raw["planet"][planet]
  for _,asd in ipairs(planet_proto.asteroid_spawn_definitions) do
    if asd.type == "entity" then
      asd.probability = asd.probability * 0.1
    end
  end
end
for _,connection in ipairs{
  "nauvis-vulcanus", "nauvis-gleba", "nauvis-fulgora",
  "vulcanus-gleba", "gleba-fulgora",
} do
  local conn_proto = data.raw["space-connection"][connection]
  conn_proto.length = conn_proto.length
  for _,asd in ipairs(conn_proto.asteroid_spawn_definitions) do
    if asd.type == "entity" then
      asd.probability = asd.probability * 0.01
    end
  end
end

-- Remove drag in space. Why is there drag in space?
local og_expression = [[
  (thrust / (1 + weight / 10000000)
    - ((1500 * speed * speed + 1500 * abs(speed)) * (width * 0.5) + 10000)
      * sign(speed)
  ) / weight / 60"
]]
-- F = ma
-- ~> a = F/m
-- However to mock the tyranny of the rocket equation, I'm going to make
-- force affect it slightly less than linearly.
-- Unclear about the units here, either.
-- - Thrust is in N? 
-- - Weight is in g
-- - Speed is probably in km/s
-- - And I return km/s^2?
-- Guessing this because when the platform is still, the thrusters report
-- "0 N", but the speed reports "0 km/s"
-- However, if I just do thrust/weight then it SCREAMS OFF INTO THE SUNSET
-- so include a fudge factor.
data.raw["utility-constants"]["default"].space_platform_acceleration_expression = 
[[
  ((thrust/1000)^0.99 * 1000) / (1 + weight)
  / 1e4
]]
-- And make thrusters sip up more juice
-- The thrust will be the same per unit, i think
local thruster = data.raw["thruster"]["thruster"]
thruster.min_performance.fluid_usage = thruster.min_performance.fluid_usage * 10
thruster.max_performance.fluid_usage = thruster.max_performance.fluid_usage * 10

-- Nuke cells have 10x the cost, give them ~10x the power
data.raw["item"]["uranium-fuel-cell"].fuel_value = "50GJ"

-- Give centrifuges many module slots, to make them feel more like Nauvis'
-- special building
local centri = data.raw["assembling-machine"]["centrifuge"]
centri.module_slots = 6
-- this makes the centrifuge wiggle faster, but tbqh i like it
centri.crafting_speed = 2
local eppp = require("__space-age__/prototypes/entity/electromagnetic-plant-pictures")
centri.fluid_boxes_off_when_no_fluid_recipe = true
-- Setting input-output on input FBs is what the EM plant does
-- It looks like it somehow intelligently "knows" to passthru the fluid?
local function centri_fb(io, dir, pos)
  return {
    production_type = io,
    pipe_picture = eppp.pipe_pictures,
    pipe_picture_frozen = eppp.pipe_pictures_frozen,
    pipe_covers = pipecoverspictures(),
    volume = 200,
    pipe_connections = {{
      flow_direction="input-output",
      direction=defines.direction[dir],
      position=pos
    }},
    secondary_draw_orders = {
      north = -1,
      south = 1,
      west = -1,
      east = -1
    }
  }
end
centri.fluid_boxes = {
  centri_fb("input", "west", {-1, 0}),
  centri_fb("input", "east", {1, 0}),
  centri_fb("output", "north", {0, -1}),
  centri_fb("output", "south", {0, 1}),
}
