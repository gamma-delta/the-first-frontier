-- Entities that are machines and used cross-planets, and their items
local pglobals = require "globals"

local item_sounds = require("__base__/prototypes/item_sounds")
local sounds = require("__base__/prototypes/entity/sounds")

local rocket_cap = 1000*kg

local function metal_machine_item(entity_id, icon, subgroup, order, splat)
  return util.merge{{
    type = "item",
    name = entity_id,
    icon = icon,
    subgroup = subgroup,
    order = order,
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    place_result = entity_id,
    stack_size = 10,
    weight = rocket_cap / 10,
  }, splat}
end


data:extend{
-- === Card programmers === --
  pglobals.copy_then(
    data.raw["assembling-machine"]["assembling-machine-3"], {
      name = "data-card-programmer",
      energy_usage = "500kW",
      crafting_speed = 1,
      crafting_categories = {"data-card-programming"},
      energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        drain = "50kW",
        emissions_per_minute = { dust=5, pollution=2 },
      },
      minable = {mining_time=0.25, result = "data-card-programmer"},
      source_inventory_size = 1,
    }
  ),
  {
    type = "item",
    name = "data-card-programmer",
    icon = "__base__/graphics/icons/fluid/steam.png",
    subgroup = "production-machine",
    order = "ea[data-card-programmer]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    place_result = "data-card-programmer",
    stack_size = 10,
    weight = rocket_cap / 10
  }
}
-- === Dust === --
local function make_dust_sprayer_layer(dir)
  local sideways = dir == "west" or dir == "east"
  local dy = sideways and 2 or 0
  return {
    layers = {
      {
        filename = "__petraspace__/graphics/entities/dust-sprayer/" .. dir .. ".png",
        width = 202,
        height = 444,
        shift = util.by_pixel(0, -70 + dy),
        scale = 0.5,
      },
      -- TODO shadow
    }
  }
end
data:extend{
  {
    type = "furnace",
    name = "dust-sprayer",
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},

    -- a pump uses 30
    energy_usage = "70kW",
    crafting_speed = 1,
    crafting_categories = {"dust-spraydown"},
    energy_source = {
      type = "electric",
      usage_priority = "secondary-input",
      -- I think this is at passive? Don't consume energy just to stay awake
      -- so that it doesn't passively remove dust
      drain = "0W",
      emissions_per_minute = { dust = -40 },
    },
    minable = {mining_time=0.25, result = "dust-sprayer"},

    graphics_set = {
      always_draw_idle_animation = true,
      idle_animation = {
        north = make_dust_sprayer_layer("north"),
        east = make_dust_sprayer_layer("east"),
        south = make_dust_sprayer_layer("south"),
        west = make_dust_sprayer_layer("west"),
      },
    },
    
    -- urhghhh
    source_inventory_size = 0,
    result_inventory_size = 0,
    fluid_boxes = {
      {
        production_type = "input",
        volume = 1000,
        -- pipe_picture = assembler2pipepictures(),
        pipe_covers = pipecoverspictures(),
        pipe_connections = {{ flow_direction="input", direction = defines.direction.south, position = {0, 1} }},
      }
    },
    fluid_boxes_off_when_no_fluid_recipe = false,
  },
  {
    type = "item",
    name = "dust-sprayer",
    icon = "__base__/graphics/icons/fluid/steam.png",
    subgroup = "production-machine",
    order = "w[dust-sprayer]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    place_result = "dust-sprayer",
    stack_size = 10,
    weight = rocket_cap / 10
  },
}
