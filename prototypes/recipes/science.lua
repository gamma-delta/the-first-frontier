-- Fuck you make steel
-- I think part of the vertical difficulty curve of bluence is
-- that you have to make steel *and* oil, and steel requires
-- a startlingly huge footprint
table.insert(
  data.raw["recipe"]["logistic-science-pack"].ingredients, 
  {type="item", name="steel-plate", amount=1}
)

data:extend{
  {
    type = "recipe",
    name = "data-card-programmer",
    enabled = false,
    ingredients = {
      { type="item", name="precision-optical-component", amount=20 },
      { type="item", name="radar", amount=5 },
      { type="item", name="steel-plate", amount=15 },
      { type="item", name="processing-unit", amount=30 },
    },
    energy_required = 2,
    results = {{
      type="item", name="data-card-programmer", amount=1,
    }},
    allow_productivity = true,
    allow_quality = true,
  },
  {
    type = "recipe",
    name = "orbital-data-card-high-pressure",
    category = "data-card-programming",
    enabled = false,
    ingredients = {
      { type="item", name="precision-optical-component", amount=1 },
      { type="item", name="processing-unit", amount=1 },
    },
    energy_required = 2,
    results = {{
      type="item", name="orbital-data-card", amount=1,
    }},
    surface_conditions = {{ property="pressure", min=500 }},
    auto_recycle = false,
    icons = {
      { icon = "__base__/graphics/icons/nauvis.png" },
      { icon = "__petraspace__/graphics/icons/orbital-data-card.png" },
    }
  },
  {
    type = "recipe",
    name = "orbital-data-card-low-pressure",
    category = "data-card-programming",
    enabled = false,
    ingredients = {
      { type="item", name="precision-optical-component", amount=1 },
      { type="item", name="electronic-circuit", amount=2 },
    },
    energy_required = 1,
    results = {{
      type="item", name="orbital-data-card", amount=1,
    }},
    -- this means you can do it in space, Viate, and Aquilo, but not Fulgora
    surface_conditions = {{ property="pressure", max=500 }},
    auto_recycle = false,
    icons = {
      { icon = "__space-age__/graphics/icons/solar-system-edge.png" },
      { icon = "__petraspace__/graphics/icons/orbital-data-card.png" },
    }
  },
  {
    type = "recipe",
    name = "orbital-science-pack",
    enabled = false,
    energy_required = 21,
    ingredients = {
      { type="item", name="orbital-data-card", amount=5 },
      -- for lack of a better idea
      { type="item", name="fast-transport-belt", amount=1 },
      { type="item", name="radar", amount=2 },
    },
    results = {
      { type="item", name="orbital-science-pack", amount=3 },
    },
    allow_productivity = true,
    allow_quality = true,
  },
}

-- Do I want to introduce viate skip? it would be funny.
local spience = data.raw["recipe"]["space-science-pack"]
-- Spience makes 5 of them
spience.ingredients = {
  {type="item", name="space-platform-foundation", amount=1},
  {type="item", name="precision-optical-component", amount=5},
  {type="item", name="low-density-structure", amount=10},
  {type="item", name="aluminum-plate", amount=10},
  {type="item", name="rocket-fuel", amount=5},
}
spience.surface_conditions = {{ property="gravity", max=2.5 }}

local purple_sci = data.raw["recipe"]["production-science-pack"]
purple_sci.ingredients = {
  {type="item", name="electric-furnace", amount=1},
  {type="item", name="productivity-module", amount=1},
  {type="item", name="rail", amount=30},
  {type="item", name="circuit-substrate", amount=30},
  {type="item", name="nuclear-waste", amount=1, ignored_by_stats=1},
}
purple_sci.results[1].amount = 5
-- produces a slight trickle of waste, probabilistically
table.insert(purple_sci.results,
  {type="item", name="nuclear-waste", amount=2, probability = 0.51,
    ignored_by_productivity = 9999, ignored_by_stats=1})
purple_sci.main_product = "production-science-pack"

local yellow_sci = data.raw["recipe"]["utility-science-pack"]
yellow_sci.ingredients = {
  {type="item", name="flying-robot-frame", amount=1},
  {type="item", name="low-density-structure", amount=3},
  {type="item", name="exoskeleton-equipment", amount=1},
  {type="item", name="plutonium", amount=1, ignored_by_stats=1},
}
yellow_sci.results[1].amount = 5
table.insert(yellow_sci.results,
  {type="item", name="plutonium", amount=1, probability = 0.99,
    ignored_by_productivity = 9999, ignored_by_stats=1})
yellow_sci.main_product = "utility-science-pack"
