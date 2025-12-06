-- Recipes for before space
local pglobals = require("globals")

-- Bad aluminum
data:extend{
  {
    type = "recipe",
    name = "pktff-aluminum-plate",
    category = "smelting",
    order = "za[native-aluminum-to-plate]",
    enabled = false,
    energy_required = 3.2,
    allow_productivity = true,
    ingredients = {{ type="item", name="pktff-native-aluminum", amount=2 }},
    results = {{ type="item", name="pktff-aluminum-plate", amount=1 }},
  },
  {
    -- This recipe should mega suck
    type = "recipe",
    name = "pktff-simple-bauxite-extraction",
    category = "chemistry",
    additional_categories = {"centrifuging"},
    subgroup = "pktff-aluminum-processes",
    order = "c[aluminum]-a",
    enabled = false,
    ingredients = {
      {type="item", name="pktff-bauxite-ore", amount=5},
      {type="item", name="stone", amount=10},
      {type="fluid", name="sulfuric-acid", amount=200},
      {type="fluid", name="steam", amount=500},
    },
    energy_required = 30,
    results = {{type="item", name="pktff-native-aluminum", amount=1}},
    auto_recycle = false,
    allow_productivity = true,
    allow_decomposition = false,
    icons = pglobals.icons.two_into_one(
      "__base__/graphics/icons/fluid/sulfuric-acid.png",
      "__base__/graphics/icons/fluid/steam.png",
      Asset"graphics/icons/bauxite/1.png"
    )
  },
}

-- Nauvian circuit substrate recipes
-- This makes the fulgoran recycling ratios a little different,
-- but you can still get plenty of iron from gears (Edit: no)
-- and copper from LDS and POC and whatever
data:extend{
  {
    type = "recipe",
    name = "pktff-circuit-substrate-stone",
    subgroup = "intermediate-product",
    order = "b[circuits]-![circuit-substrate]-a",
    category = "crafting",
    enabled = false,
    ingredients = {
      {type="item", name="stone-brick", amount=1},
      {type="item", name="copper-plate", amount=1},
    },
    energy_required = 0.5,
    results = {{type="item", name="pktff-circuit-substrate", amount=1}},
    allow_productivity = true,
    auto_recycle = false,
    -- the "default" i suppose
    allow_decomposition = true,
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/stone-brick.png",
      Asset"graphics/icons/circuit-substrate.png"
    )
  },
  {
    type = "recipe",
    name = "pktff-circuit-substrate-wood",
    subgroup = "intermediate-product",
    order = "b[circuits]-![circuit-substrate]-b",
    category = "crafting",
    additional_categories = {"organic"},
    enabled = false,
    ingredients = {
      {type="item", name="wood", amount=2},
      {type="item", name="copper-plate", amount=1},
    },
    energy_required = 1.0,
    results = {{type="item", name="pktff-circuit-substrate", amount=2}},
    allow_productivity = true,
    auto_recycle = false,
    allow_decomposition = false,
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/wood.png",
      Asset"graphics/icons/circuit-substrate.png"
    )
  },
  {
    type = "recipe",
    name = "pktff-circuit-substrate-plastic",
    subgroup = "intermediate-product",
    order = "b[circuits]-![circuit-substrate]-c",
    category = "electronics",
    enabled = false,
    ingredients = {
      {type="item", name="plastic-bar", amount=10},
      {type="item", name="copper-plate", amount=5},
      {type="item", name="copper-cable", amount=15},
    },
    energy_required = 10.0,
    results = {{type="item", name="pktff-circuit-substrate", amount=20}},
    allow_productivity = true,
    auto_recycle = false,
    allow_decomposition = false,
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/plastic-bar.png",
      Asset"graphics/icons/circuit-substrate.png"
    )
  },
}

data:extend{{
  type = "recipe",
  name = "pktff-shotgun-turret",
  category = "crafting",
  enabled = false,
  ingredients = {
    -- Haha
    {type="item", name="gun-turret", amount=1},
    {type="item", name="shotgun", amount=1},
  },
  energy_required = 10,
  results = {{type="item", name="pktff-shotgun-turret", amount=1}}
}}

local function poc_recipe(hi_pressure)
  local name = hi_pressure and "high-pressure" or "low-pressure"
  local pressure_bound = hi_pressure and "min" or "max"
  local icon_under = hi_pressure 
    and "__base__/graphics/icons/nauvis.png"
    or "__space-age__/graphics/icons/solar-system-edge.png"

  return {
    type = "recipe",
    name = "pktff-precision-optical-component-" .. name,
    -- it would probably just be bloat to add a "vacuum craftinginator"
    category = "advanced-crafting",
    enabled = false,
    -- i want your first craft of this on Viate to feel REALLY GOOD AND FAST
    -- therefore, the space recipe can't be *too* complicated, so you get to it soon.
    energy_required = hi_pressure and 20 or 4,
    ingredients = {
      { type="item", name="advanced-circuit", amount=5 },
      { type="item", name="solar-panel", amount=1 },
      -- it's funny to me
      { type="item", name="small-lamp", amount=5 },
      -- mostly to make heavy oil used for SOMETHING
      hi_pressure and { type="fluid", name="heavy-oil", amount=50 } or nil,
    },
    results = {
      { type="item", name="pktff-precision-optical-component", amount=4 },
    },
    allow_productivity = true,
    allow_quality = true,
    auto_recycle = hi_pressure,
    surface_conditions = {{property="pressure", [pressure_bound]=500}},
    icons = {
      { icon = icon_under },
      { icon = Asset"graphics/icons/precision-optical-component.png" },
    }
  }
end
data:extend{
  poc_recipe(true),
  poc_recipe(false),
}

-- Chemistry for rocket science
data:extend{
  {
    type = "recipe",
    name = "pktff-water-electrolysis",
    category = "chemistry",
    ingredients = {
      {type="fluid", name="water", amount=100},
    },
    results = {
      -- Do it in mols, I guess? This is what GT does
      {type="fluid", name="pktff-hydrogen", amount=200},
      {type="fluid", name="pktff-oxygen", amount=100},
    },
    -- So the play here is to just make a buttload of chemmy plants
    -- and use *efficiency* modules, not speed mods
    energy_required = 300,
    enabled = false,
    subgroup = "intermediate-recipe",
    order = "d[electro]-a",
    icons = pglobals.icons.one_into_two(
      "__base__/graphics/icons/fluid/water.png",
      Asset"graphics/icons/fluid/molecule-hydrogen.png",
      Asset"graphics/icons/fluid/molecule-oxygen.png"
    ),
  },
  {
    type = "recipe",
    name = "pktff-the-cooler-water-electrolysis",
    category = "electromagnetics",
    ingredients = {
      {type="fluid", name="water", amount=100},
      {type="fluid", name="electrolyte", amount=10},
    },
    results = {
      {type="fluid", name="pktff-hydrogen", amount=200},
      {type="fluid", name="pktff-oxygen", amount=100},
    },
    energy_required = 60,
    enabled = false,
    subgroup = "intermediate-recipe",
    order = "d[electro]-b",
    icons = pglobals.icons.one_into_two(
      "__space-age__/graphics/icons/fluid/electrolyte.png",
      Asset"graphics/icons/fluid/molecule-hydrogen.png",
      Asset"graphics/icons/fluid/molecule-oxygen.png"
    ),
  },
  {
    type = "recipe",
    name = "pktff-ammonia-synthesis",
    category = "chemistry-or-cryogenics",
    ingredients = {
      {type="fluid", name="petroleum-gas", amount=20},
      -- this way you have something to do with all that hydrogen,
      -- but you still have to juice some of it
      {type="fluid", name="pktff-hydrogen", amount=10},
      -- this is your "finely powdered iron".
      -- i am an iron stick truther. if the devs added it, it should
      -- be used for things
      {type="item", name = "iron-stick", amount=4},
    },
    -- works on nauvis, gleba, and fulgora
    surface_conditions = {
      {property="pktff-atmospheric-nitrogen", min=50}
    },
    energy_required = 5,
    enabled = false,
    results = {{type="fluid", name="ammonia", amount=10}},
    subgroup = "intermediate-recipe",
    order = "e[synthesis]-a",
    -- Ignore the iron stick cause it's silly
    icons = pglobals.icons.two_into_one(
      "__base__/graphics/icons/fluid/petroleum-gas.png",
      Asset"graphics/icons/fluid/molecule-hydrogen.png",
      "__space-age__/graphics/icons/fluid/ammonia.png"
    )
  },
  {
    type = "recipe",
    name = "pktff-nitric-acid",
    category = "oil-processing",
    additional_categories = {"cryogenics"},
    ingredients = {
      -- Friendship ended with ostwald process
      -- now this made up thing is my new friend
      {type="fluid", name="ammonia", amount=10},
      {type="fluid", name="pktff-oxygen", amount=20},
      {type="item", name="sulfur", amount=1},
    },
    energy_required = 7,
    enabled = false,
    results = {
      {type="fluid", name="pktff-nitric-acid", amount=10},
      -- half the efficiency of the normal recipe
      {type="fluid", name="sulfuric-acid", amount=5},
    },
    main_product = "pktff-nitric-acid",
    subgroup = "intermediate-recipe",
    order = "e[synthesis]-b",
  },
}
