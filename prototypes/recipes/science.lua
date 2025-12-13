local pglobals = require "globals"

data:extend{
  {
    type = "recipe",
    name = "pktff-orbital-science-pack",
    enabled = false,
    energy_required = 21,
    ingredients = {
      { type="item", name="pktff-orbital-data-card", amount=5 },
      -- for lack of a better idea
      { type="item", name="fast-transport-belt", amount=1 },
      { type="item", name="radar", amount=2 },
    },
    results = {
      { type="item", name="pktff-orbital-science-pack", amount=3 },
    },
    allow_productivity = true,
    allow_quality = true,
  },
}
