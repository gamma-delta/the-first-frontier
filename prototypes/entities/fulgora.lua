local pglobals = require "globals"
local item_sounds = require("__base__/prototypes/item_sounds")
local sounds = require("__base__/prototypes/entity/sounds")

local rocket_cap = 1000*kg

-- Nerf lightning tools
local fulgoran_lightningrod = data.raw["lightning-attractor"]["fulgoran-ruin-attractor"]
fulgoran_lightningrod.efficiency = 1
-- Same as vanilla's big lightning rod ...
fulgoran_lightningrod.energy_source = {
  type = "electric",
  buffer_capacity = "1000MJ",
  usage_priority = "primary-output",
  output_flow_limit = "1000MJ",
  -- but worse drain. because it's old or something
  drain = "5MJ"
}
-- be REALLY SURE
fulgoran_lightningrod.minable.mining_time = 5
-- this has a range of 20 by default, throw the player a bone
fulgoran_lightningrod.range_elongation = 30
-- default is place every 15
fulgoran_lightningrod.autoplace.probability_expression = [[
  min(
    place_every_n(12,12,1,1),
    0.1 * fulgora_artificial_mask + 0.2 * (fulgora_decorative_machine_density - 1.5)
  ) + max(0, 10 * (1.5 - distance))
]]
-- i guess the final term is to make sure a bunch place at spawn

fulgoran_lightningrod.chargable_graphics.charge_light = {
  intensity = 2.0,
  size = 9.0,
  minimum_darkness = 0.9,
  add_perspective = true,
  color = {0.9, 0.5, 0.95},
  flicker_interval = 2,
  flicker_min_modifier = 0.1,
  flicker_max_modifier = 1.0,
  offset_flicker = true,
  shift = {0.5, -4.0},
}
-- Discharge lights look really naff.
-- The orb on the top is not in the same place in every graphic.
-- This looks OK for the lightning because it only connects for a split
-- second, but the light is really clearly off-center most of the time

local small_rod = data.raw["lightning-attractor"]["lightning-rod"]
small_rod.range_elongation = 10

-- Make the vault an accumulator
local brightlines = {
  filename = "__petraspace__/graphics/entities/fulgoran/vault-accumulator-light.png",
  width = 960, height = 640,
  scale = 0.5,
  shift = util.by_pixel(18.5/2, -6/2), -- from vanilla
  priority = "high",
  line_length = 4,
  frame_count = 16,
  draw_as_glow = true,
  blend_mode = "additive",
  animation_speed = 0.21
}
local vault = pglobals.copy_then(data.raw["simple-entity"]["fulgoran-ruin-vault"], {
  type = "accumulator",
  -- It's about 14x8. That could store 28 accumulators.
  -- Let's make it 50 worth.
  -- Slow charge speed, split-second discharge speed.
  energy_source = {
    type = "electric",
    usage_priority = "tertiary",
    buffer_capacity = (5 * 50) .. "MJ",
    input_flow_limit = (300 * 20) .. "kW",
    output_flow_limit = "1GW",
  },
  pictures = nil,
  chargable_graphics = {
    picture = util.sprite_load(
      "__space-age__/graphics/decorative/fulgoran-ruin/fulgoran-ruin-vault",
      {
        scale = 0.5,
      }
    ),
    -- For some reason, standard is that the *discharge* is brighter?
    discharge_animation = {
      layers = {
        brightlines,
      },
    },
    charge_animation = {
      layers = {
        pglobals.copy_then(brightlines, {
          filename = "__petraspace__/graphics/entities/fulgoran/vault-accumulator-dark.png",
          animation_speed = 0.11,
        }),
      }
    },
    -- idk this is what vanilla accumulator does
    charge_cooldown = 30, discharge_cooldown = 60,
  }
})
data.raw["simple-entity"]["fulgoran-ruin-vault"] = nil
data:extend{vault}

-- Add archy scrap to ruins
for _,ruin in ipairs{
  -- tiny doesn't drop anything
  "fulgoran-ruin-small",
  "fulgoran-ruin-medium", "fulgoran-ruin-stonehenge",
  "fulgoran-ruin-big", "fulgoran-ruin-huge",
  "fulgoran-ruin-colossal",
} do
  local proto = data.raw["simple-entity"][ruin]
  local area = (proto.collision_box[2][1] - proto.collision_box[1][1]) 
    * (proto.collision_box[2][2] - proto.collision_box[1][2])
  table.insert(proto.minable.results, {
    type = "item", name = "archaeological-scrap",
    amount_min = math.ceil(area/4), amount_max = math.ceil(area/2)
  })
end
table.insert(data.raw["accumulator"]["fulgoran-ruin-vault"].minable.results, {
  type = "item", name = "archaeological-scrap",
  amount = 100,
})
table.insert(data.raw["lightning-attractor"]["fulgoran-ruin-attractor"].minable.results, {
  type = "item", name = "archaeological-scrap",
  amount = 20,
})

-- t1
data:extend{
  {
    -- this is deranged
    type = "electric-energy-interface",
    name = "electrostatic-funneler",
    icon = "__space-age__/graphics/icons/lightning-collector.png",
    gui_mode = "none",
    energy_usage = "10MW",
    energy_source = {
      type = "electric",
      usage_priority = "secondary-input",
      emissions_per_minute = { dust = -300 },
      buffer = "10MJ",
    },
    minable = {mining_time=1, result = "electrostatic-funneler"},
    flags = {"placeable-player", "placeable-neutral", "player-creation"},
    max_health = 200,
    picture = {
      layers = {
        util.sprite_load("__space-age__/graphics/entity/lightning-collector/lightning-collector",
        {
          priority = "high",
          scale = 0.5,
          repeat_count = repeat_count
        }),
        util.sprite_load("__space-age__/graphics/entity/lightning-collector/lightning-collector-shadow",
        {
          priority = "high",
          draw_as_shadow = true,
          scale = 0.5,
          repeat_count = repeat_count
        })
      }
    },
    collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
    selection_box = {{-1, -1}, {1, 1}},
    impact_category = "metal",
    open_sound = sounds.electric_large_open,
    close_sound = sounds.electric_large_close,
  },
  {
    type = "item",
    name = "electrostatic-funneler",
    icon = "__base__/graphics/icons/fluid/steam.png",
    subgroup = "production-machine",
    order = "wa[electrostatic]",
    inventory_move_sound = item_sounds.metal_large_inventory_move,
    pick_sound = item_sounds.metal_large_inventory_pickup,
    drop_sound = item_sounds.metal_large_inventory_move,
    place_result = "electrostatic-funneler",
    stack_size = 5,
    weight = rocket_cap / 5
  },
}
