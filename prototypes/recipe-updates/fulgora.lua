local pglobals = require "globals"
-- Fiddle with scrapping
-- The objective is to make iron much rarer.
-- (although you really don't need that much Fe on Fulgora)
-- Og probs: 20 7 6 5 4 4 4 3 3 2 1 1
-- TODO: removing solid fuel means it's impossible to start from scratch
-- on Fulgora. is this OK?
local scrapout = pglobals.recipe.scrapout
local scrapping = data.raw["recipe"]["scrap-recycling"]
scrapping.results = {
  scrapout("stone", 0.20),
  scrapout("concrete", 0.07),
  scrapout("ice", 0.06),
  scrapout("steel-plate", 0.05),
  scrapout("iron-gear-wheel", 0.04),
  scrapout("battery", 0.04),
  scrapout("pktff-precision-optical-component", 0.04),
  scrapout("copper-cable", 0.03),
  scrapout("processing-unit", 0.03),
  scrapout("pktff-archaeological-scrap", 0.02),
  scrapout("low-density-structure", 0.01),
  scrapout("holmium-ore", 0.01),
}

data.raw["recipe"]["holmium-solution"].ingredients = {
  {type="item", name="holmium-ore", amount=2},
  {type="item", name="stone", amount=1},
  {type="fluid", name="pktff-nitric-acid", amount=10},
}
data.raw["recipe"]["electrolyte"].ingredients = {
  {type="item", name="stone", amount=1},
  {type="fluid", name="holmium-solution", amount=10},
  {type="fluid", name="sulfuric-acid", amount=10},
}

pglobals.recipe.add("electromagnetic-plant",
  {type="item", name="superconductor", amount=5})
pglobals.recipe.add("lightning-rod",
  {type="item", name="supercapacitor", amount=2})

data.raw["recipe"]["supercapacitor"].ingredients = {
  {type="item", name="battery", amount=1},
  {type="item", name="electronic-circuit", amount=4},
  {type="item", name="holmium-plate", amount=2},
  -- it would be very appropriate to have carbon here,
  -- but there is no way to get it on Fulgora at the moment.
  -- carbon fiber would be even better!
  -- perhaps save it for the sconductor
  {type="item", name="pktff-aluminum-plate", amount=1},
  {type="fluid", name="electrolyte", amount=10},
}

-- TODO: figure out what to do with sconductors
data.raw["recipe"]["superconductor"].hidden = true
