require("planets/viate")
require("planets/lepton")

data:extend{
  {
    type = "surface-property",
    name = "atmospheric-nitrogen",
    default_value = 0,
  },
}

data.raw["planet"]["nauvis"].surface_properties["atmospheric-nitrogen"] = 78
-- more o2 than nauvis
data.raw["planet"]["gleba"].surface_properties["atmospheric-nitrogen"] = 69
-- mostly co2
data.raw["planet"]["fulgora"].surface_properties["atmospheric-nitrogen"] = 50
-- mostly co2
data.raw["planet"]["vulcanus"].surface_properties["atmospheric-nitrogen"] = 30

local aquilo = data.raw["planet"]["aquilo"]
-- probably mostly ammonia or hydrogen or some other disaster
-- what the fuck is the deal with aquilo
aquilo.surface_properties["atmospheric-nitrogen"] = 0
-- aquilo is D A R K. also, it doesn't have surface_render_parameters
-- for some reason.
-- Lamps set the color to whatever midday is, t=0.
-- So, freeze the time at just *past* midday, so that solar panels work
-- and it still always renders dark
aquilo.surface_render_parameters = {
  day_night_cycle_color_lookup = {
    { 0.1, "identity" },
    { 0.11, "__petraspace__/graphics/luts/aquilo-night.png" },
    { 0.89, "__petraspace__/graphics/luts/aquilo-night.png" },
    { 0.9, "identity" },
  },
}
