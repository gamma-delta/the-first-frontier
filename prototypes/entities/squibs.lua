-- Miscellaneous triggers and stuff

local function pollution_squib(name, pollutant, amount, color_inner, color_outer)
  -- We cannot use trivial smoke because the color has to change
  color_outer = color_outer or util.multiply_color(color_inner, 0.8)
  local lifetime = 2
  return {
    type = "smoke-with-trigger",
    name = name,
    flags = {"not-on-map"},
    emissions_per_second = {[pollutant] = amount / lifetime},
    cyclic = false,
    duration = lifetime * 60,
    fade_in_duration = 20,
    fade_away_duration = 40,
    animation = {
      layers = {
        {
          filename = "__base__/graphics/entity/crude-oil/oil-smoke-outer.png",
          frame_count = 47,
          line_length = 16,
          width = 90,
          height = 188,
          animation_speed = 0.3,
          shift = util.by_pixel(-2, 24 -152),
          scale = 1.5,
          tint = color_outer
        },
        {
          filename = "__base__/graphics/entity/crude-oil/oil-smoke-inner.png",
          frame_count = 47,
          line_length = 16,
          width = 40,
          height = 84,
          animation_speed = 0.3,
          shift = util.by_pixel(0, 24 -78),
          scale = 1.5,
          tint = color_inner
        }
      }
    }
  }
end

data:extend{
  pollution_squib("dust-squib-white", "dust", 20, {0.7, 0.72, 0.8, 0.2}),
  pollution_squib("dust-squib-reddish", "dust", 20, {0.9, 0.65, 0.6, 0.2}),
}
