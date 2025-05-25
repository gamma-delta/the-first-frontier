local pglobals = require "globals"

-- go away
data.raw["recipe"]["coal-synthesis"].hidden = true

data:extend{
  {
    type = "recipe",
    name = "boompuff-processing",
    icons = pglobals.icons.one_into_two(
      "__petraspace__/graphics/icons/boompuff-propagule.png",
      "__space-age__/graphics/icons/fluid/ammonia.png",
      "__base__/graphics/icons/fluid/petroleum-gas.png"
    ),
    category = "organic",
    subgroup = "agriculture-processes",
    order = "a[seeds]-z",
    enabled = false,
    allow_productivity = true,
    allow_decomposition = false,
    energy_required = 1,
    ingredients = {{type="item", name="boompuff-propagule", amount=1}},
    results = {
      {type="fluid", name="ammonia", amount=50},
      {type="fluid", name="petroleum-gas", amount=10},
      {type="item", name="spoilage", amount=4},
    },
    -- Same as boompuff agriculture tower color
    crafting_machine_tint = {
      primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
      secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
    }
  },
  -- NITRIFICATION!!!!!!!!
  {
    type = "recipe",
    name = "nitrogen-fixation",
    icons = pglobals.icons.three_into_one(
      "__space-age__/graphics/icons/fluid/ammonia.png",
      "__space-age__/graphics/icons/spoilage.png",
      "__space-age__/graphics/icons/iron-bacteria.png",
      "__petraspace__/graphics/icons/fluid/molecule-nitric-acid.png"
    ),
    category = "organic",
    subgroup = "agriculture-processes",
    order = "e[bacteria]-z[new]-a[nitrogen-fixation]",
    enabled = false,
    allow_productivity = true,
    allow_decomposition = false,
    energy_required = 7,
    ingredients = {
      -- IRL, the bio-catalyst used for this contains iron!
      -- or magnesium, or vanadium.
      -- Of course IRL soil-fixing bacteria make ammonia, not nitric acid,
      -- but what can I do
      {type="item", name="iron-bacteria", amount=1},
      -- is this too much?
      {type="item", name="spoilage", amount=200},
      {type="fluid", name="ammonia", amount=30},
    },
    results = {
      -- Maybe you get more nitrogen out of the atmosphere idk
      {type="fluid", name="nitric-acid", amount=50},
      {type="item", name="iron-bacteria", amount_min=0, amount_max=2},
    },
    -- TODO
    crafting_machine_tint = {
      primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
      secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
    }
  },
  -- Reversing the oil cracking pipeline.
  -- I do NOT want this to generate infinite sulfur out-of-the-box.
  -- It's 1 sulfur to 10 acid, and cracking is lossy,
  -- so even with +50% productivity i think using the same ratios but backwards
  -- won't let you generate infinite oil.
  -- Although I suppose if you do it's not the end of the world.
  -- Tested it with a bunch of t2 prod mods, it always peters out
  {
    type = "recipe",
    name = "light-oil-reforming",
    category = "organic",
    subgroup = "agriculture-processes",
    order = "e[bacteria]-z[new]-b[light-oil-reforming]",
    enabled = false,
    allow_productivity = true,
    allow_decomposition = false,
    energy_required = 2,
    ingredients = {
      {type="fluid", name="petroleum-gas", amount=30},
      {type="item", name="spoilage", amount=20},
      {type="item", name="copper-bacteria", amount=1},
    },
    results = {{type="fluid", name="light-oil", amount=20}},
    main_product = "",
    icons = pglobals.icons.two_into_one(
      "__base__/graphics/icons/fluid/petroleum-gas.png",
      "__space-age__/graphics/icons/copper-bacteria.png",
      "__base__/graphics/icons/fluid/light-oil.png"
    ),
    crafting_machine_tint = {
      primary = {r = 0.764, g = 0.596, b = 0.780, a = 1.000}, -- #c298c6ff
      secondary = {r = 0.762, g = 0.551, b = 0.844, a = 1.000}, -- #c28cd7ff
      tertiary = {r = 0.895, g = 0.773, b = 0.596, a = 1.000}, -- #e4c597ff
      quaternary = {r = 1.000, g = 0.734, b = 0.290, a = 1.000}, -- #ffbb49ff
    }
  },
  {
    type = "recipe",
    name = "heavy-oil-reforming",
    category = "organic",
    subgroup = "agriculture-processes",
    order = "e[bacteria]-z[new]-a[heavy-oil-reforming]",
    enabled = false,
    allow_productivity = true,
    allow_decomposition = false,
    energy_required = 2,
    ingredients = {
      {type="fluid", name="light-oil", amount=40},
      {type="item", name="spoilage", amount=30},
      {type="item", name="copper-bacteria", amount=1},
    },
    results = {{type="fluid", name="heavy-oil", amount=30}},
    main_product = "",
    icons = pglobals.icons.two_into_one(
      "__base__/graphics/icons/fluid/light-oil.png",
      "__space-age__/graphics/icons/copper-bacteria.png",
      "__base__/graphics/icons/fluid/heavy-oil.png"
    ),
    crafting_machine_tint = {
      primary = {r = 1.000, g = 0.642, b = 0.261, a = 1.000}, -- #ffa342ff
      secondary = {r = 1.000, g = 0.722, b = 0.376, a = 1.000}, -- #ffb85fff
      tertiary = {r = 0.854, g = 0.659, b = 0.576, a = 1.000}, -- #d9a892ff
      quaternary = {r = 1.000, g = 0.494, b = 0.271, a = 1.000}, -- #ff7e45ff
    }
  },
  {
    type = "recipe",
    name = "fertilizer",
    icon = "__petraspace__/graphics/icons/fertilizer/1.png",
    category = "organic",
    subgroup = "agriculture-products",
    order = "c[nutrients]-z-a[fertilizer]",
    enabled = false,
    allow_productivity = true,
    energy_required = 10,
    ingredients = {
      {type="fluid", name="ammonia", amount=50},
      {type="fluid", name="nitric-acid", amount=50},
      {type="item", name="nutrients", amount=20},
    },
    results = {{type="item", name="fertilizer", amount=10}},
    -- TODO
    crafting_machine_tint = {
      primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
      secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
    }
  },
  {
    type = "recipe",
    name = "anfo-explosives",
    icons = pglobals.icons.two_into_one(
      "__petraspace__/graphics/icons/fertilizer/1.png",
      "__base__/graphics/icons/fluid/light-oil.png",
      "__base__/graphics/icons/explosives.png"
    ),
    category = "organic",
    subgroup = "agriculture-products",
    order = "a[organic-products]-z-b[anje-explosives]",
    enabled = false,
    allow_productivity = true,
    energy_required = 4,
    ingredients = {
      {type="item", name="fertilizer", amount=2},
      {type="fluid", name="light-oil", amount=20},
    },
    results = {{type="item", name="explosives", amount=5}},
    -- TODO
    crafting_machine_tint = {
      primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
      secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
    }
  },
  {
    type = "recipe",
    name = "presto-fuel",
    category = "chemistry-or-cryogenics",
    subgroup = "agriculture-products",
    order = "a[organic-products]-z-d[presto-fuel]",
    enabled = false,
    allow_productivity = true,
    energy_required = 25,
    ingredients = {
      {type="item", name="wood", amount=5},
      {type="item", name="coal", amount=5},
      {type="item", name="boompuff-propagule", amount=10},
      {type="fluid", name="thruster-fuel", amount=20},
      {type="fluid", name="nitric-acid", amount=20},
    },
    results = {{type="item", name="presto-fuel", amount=1}},
    -- TODO
    crafting_machine_tint = {
      primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
      secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
    }
  },
}
-- just like the original prototype!
-- jellynt
-- This does mean jelly is used for even less :<
-- they'll figure it out
local vanilla_gleba_rocketfuel = data.raw["recipe"]["rocket-fuel-from-jelly"]
vanilla_gleba_rocketfuel.icon = nil
vanilla_gleba_rocketfuel.icons = pglobals.icons.two_into_one(
  "__space-age__/graphics/icons/bioflux.png",
  "__petraspace__/graphics/icons/boompuff-propagule.png",
  "__base__/graphics/icons/rocket-fuel.png"
)
vanilla_gleba_rocketfuel.ingredients[2] = {
  type="item", name="boompuff-propagule", amount=5,
}
-- ONI reference, and give you something to do with your boompuff hydrogen
table.insert(
  data.raw["recipe"]["bioplastic"].ingredients,
  {type="fluid", name="hydrogen", amount=10}
)

pglobals.recipe.add("agricultural-science-pack", 
  {type="fluid", name="nitric-acid", amount=20})
