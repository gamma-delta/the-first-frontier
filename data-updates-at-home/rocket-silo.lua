local pglobals = require "globals"

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
