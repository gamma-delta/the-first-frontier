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

-- === Dust === --
local function make_dust_sprayer_layer(dir)
  local sideways = dir == "west" or dir == "east"
  local dy = sideways and 2 or 0
  return {
    layers = {
      {
        filename = Asset"graphics/entities/dust-sprayer/" .. dir .. ".png",
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
    name = "pktff-dust-sprayer",
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
    collision_box = {{-1.4, -1.4}, {1.4, 1.4}},

    -- a pump uses 30
    energy_usage = "70kW",
    crafting_speed = 1,
    crafting_categories = {"pktff-dust-spraydown"},
    energy_source = {
      type = "electric",
      usage_priority = "secondary-input",
      -- I think this is at passive? Don't consume energy just to stay awake
      -- so that it doesn't passively remove dust
      drain = "0W",
      emissions_per_minute = { ["pktff-dust"] = -40 },
    },
    minable = {mining_time=0.25, result = "pktff-dust-sprayer"},

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
    name = "pktff-dust-sprayer",
    icon = "__base__/graphics/icons/fluid/steam.png",
    subgroup = "production-machine",
    order = "w[dust-sprayer]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    place_result = "pktff-dust-sprayer",
    stack_size = 10,
    weight = rocket_cap / 10
  },
}


local function inserter_pic(cfg)
  return {
    filename = cfg.filename,
    width = cfg.width,
    height = cfg.height,
    scale = 0.25,
    priority = "extra-high",
  }
end
data:extend{
  pglobals.copy_then(
    data.raw["inserter"]["bulk-inserter"],
    {
      name = "pktff-tentacle-inserter",
      allow_custom_vectors = true,
      minable = {mining_time=0.25, result = "pktff-tentacle-inserter"},
      -- TODO: do i make this require nutrients?
      -- i think that would be. evil
      energy_source = {
        type = "electric",
        usage_priority = "secondary-input",
        -- stackers use 1.0 kW
        drain = "1.0kW",
      },
      -- stackers use 40 kW
      energy_per_movement = "50kJ",
      energy_per_rotation = "50kJ",

      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      collision_box = {{-0.2, -0.2}, {0.2, 0.2}},
      pickup_position = {0, -1},
      insert_position = {0, 1.2},

      -- make it extend a *little* faster cause it's going to be spending
      -- a lot of time doing so
      extension_speed = 0.15,

      fast_replaceable_group = nil,

      -- TODO other parts of the inserter
      platform_picture = {
        sheet = {
          filename = Asset"graphics/entities/tentacle-inserter/platform.png",
          priority = "extra-high",
          -- Standard scale here is 0.5
          scale = 0.5,
          -- The "body" of the inserter needs to be about 32x32
          -- (so, pre-scale, 64x64)
          -- Anything outside of that box is "outside" the bounding box,
          -- which the vanilla inserters use for shadows and greebles
          width = 96,
          height = 96,
          shift = util.by_pixel(0, 3),
        },
      },
    }
  ),
  pglobals.copy_then(
    data.raw["item"]["bulk-inserter"], {
      name = "pktff-tentacle-inserter",
      order = "z-za[tentacle-inserter]",
      place_result = "pktff-tentacle-inserter",
    }
  ),
}
