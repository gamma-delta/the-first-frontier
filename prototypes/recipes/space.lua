-- Viate, space platforms, and other moons
local pglobals = require("globals")

data:extend{
  {
    type = "recipe",
    name = "pktff-orbital-data-card-high-pressure",
    category = "crafting",
    enabled = false,
    ingredients = {
      { type="item", name="pktff-precision-optical-component", amount=1 },
      { type="item", name="processing-unit", amount=1 },
    },
    energy_required = 2,
    results = {{
      type="item", name="pktff-orbital-data-card", amount=1,
    }},
    surface_conditions = {{ property="pressure", min=500 }},
    auto_recycle = false,
    icons = {
      { icon = "__base__/graphics/icons/nauvis.png" },
      { icon = Asset"graphics/icons/orbital-data-card.png" },
    }
  },
  {
    type = "recipe",
    name = "pktff-orbital-data-card-low-pressure",
    category = "crafting",
    enabled = false,
    ingredients = {
      { type="item", name="pktff-precision-optical-component", amount=1 },
      { type="item", name="electronic-circuit", amount=2 },
    },
    energy_required = 1,
    results = {{
      type="item", name="pktff-orbital-data-card", amount=1,
    }},
    -- this means you can do it in space, Viate, and Aquilo, but not Fulgora
    surface_conditions = {{ property="pressure", max=500 }},
    auto_recycle = false,
    icons = {
      { icon = "__space-age__/graphics/icons/solar-system-edge.png" },
      { icon = Asset"graphics/icons/orbital-data-card.png" },
    }
  },
  {
    type = "recipe",
    name = "pktff-rocket-control-unit",
    category = "crafting",
    enabled = false,
    ingredients = {
      {type="item", name="pktff-orbital-data-card", amount=1},
      {type="item", name="processing-unit", amount=1},
      {type="item", name="electric-engine-unit", amount=1},
    },
    energy_required = 10,
    results = {{type="item", name="pktff-rocket-control-unit", amount=1}},
    auto_recycle = false,
  }
}

data:extend{
  {
    type = "recipe",
    name = "pktff-space-platform-scaffolding",
    enabled = false,
    ingredients = {
      {type="item", name="iron-stick", amount=20},
      {type="item", name="pktff-aluminum-plate", amount=1},
      {type="item", name="electric-engine-unit", amount=1},
    },
    energy_required = 5,
    results = {{type="item", name="pktff-space-platform-scaffolding", amount=1}},
  },
  {
    type = "recipe",
    name = "pktff-space-platform-starter-pack-scaffolding",
    enabled = false,
    ingredients = {
      {type="item", name="pktff-space-platform-scaffolding", amount=60},
      {type="item", name="pktff-aluminum-plate", amount=20},
      {type="item", name="advanced-circuit", amount=20},
    },
    energy_required = 60,
    results = {{type="item", name="pktff-space-platform-starter-pack-scaffolding", amount=1}},
  },
}

-- Regolith
data:extend{
  {
    type = "recipe",
    name = "pktff-stone-bricks-from-regolith",
    category = "smelting",
    enabled = false,
    energy_required = 6.4,
    ingredients = {{type="item", name="pktff-regolith", amount=1}},
    results = {{type="item", name="stone-brick", amount=1}},
    allow_productivity = true,
    allow_decomposition = false,
    icons = pglobals.icons.mini_over(
      Asset"graphics/icons/regolith/1.png",
      "__base__/graphics/icons/stone-brick.png"
    ),
  },
  {
    type = "recipe",
    name = "pktff-washing-regolith",
    category = "crafting-with-fluid",
    subgroup = "raw-material",
    order = "c[chemistry]-zb",
    additional_categories = {"centrifuging"},
    enabled = false,
    energy_required = 8,
    ingredients = {
      {type="item", name="pktff-regolith", amount=10},
      -- 1 ice = 20 water = 200 steam
      {type="fluid", name="water", amount=20},
    },
    allow_productivity = true,
    allow_decomposition = false,
    results = {
      {type="item", name="stone", amount=5},
      {type="item", name="pktff-native-aluminum", amount=5},
      {type="item", name="iron-ore", amount=10},
    },
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/fluid/water.png",
      Asset"graphics/icons/regolith/1.png"
    ),
  },
  {
    type = "recipe",
    name = "pktff-dissolving-regolith",
    category = "chemistry",
    additional_categories = {"centrifuging"},
    subgroup = "raw-material",
    order = "c[chemistry]-zc",
    enabled = false,
    energy_required = 8,
    ingredients = {
      {type="item", name="pktff-regolith", amount=10},
      {type="fluid", name="sulfuric-acid", amount=10},
      {type="fluid", name="steam", amount=200},
    },
    allow_productivity = true,
    allow_decomposition = false,
    results = {
      {type="item", name="stone", amount=2},
      {type="item", name="pktff-native-aluminum", amount=15},
      {type="item", name="copper-ore", amount=2},
      -- One sulfur makes 10 H2SO4. Naively looping it around will not
      -- produce enough to close the loop; you need >20% productivity.
      -- Filling this recipe and the sulfuric acid recipe with 3 prod1 mods
      -- should barely close the loop.
      -- However you also need enough iron ore to react it ...
      -- You will probably be relying on shipments of S from Nauvis for a while.
      {type="item", name="sulfur", amount=1, probability=0.8},
    },
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/fluid/sulfuric-acid.png",
      Asset"graphics/icons/regolith/1.png"
    ),
  },
}

-- Advanced sprinkling
data:extend{
  {
    type = "recipe",
    name = "pktff-dust-sprayer",
    enabled = false,
    ingredients = {
      {type="item", name="pump", amount=1},
      {type="item", name="pipe", amount=10},
      {type="item", name="low-density-structure", amount=1},
    },
    results = {{type="item", name="pktff-dust-sprayer", amount=1}},
    energy_required = 3,
  },
  {
    type = "recipe",
    name = "pktff-dust-spraydown-water",
    category = "pktff-dust-spraydown",
    subgroup = "pktff-chemistry",
    icon = "__base__/graphics/icons/fluid/water.png",
    ingredients = {{ type="fluid", name="water", amount=200 }},
    results = {},
    energy_required = 1,
    -- prod mods add pollution, so does that make this even more effective?
    -- either way, it's interesting
    allow_productivity = true,
    allow_quality = false,

    crafting_machine_tint = {
      primary = {r = 0.45, g = 0.78, b = 1.000, a = 1.000},
      secondary = {r = 0.591, g = 0.856, b = 1.000, a = 1.000},
      tertiary = {r = 0.381, g = 0.428, b = 0.536, a = 0.502},
      quaternary = {r = 0.499, g = 0.797, b = 0.8, a = 0.733},
    }
  }
}

data:extend{
  {
    type = "recipe",
    name = "pktff-empty-platform-tank",
    category = "advanced-crafting",
    enabled = false,
    energy_required = 100,
    ingredients = {
      {type="item", name="low-density-structure", amount=20},
      {type="item", name="iron-gear-wheel", amount=50},
      {type="item", name="storage-tank", amount=5},
      {type="item", name="pump", amount=5},
    },
    results = {{type="item", name="pktff-empty-platform-tank", amount=1}},
    allow_productivity = true,
    allow_decomposition = true,
  },
  {
    type = "recipe",
    name = "pktff-platform-fuel-tank",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 10,
    ingredients = {
      {type = "item", name="pktff-empty-platform-tank", amount=1},
      {type = "fluid", name="thruster-fuel", amount=50000},
    },
    results = {{type="item", name="pktff-platform-fuel-tank", amount=1}},
    allow_productivity = false,
    allow_decomposition = true,
    allow_quality = false,
  },
  {
    type = "recipe",
    name = "pktff-platform-oxidizer-tank",
    category = "crafting-with-fluid",
    enabled = false,
    energy_required = 10,
    ingredients = {
      {type = "item", name="pktff-empty-platform-tank", amount=1},
      {type = "fluid", name="thruster-oxidizer", amount=50000},
    },
    results = {{type="item", name="pktff-platform-oxidizer-tank", amount=1}},
    allow_productivity = false,
    allow_decomposition = true,
    allow_quality = false,
  },
}
