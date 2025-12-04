local pglobals = require "globals"

local scrapout = pglobals.recipe.scrapout
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
