local pglobals = require "globals"

-- Fiddle with scrapping
-- The objective is to make iron much rarer.
-- (although you really don't need that much Fe on Fulgora)
-- Og probs: 20 7 6 5 4 4 4 3 3 2 1 1
-- TODO: removing solid fuel means it's impossible to start from scratch
-- on Fulgora. is this OK?
local function scrapout(name, prob)
  return {
    type = "item",
    name = name,
    amount = 1,
    probability = prob,
    show_details_in_recipe_tooltip = false,
  }
end
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
data:extend{
  {
    type = "recipe",
    name = "pktff-archaeological-scrap-recycling",
    icons = {
      {
        icon = "__quality__/graphics/icons/recycling.png"
      },
      {
        icon = Asset"graphics/icons/archaeological-scrap/1.png",
        scale = 0.4
      },
      {
        icon = "__quality__/graphics/icons/recycling-top.png"
      }
    },
    category = "recycling",
    subgroup = "fulgora-processes",
    order = "a[trash]-b",
    auto_recycle = false,
    enabled = false,
    energy_required = 0.2,
    ingredients = {{type="item", name="pktff-archaeological-scrap", amount=1}},
    results = {
      scrapout("selector-combinator", 1 / 2),
      scrapout("superconductor", 1 / 4), -- the money shot
      scrapout("programmable-speaker", 1 / 8),
      scrapout("display-panel", 1 / 16),
      scrapout("pktff-aluminum-plate", 1 / 32),
      scrapout("low-density-structure", 1 / 64),
      scrapout("car", 1 / 128),
      scrapout("holmium-ore", 1 / 256),
      scrapout("flying-robot-frame", 1 / 512),
      scrapout("requester-chest", 1 / 1024),
      scrapout("personal-roboport-mk2-equipment", 1 / 2048),
      scrapout("battery-mk3-equipment", 1 / 2048),
    },
  },
  {
    type = "recipe",
    name = "pktff-fulgoran-sludge-refining",
    icon = Asset"graphics/icons/fluid/fulgoran-sludge.png",
    category = "oil-processing",
    subgroup = "fulgora-processes",
    order = "az[after-trash]-a",
    enabled = false,
    auto_recycle = false,
    allow_productivity = true,
    energy_required = 5,
    ingredients = {
      {type="fluid", name="pktff-fulgoran-sludge", amount=100},
      {type="fluid", name="water", amount=50},
      -- a filter?
      {type="item", name="stone", amount=1},
    },
    results = {
      {type="fluid", name="crude-oil", amount=50},
      {type="fluid", name="heavy-oil", amount=30},
      {type="fluid", name="sulfuric-acid", amount=20},
      {type="item", name="scrap", amount_min=0, amount_max=10},
      -- hur hur hur
      {type="item", name="plastic-bar", amount=1, probability=0.2},
    }
  }
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

data.raw["recipe"]["superconductor"].hidden = true
