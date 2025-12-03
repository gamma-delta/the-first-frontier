local pglobals = require "globals"

-- go away
data.raw["recipe"]["coal-synthesis"].hidden = true

data:extend{
  {
    type = "recipe",
    name = "pktff-boompuff-processing",
    icons = pglobals.icons.one_into_two(
      Asset"graphics/icons/boompuff-propagule.png",
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
    ingredients = {{type="item", name="pktff-boompuff-propagule", amount=1}},
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
    name = "pktff-nitrogen-fixation",
    icons = pglobals.icons.three_into_one(
      "__space-age__/graphics/icons/fluid/ammonia.png",
      "__space-age__/graphics/icons/spoilage.png",
      "__space-age__/graphics/icons/iron-bacteria.png",
      Asset"graphics/icons/fluid/molecule-nitric-acid.png"
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
      -- Give you something to do with jelly
      {type="item", name="jelly", amount=4},
      {type="fluid", name="ammonia", amount=30},
    },
    reset_freshness_on_craft = true,
    result_is_always_fresh = true,
    results = {
      -- Maybe you get more nitrogen out of the atmosphere idk
      {type="fluid", name="pktff-nitric-acid", amount=50},
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
  -- Tested it with a bunch of t2 prod mods, it always peters out.
  -- Previously used spoilage, now uses jelly, because I want to even
  -- out the demands of yumako/jelly
  {
    type = "recipe",
    name = "pktff-light-oil-reforming",
    category = "organic",
    subgroup = "agriculture-processes",
    order = "e[bacteria]-z[new]-b[light-oil-reforming]",
    enabled = false,
    allow_productivity = true,
    allow_decomposition = false,
    energy_required = 2,
    ingredients = {
      {type="fluid", name="petroleum-gas", amount=30},
      {type="item", name="jelly", amount=10},
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
    name = "pktff-heavy-oil-reforming",
    category = "organic",
    subgroup = "agriculture-processes",
    order = "e[bacteria]-z[new]-c[heavy-oil-reforming]",
    enabled = false,
    allow_productivity = true,
    allow_decomposition = false,
    energy_required = 2,
    ingredients = {
      {type="fluid", name="light-oil", amount=40},
      {type="item", name="jelly", amount=10},
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
    name = "pktff-fertilizer",
    icon = Asset"graphics/icons/fertilizer/1.png",
    category = "organic",
    subgroup = "agriculture-products",
    order = "c[nutrients]-z-a[fertilizer]",
    enabled = false,
    allow_productivity = true,
    energy_required = 10,
    ingredients = {
      {type="fluid", name="ammonia", amount=50},
      {type="fluid", name="pktff-nitric-acid", amount=50},
      {type="item", name="nutrients", amount=20},
    },
    results = {{type="item", name="pktff-fertilizer", amount=10}},
    -- TODO
    crafting_machine_tint = {
      primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
      secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
    }
  },
  {
    type = "recipe",
    name = "pktff-anfo-explosives",
    icons = pglobals.icons.two_into_one(
      Asset"graphics/icons/fertilizer/1.png",
      "__base__/graphics/icons/fluid/light-oil.png",
      "__base__/graphics/icons/explosives.png"
    ),
    category = "organic",
    subgroup = "agriculture-products",
    order = "a[organic-products]-z-b[anfo-explosives]",
    enabled = false,
    allow_productivity = true,
    energy_required = 4,
    ingredients = {
      {type="item", name="pktff-fertilizer", amount=2},
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
    name = "pktff-presto-fuel",
    category = "chemistry-or-cryogenics",
    subgroup = "agriculture-products",
    order = "a[organic-products]-z-d[presto-fuel]",
    enabled = false,
    hidden = true,
    allow_productivity = true,
    energy_required = 25,
    ingredients = {
      {type="item", name="wood", amount=5},
      {type="item", name="coal", amount=5},
      {type="item", name="pktff-boompuff-propagule", amount=10},
      {type="fluid", name="thruster-fuel", amount=20},
      {type="fluid", name="pktff-nitric-acid", amount=20},
    },
    results = {{type="item", name="pktff-presto-fuel", amount=1}},
    -- TODO
    crafting_machine_tint = {
      primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
      secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
    }
  },
}
