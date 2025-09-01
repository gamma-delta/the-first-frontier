local pglobals = require "globals"
local rocket_cap = 1000 * kg

local item_sounds = require("__base__/prototypes/item_sounds")
local sounds = require("__base__/prototypes/entity/sounds")

local function heat_pipe_direction_pic(direction, hot)
  local img = hot and "heatex-endings-heated.png" or "heatex-endings.png"

  local sx_map = {north=0, east=1, south=2, west=3}
  local sx = sx_map[direction] * 64

  local new_sprite = {
    filename = "__base__/graphics/entity/heat-exchanger/" .. img,
    x = sx, y = 0,
    size = 64, scale = 0.5, priority = "high"
  }
  if hot then new_sprite = apply_heat_pipe_glow(new_sprite) end
  return new_sprite
end

local function heat_connect(x, y, dir)
  return {
    position = { x, y },
    direction = defines.direction[dir],
  }
end
local ghx_pics = require("geothermal-heat-exchanger-gfx")
local big_x = {
  filename = "__core__/graphics/too-far.png",
  size = 64, scale = 0.5,
}
data:extend{
  {
    type = "reactor",
    name = "geothermal-heat-exchanger",
    flags = {"placeable-player", "placeable-neutral", "player-creation"},
    icon = "__petraspace__/graphics/icons/geothermal-heat-exchanger.png",
    minable = {mining_time=2, result = "geothermal-heat-exchanger"},
    selection_box = {{-4.5, -4.5}, {4.5, 4.5}},
    collision_box = {{-4.3, -4.3}, {4.3, 4.3}},
    tile_width = 9,
    tile_height = 9,
    impact_category = "metal",
    open_sound = sounds.steam_open,
    close_sound = sounds.steam_close,

    energy_source = { type = "void" },
    consumption = "500MW",
    neighbor_bonus = 1,

    stateless_visualisation = {
      animation = ghx_pics.normal,
    },
    water_reflection = ghx_pics.reflection,
    -- lower_layer_picture = ghx_pics.heat_pipes,
    -- heat_lower_layer_picture = apply_heat_pipe_glow(ghx_pics.heat_pipes_hot),
    heat_buffer = {
      default_temperature = 30,
      min_working_temperature = 350,
      minimum_glow_temperature = 350,
      max_temperature = 2000,
      -- Make this rather high so it takes a while to heat up
      -- Nuclear reactors are at 10MJ
      specific_heat = "50MJ",
      -- this is what matters
      max_transfer = "1GW",
      connections = {
        heat_connect(-2, -4.0, "north"),
        heat_connect(2, -4.0, "north"),
        heat_connect(-2, 4.0, "south"),
        heat_connect(2, 4.0, "south"),
        heat_connect(-4.0, -2, "west"),
        heat_connect(-4.0, 2, "west"),
        heat_connect(4.0, -2, "east"),
        heat_connect(4.0, 2, "east"),
      },
      -- This continues to not work and I have no idea why
      pipe_covers = {
        --[[
        north = heat_pipe_direction_pic("north", false),
        east = heat_pipe_direction_pic("east", false),
        south = heat_pipe_direction_pic("south", false),
        west = heat_pipe_direction_pic("west", false),
        ]]
        north = big_x,
        east = big_x,
        south = big_x,
        west = big_x,
      },
      heat_pipe_covers = {
        north = heat_pipe_direction_pic("north", true),
        east = heat_pipe_direction_pic("east", true),
        south = heat_pipe_direction_pic("south", true),
        west = heat_pipe_direction_pic("west", true),
      }
    },

    -- Thankfully there is a lava_tile rule.
    -- It looks like collision_mask and tile_buildability_rules are ANDed,
    -- so unfortunately I do need to specify every tile individually.
    -- Referencing offshore pumps. Same collision mask but w/ elevated rails
    collision_mask = { layers = pglobals.set{ 
      "object", "train", "is_object", "is_lower_object",
      "elevated_rail",
    }},
    -- Require some lava in the middle. Everything else, anything goes
    tile_buildability_rules = {
      {
        area = {{-2.4, -2.4}, {2.4, 2.4}},
        required_tiles = {layers = {lava_tile=true}},
        colliding_tiles = {layers = {ground_tile=true}},
        remove_on_collision = true,
      }
    },
    placeable_position_visualization = pglobals.placevis,
    --[[
    placeable_position_visualisation = {
      filename = "__space-age__/graphics/icons/fluid/lava.png",
      priority = "extra-high-no-scale",
      size = 64,
      scale = 0.5,
    },
    ]]
    
    resistances = {
      { type="fire", percent=100 },
      { type="impact", percent=30 },
    },
    max_health = 300,
    dying_explosion = "foundry-explosion",
  },
  {
    type = "item",
    name = "geothermal-heat-exchanger",
    icon = "__petraspace__/graphics/icons/geothermal-heat-exchanger.png",
    subgroup = "smelting-machine",
    order = "cza[geothermal]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    place_result = "geothermal-heat-exchanger",
    default_import_location = "vulcanus",
    stack_size = 10,
    weight = rocket_cap / 10
  }
}

-- Make the foundry worse
local heatex = data.raw["boiler"]["heat-exchanger"]
local foundry = data.raw["assembling-machine"]["foundry"]
local nothingburger = {
  filename = "__core__/graphics/empty.png",
  width = 1, height = 1
}
foundry.energy_usage = "50MW"
foundry.energy_source = {
  type = "heat",
  -- every second while running, it goes down by 50c
  specific_heat = "1MJ",
  default_temperature = 30,
  max_temperature = 2000,
  -- this is about the melting point of steel
  min_working_temperature = 1500,
  -- so it heats up some time this century
  max_transfer = "1GW",
  connections = {
    heat_connect(0, -2, "north"),
    heat_connect(0, 2, "south"),
    heat_connect(-2, 0, "west"),
    heat_connect(2, 0, "east"),
  },
  pipe_covers = {
    -- The north one is covered by the sprite
    north = nothingburger,
    east = heat_pipe_direction_pic("east", false),
    south = heat_pipe_direction_pic("south", false),
    west = heat_pipe_direction_pic("west", false),
  },
  heat_pipe_covers = {
    north = nothingburger,
    east = heat_pipe_direction_pic("east", true),
    south = heat_pipe_direction_pic("south", true),
    west = heat_pipe_direction_pic("west", true),
  }
}

-- Tungsten heat pipes
-- TODO: slightly awkward heat joins on entities like GHX and nuclear
-- reactor that have copper colors
local thp = pglobals.copy_then(data.raw["heat-pipe"]["heat-pipe"], {
  name = "tungsten-heat-pipe",
  minable = {mining_time=0.1, result = "tungsten-heat-pipe"},
  corpse = "tungsten-heat-pipe-remnants",
  icon = "__petraspace__/graphics/icons/tungsten-heat-pipe.png",
  order = "z-cza[thp]",
  -- Use the vanilla heat overlay for now
  -- TODO: when at full heat it looks exactly like the vanilla heat pipe
  -- i might need to actually sprite a new greeble for the center bind point
  connection_sprites = make_heat_pipe_pictures(
    "__petraspace__/graphics/entities/tungsten-heat-pipe/", "thp",
    {
      single = { name = "straight-vertical-single", ommit_number = true },
      straight_vertical = { variations = 6 },
      straight_horizontal = { variations = 6 },
      corner_right_up = { name = "corner-up-right", variations = 6 },
      corner_left_up = { name = "corner-up-left", variations = 6 },
      corner_right_down = { name = "corner-down-right", variations = 6 },
      corner_left_down = { name = "corner-down-left", variations = 6 },
      t_up = {},
      t_down = {},
      t_right = {},
      t_left = {},
      cross = { name = "t" },
      ending_up = {},
      ending_down = {},
      ending_right = {},
      ending_left = {}
    }
)
})
thp.heat_buffer.specific_heat = "200kJ"
thp.heat_buffer.max_transfer = "1GW"
thp.heat_buffer.max_temperature = 2000
data:extend{
  thp,
  pglobals.copy_then(data.raw["item"]["heat-pipe"], {
    name = "tungsten-heat-pipe",
    default_import_location = "vulcanus",
    place_result = "tungsten-heat-pipe",
    icon = "__petraspace__/graphics/icons/tungsten-heat-pipe.png",
  }),
  pglobals.copy_then(data.raw["corpse"]["heat-pipe-remnants"], {
    name = "tungsten-heat-pipe-remnants",
    icon = "__petraspace__/graphics/icons/tungsten-heat-pipe.png",
    animation = make_rotated_animation_variations_from_sheet(6, {
      filename = "__petraspace__/graphics/entities/tungsten-heat-pipe/remnants.png",
      line_length = 1,
      width = 122,
      height = 100,
      direction_count = 2,
      shift = util.by_pixel(0.5, -1.5),
      scale = 0.5,
    })
  }),
}

data:extend{
  pglobals.copy_then(data.raw["item"]["steel-chest"], {
    name = "tungsten-steel-strongbox",
    default_import_location = "vulcanus",
    order = "a[items]-cz",
    place_result = "tungsten-steel-strongbox",
    icon = "__petraspace__/graphics/entities/tungsten-steel-strongbox/base.png",
    icon_size = 128,
    weight = rocket_cap / 10,
  }),
  pglobals.copy_then(data.raw["container"]["steel-chest"], {
    name = "tungsten-steel-strongbox",
    order = "z-a[items]-cz",
    default_import_location = "vulcanus",
    minable = {mining_time=0.5, result="tungsten-steel-strongbox"},
    collision_box = {{-0.8, -0.8}, {0.8, 0.8}},
    selection_box = {{-1, -1}, {1, 1}},
    inventory_size = 96,
    inventory_type = "with_filters_and_bar",
    picture = {
      layers = {
        {
          filename = "__petraspace__/graphics/entities/tungsten-steel-strongbox/base.png",
          width = 128, height = 128,
          scale = 0.5,
        },
        -- TODO this only renders a small part of it
        {
          filename = "__petraspace__/graphics/entities/tungsten-steel-strongbox/shadow.png",
          width = 128, height = 128,
          scale = 0.5,
          draw_as_shadow = true,
        },
      },
    },
    -- TODO circuit connections ughhhhh
  }),
}
