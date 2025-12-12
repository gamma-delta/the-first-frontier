local pglobals = require "globals"
local item_sounds = require("__base__/prototypes/item_sounds")
local rocket_cap = 1000*kg

-- TODO: fiddle with this amount
local function make_rocket_juice_tank_item(name, place_result, overlay)
  return {
    type = "item",
    name = name,
    stack_size = 1,
    icons = pglobals.icons.mini_over(
      overlay,
      "__base__/graphics/icons/storage-tank.png"
    ),
    subgroup = "space-related",
    -- TODO order
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    weight = rocket_cap,
    place_result = place_result
  }
end
local function make_rocket_juice_tank(mode, juice_name)
  local path = Asset"graphics/entities/propellant-tank/" .. mode .. "-1.png"

  return {
    type = "storage-tank",
    name = "pktff-platform-" .. mode .. "-tank",
    icon = "__base__/graphics/icons/storage-tank.png",
    flags = {"placeable-player", "placeable-neutral", "not-rotatable"},
    created_effect = pglobals.script_created_effect("pktff-rocket-juice-tank"),
    selection_box = {{-2.4, -5.5}, {2.5, 5.5}},
    collision_box = {{-2.45, -5.45}, {2.45, 5.45}},
    window_bounding_box = {{-1, -3}, {1, 3}},
    flow_length_in_ticks = 360,

    minable = {mining_time=5, result="pktff-empty-platform-tank"},
    surface_conditions = {{property="gravity", max=0}},

    fluid_box = {
      volume = pglobals.platform_juice_tank_volume,
      filter = juice_name,
      pipe_connections = {
        {
          direction=defines.direction.south,
          position={0, 5},
        },
      },
    },

    pictures = {
      picture = {
        filename = path,
        width = 64 * 5,
        height = 64 * 11,
        scale = 0.5,
      }
    }
  }
end

data:extend{
  make_rocket_juice_tank_item("pktff-empty-platform-tank", nil, "__core__/graphics/icons/alerts/fluid-icon-red.png"),
  make_rocket_juice_tank_item("pktff-platform-fuel-tank", "pktff-platform-fuel-tank", "__space-age__/graphics/icons/fluid/thruster-fuel.png"),
  make_rocket_juice_tank_item("pktff-platform-oxidizer-tank", "pktff-platform-oxidizer-tank", "__space-age__/graphics/icons/fluid/thruster-oxidizer.png"),
  make_rocket_juice_tank("fuel", "thruster-fuel"),
  make_rocket_juice_tank("oxidizer", "thruster-oxidizer"),
}

-- Spaaaaace!
--[[
Scooping another lordmiguel idea thanks :]
I am just going to make them long and tall solar panels
that only require the *center* tile to be placed on a foundation
]]
data:extend{
  pglobals.copy_then(data.raw["solar-panel"]["solar-panel"], {
    name = "pktff-platform-solar-array",
    flags = {"placeable-player", "placeable-neutral", "player-creation"},
    icon = Asset"graphics/icons/platform-solar-array.png",
    minable = { mining_time=1, result="pktff-platform-solar-array" },
    -- 15 x 5
    -- the picture is closer to 15x6, but hush
    -- This collision box is mixel-y, but i would be surprised if anyone noticed
    -- Basically it has a "real" footprint of 7 tiles high, but you can
    -- cram another solar panel in right next to it
    collision_box = {{-7.4, -2.9}, {7.4, 2.9}},
    selection_box = {{-7.5, -3}, {7.5, 3}},
    tile_width = 15, tile_height = 5,
    surface_conditions = {{ property="gravity", max=0 }},
    -- Asteroids only deal damage when hitting foundation, then they damage
    -- whatever is on top.
    -- So I can't make all of the panel take damage, ... just the
    -- central spine you'll need to build
    collision_mask = { layers = {
      is_object=true, is_lower_object=true, transport_belt=true,
    }},
    tile_buildability_rules = {{
      area={{-0.4, -0.4}, {0.4, 0.4}},
      required_tiles={layers={ ground_tile=true }},
      colliding_tiles={layers={ empty_space=true }},
      remove_on_collision=true,
    }},
    placeable_position_visualization = pglobals.placevis,
    picture = {
      filename = Asset"graphics/entities/platform-solar-array.png",
      width = 955, height = 385,
      scale = 0.5,
    },
    overlay = pglobals.null,
    energy_source = { type = "electric", usage_priority = "solar" },
    -- It is 10x as large as a solar panel; let's give 8x the power
    production = "480kW",
  }),
  pglobals.copy_then(data.raw["item"]["solar-panel"], {
    name = "pktff-platform-solar-array",
    icon = Asset"graphics/icons/platform-solar-array.png",
    subgroup = "space-platform",
    order = "az[platform-solar-array]",
    stack_size = 10,
    weight = rocket_cap / 10,
    place_result = "pktff-platform-solar-array",
  }),
}
