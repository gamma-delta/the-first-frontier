local pglobals = require("globals")

data:extend{
  pglobals.copy_then(
    data.raw["cliff"]["cliff-vulcanus"],
    {name="pktff-cliff-viate"}
  ),
}

-- local greenscreen = pglobals.copy_then(
--   data.raw["tile"]["lab-dark-1"],
--   {name="greenscreen"}
-- )
-- greenscreen.variants.main[1].picture = "__petraspace__/graphics/tiles/greenscreen.png"
-- local bluescreen = pglobals.copy_then(
--   data.raw["tile"]["lab-dark-1"],
--   {name="bluescreen"}
-- )
-- bluescreen.variants.main[1].picture = "__petraspace__/graphics/tiles/bluescreen.png"
-- data:extend{greenscreen, bluescreen}
