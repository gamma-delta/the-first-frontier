local pglobals = require "globals"

local lrs_icons = {
  {
    icon = "__petraspace__/graphics/icons/lunar-rocket-silo.png",
    icon_size = 64,
  },
  {
    icon = "__PlanetsLib__/graphics/icons/moon-technology-symbol.png",
    icon_size = 128,
    scale = 0.2,
    shift = {-8, -8},
    floating = true
  }
}

-- Edit some rocket silo stuff here, not in data-updates,
-- so i can clone the edited version into the lunar one
local vanilla_rs = data.raw["rocket-silo"]["rocket-silo"]
vanilla_rs.fluid_boxes_off_when_no_fluid_recipe = false
vanilla_rs.fluid_boxes = {
  -- Fuel
  {
    production_type = "input",
    volume = 1000,
    pipe_picture = assembler2pipepictures(),
    pipe_covers = pipecoverspictures(),
    pipe_connections = {
      { flow_direction="input", direction = defines.direction.south, position = {-1, 4} },
      { flow_direction="input", direction = defines.direction.north, position = {1, -4} },
      { flow_direction="input", direction = defines.direction.west, position = {-4, 1} },
      { flow_direction="input", direction = defines.direction.east, position = {4, -1} }
    },
  },
  -- Oxidizer
  {
    production_type = "input",
    volume = 1000,
    pipe_picture = assembler2pipepictures(),
    pipe_covers = pipecoverspictures(),
    pipe_connections = {
      { flow_direction="input", direction = defines.direction.south, position = {1, 4} },
      { flow_direction="input", direction = defines.direction.north, position = {-1, -4} },
      { flow_direction="input", direction = defines.direction.west, position = {-4, -1} },
      { flow_direction="input", direction = defines.direction.east, position = {4, 1} }
    },
  }
}
-- Update it via script later
vanilla_rs.fixed_recipe = nil
-- Add my blue-tinted light overlays to suggest oxidizer
vanilla_rs.hole_light_sprite.filename = "__petraspace__/graphics/entities/rocket-silo/hole-light.png"
vanilla_rs.rocket_glow_overlay_sprite.filename = "__petraspace__/graphics/entities/rocket-silo/over-glow.png"
-- and same for the rocket
local vanilla_rocket = data.raw["rocket-silo-rocket"]["rocket-silo-rocket"]
vanilla_rocket.rocket_glare_overlay_sprite.filename = "__petraspace__/graphics/entities/rocket-silo/over-glare.png"
vanilla_rocket.rocket_flame_animation.filename = "__petraspace__/graphics/entities/rocket-silo/jet.png"
vanilla_rocket.rocket_sprite.layers[2].filename = "__petraspace__/graphics/entities/rocket-silo/static-emission.png"

data:extend{
  -- Make this a new entity so we can listen for it in events
  pglobals.copy_then(
    data.raw["cargo-pod"]["cargo-pod"],
    {name="lunar-cargo-pod"}
  ),
  pglobals.copy_then(
    data.raw["rocket-silo-rocket"]["rocket-silo-rocket"],
    {
      name = "lunar-rocket-rsr",
      cargo_pod_entity = "lunar-cargo-pod",
    }
  ),
  pglobals.copy_then(
    data.raw["item"]["rocket-silo"],
    {
      name = "lunar-rocket-silo",
      place_result = "lunar-rocket-silo",
      icons = lrs_icons,
    }
  ),
}

local lrs = pglobals.copy_then(
  data.raw["rocket-silo"]["rocket-silo"],
  {
    name = "lunar-rocket-silo",
    surface_conditions = {{property = "gravity", min = 1}},
    -- always launches "to the moon"
    launch_to_space_platforms = false,
    rocket_entity = "lunar-rocket-rsr",
    minable = {mining_time=1, result = "lunar-rocket-silo"},
    icons = lrs_icons,
  }
)
lrs.door_back_sprite.filename = "__petraspace__/graphics/entities/lunar-rocket-silo/door-back.png"
lrs.door_front_sprite.filename = "__petraspace__/graphics/entities/lunar-rocket-silo/door-front.png"
lrs.arm_01_back_animation.filename = "__petraspace__/graphics/entities/lunar-rocket-silo/arms-back.png"
lrs.arm_02_right_animation.filename = "__petraspace__/graphics/entities/lunar-rocket-silo/arms-right.png"
lrs.arm_03_front_animation.filename = "__petraspace__/graphics/entities/lunar-rocket-silo/arms-front.png"
data:extend{lrs}

-- thanks, xorimuth!
-- https://forums.factorio.com/viewtopic.php?t=127944
for _, hatch in pairs(data.raw["cargo-landing-pad"]["cargo-landing-pad"].cargo_station_parameters.hatch_definitions) do
  table.insert(hatch.receiving_cargo_units, "lunar-cargo-pod")
end
