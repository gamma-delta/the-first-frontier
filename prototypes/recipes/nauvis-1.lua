-- Recipes for before space
local pglobals = require("globals")

-- Bad aluminum
data:extend{
  {
    type = "recipe",
    name = "native-aluminum-to-plate",
    category = "smelting",
    order = "za[native-aluminum-to-plate]",
    enabled = false,
    energy_required = 3.2,
    allow_productivity = true,
    ingredients = {{ type="item", name="native-aluminum", amount=2 }},
    results = {{ type="item", name="aluminum-plate", amount=1 }},
  },
  {
    -- This recipe should mega suck
    type = "recipe",
    name = "simple-bauxite-extraction",
    category = "chemistry",
    additional_categories = {"centrifuging"},
    subgroup = "chemistry",
    order = "c[aluminum]-a",
    enabled = false,
    allow_decomposition = false,
    ingredients = {
      {type="item", name="bauxite-ore", amount=5},
      {type="item", name="stone", amount=10},
      {type="fluid", name="sulfuric-acid", amount=200},
      {type="fluid", name="steam", amount=500},
    },
    energy_required = 30,
    results = {{type="item", name="native-aluminum", amount=1}},
    auto_recycle = false,
    allow_productivity = true,
    allow_decomposition = false,
    icons = pglobals.icons.two_into_one(
      "__base__/graphics/icons/fluid/sulfuric-acid.png",
      "__base__/graphics/icons/fluid/steam.png",
      "__petraspace__/graphics/icons/bauxite/1.png"
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
    name = "circuit-substrate-stone",
    subgroup = "intermediate-product",
    order = "b[circuits]-![circuit-substrate]-a",
    category = "crafting",
    enabled = false,
    ingredients = {
      {type="item", name="stone-brick", amount=1},
      {type="item", name="copper-plate", amount=1},
    },
    energy_required = 0.5,
    results = {{type="item", name="circuit-substrate", amount=1}},
    allow_productivity = true,
    auto_recycle = false,
    -- the "default" i suppose
    allow_decomposition = true,
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/stone-brick.png",
      "__petraspace__/graphics/icons/circuit-substrate.png"
    )
  },
  {
    type = "recipe",
    name = "circuit-substrate-wood",
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
    results = {{type="item", name="circuit-substrate", amount=2}},
    allow_productivity = true,
    auto_recycle = false,
    allow_decomposition = false,
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/wood.png",
      "__petraspace__/graphics/icons/circuit-substrate.png"
    )
  },
  {
    type = "recipe",
    name = "circuit-substrate-plastic",
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
    results = {{type="item", name="circuit-substrate", amount=20}},
    allow_productivity = true,
    auto_recycle = false,
    allow_decomposition = false,
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/plastic-bar.png",
      "__petraspace__/graphics/icons/circuit-substrate.png"
    )
  },
}
pglobals.recipe.replace("electronic-circuit", "iron-plate", "circuit-substrate")
-- they are very tall
table.insert(data.raw["recipe"]["advanced-circuit"].ingredients,
  {type="item", name="circuit-substrate", amount=2})
data.raw["recipe"]["processing-unit"].ingredients = {
  {type="item", name="advanced-circuit", amount=2},
  {type="item", name="electronic-circuit", amount=20},
  {type="item", name="circuit-substrate", amount=5},
  -- more properly, nitric acid is used for this IRL
  -- however, i want sulfuric and acid to have seperate identities.
  -- Sulfuric is used for grungy mechanical processes
  -- Nitric is used for clean futuristic processes
  {type="fluid", name="sulfuric-acid", amount=20},
}

-- Steel needs nasty fuel
-- Apparently there are only 4 smelting recipes in vanilla:
-- iron, copper, steel, and bricks
data.raw["recipe"]["steel-plate"].category = "dirty-smelting"

-- Sulfur can be produced with only petro gas,
-- so cracking can require sulfuric acid.
pglobals.recipe.replace("heavy-oil-cracking", "water",
  {type="fluid", name="sulfuric-acid", amount=20})
pglobals.recipe.replace("light-oil-cracking", "water",
  {type="fluid", name="sulfuric-acid", amount=20})

-- Misc mall ingredient changes
table.insert(data.raw["recipe"]["medium-electric-pole"].ingredients,
  {type="item", name="stone-brick", amount=2})
table.insert(data.raw["recipe"]["big-electric-pole"].ingredients,
  {type="item", name="concrete", amount=2})
table.insert(data.raw["recipe"]["substation"].ingredients,
  {type="item", name="refined-concrete", amount=10})

local function poc_recipe(hi_pressure)
  local name = hi_pressure and "high-pressure" or "low-pressure"
  local pressure_bound = hi_pressure and "min" or "max"
  local icon_under = hi_pressure 
    and "__base__/graphics/icons/nauvis.png"
    or "__space-age__/graphics/icons/solar-system-edge.png" 

  return {
    type = "recipe",
    name = "precision-optical-component-" .. name,
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
      { type="item", name="precision-optical-component", amount=4 },
    },
    allow_productivity = true,
    allow_quality = true,
    auto_recycle = hi_pressure,
    surface_conditions = {{property="pressure", [pressure_bound]=500}},
    icons = {
      { icon = icon_under },
      { icon = "__petraspace__/graphics/icons/precision-optical-component.png" },
    }
  }
end
data:extend{
  poc_recipe(true),
  poc_recipe(false),
}

data:extend{
  {
    type = "recipe",
    name = "orbital-data-card-high-pressure",
    category = "crafting",
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
    category = "crafting",
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
    name = "rocket-control-unit",
    category = "crafting",
    enabled = false,
    ingredients = {
      {type="item", name="orbital-data-card", amount=1},
      {type="item", name="processing-unit", amount=1},
      {type="item", name="electric-engine-unit", amount=1},
    },
    energy_required = 10,
    results = {{type="item", name="rocket-control-unit", amount=1}},
    auto_recycle = false,
  }
}

-- Make things use POC
data.raw["recipe"]["laser-turret"].ingredients = {
  -- vanilla is 20 grurcuits
  {type="item", name="advanced-circuit", amount=10},
  {type="item", name="precision-optical-component", amount=20},
  {type="item", name="steel-plate", amount=20},
  {type="item", name="battery", amount=20},
}
table.insert(
  data.raw["recipe"]["night-vision-equipment"].ingredients,
  {type="item", name="precision-optical-component", amount=20}
)

-- These things are SO expensive. Why?
local heat_pipe_recipe = data.raw["recipe"]["heat-pipe"]
heat_pipe_recipe.category = "advanced-crafting"
heat_pipe_recipe.ingredients = {
  { type="item", name="copper-plate", amount=5 },
  { type="item", name="steel-plate", amount=2 },
  { type="fluid", name="water", amount=100 },
}
heat_pipe_recipe.allow_decomposition = true

-- Fix up LDS recipe
-- The molten one is in vulcanus-1
data.raw["recipe"]["low-density-structure"].ingredients = {
  { type="item", name="steel-plate", amount=2 },
  { type="item", name="copper-plate", amount=10 },
  { type="item", name="aluminum-plate", amount=1 },
  { type="item", name="plastic-bar", amount=5 },
}
pglobals.recipe.replace("flying-robot-frame", "steel-plate", "low-density-structure")

-- stop POSTING about SHOVING STONE INTO CHESTS
-- this is only 1 iron plate per 50 stone, quite cheap,
-- but it means you can't compress stone 50->1 and need to
-- actually handle it.
-- Turn it into ourple science or make your walls thicker or something.
table.insert(data.raw["recipe"]["landfill"].ingredients,
  {type="item", name="iron-stick", amount=2})

data:extend{
  {
    type = "recipe",
    name = "space-platform-scaffolding",
    enabled = false,
    ingredients = {
      {type="item", name="iron-stick", amount=20},
      {type="item", name="aluminum-plate", amount=1},
      {type="item", name="electric-engine-unit", amount=1},
    },
    energy_required = 5,
    results = {{type="item", name="space-platform-scaffolding", amount=1}},
  },
  {
    type = "recipe",
    name = "ps-space-platform-starter-pack-scaffolding",
    enabled = false,
    ingredients = {
      {type="item", name="space-platform-foundation", amount=60},
      {type="item", name="aluminum-plate", amount=20},
      {type="item", name="advanced-circuit", amount=20},
    },
    energy_required = 60,
    results = {{type="item", name="ps-space-platform-starter-pack-scaffolding", amount=1}},
  },
}

-- SLEGT: Now on Nauvis!
local slegt_recipe = data.raw["recipe"]["snouz_long_electric_gun_turret"]
slegt_recipe.category = "crafting"
slegt_recipe.energy = 5
slegt_recipe.ingredients = {
  {type="item", name="gun-turret", amount=2},
  {type="item", name="precision-optical-component", amount=1},
  {type="item", name="electronic-circuit", amount=2},
}
-- Make shotgun turrets autocraftable w/o Gleba
pglobals.recipe.replace("combat-shotgun", "wood",
  {type="item", name="aluminum-plate", amount=5})
data:extend{{
  type = "recipe",
  name = "shotgun-turret",
  category = "crafting",
  enabled = false,
  ingredients = {
    -- Haha
    {type="item", name="gun-turret", amount=1},
    {type="item", name="combat-shotgun", amount=1},
  },
  energy = 10,
  results = {{type="item", name="shotgun-turret", amount=1}}
}}

-- TIER 1 --
data:extend{
  -- Same ratios as steel
  {
    type = "recipe",
    name = "depleted-uranium",
    category = "smelting",
    ingredients = {{type="item", name="uranium-ore", amount=5}},
    energy_required = 16,
    results = {{type="item", name="uranium-238", amount=1}},
    enabled = false,
  },
}
local nuke_colors = {
  primary = {0.3, 1, 0},
  secondary = {0.2, 1, 0},
  tertiary = {0.1, 1, 0},
  quaternary = {0.3, 1, 0},
}
local function nuke_waste(count)
  return {
    type = "item", name = "nuclear-waste", amount = count,
    percent_spoiled = 0, ignored_by_productivity = 9999,
  }
end

local centri_recipe = data.raw["recipe"]["centrifuge"]
centri_recipe.ingredients = {
  { type="item", name="advanced-circuit", amount=100 },
  { type="item", name="concrete", amount=100 },
  { type="item", name="electric-engine-unit", amount=25 },
  { type="item", name="steel-plate", amount=50 },
  { type="item", name="uranium-238", amount=5 },
}
-- don't ask me how you make a centrifuge in a centrifuge
centri_recipe.additional_categories = {"centrifuging"}
centri_recipe.crafting_machine_tint = nuke_colors

local reactor_recipe = data.raw["recipe"]["nuclear-reactor"]
table.insert(reactor_recipe.ingredients,
  {type="item", name="uranium-238", amount=500})

local u_proc = data.raw["recipe"]["uranium-processing"]
u_proc.crafting_machine_tint = nuke_colors
table.insert(u_proc.results, nuke_waste(1))
-- but keep everything else the same.
-- i ~* could *~ make it produce stone and stone byproducts, but ... like. why

data.raw["recipe"]["uranium-fuel-cell"] = {
  type = "recipe",
  name = "uranium-fuel-cell",
  enabled = false,
  category = "centrifuging",
  ingredients = {
    {type="item", name="uranium-235", amount=10},
    {type="item", name="uranium-238", amount=20},
    {type="item", name="steel-plate", amount=10},
  },
  energy_required = 10,
  results = {
    {type="item", name="uranium-fuel-cell", amount=10},
    nuke_waste(1),
  },
  main_product = "uranium-fuel-cell",
  crafting_machine_tint = nuke_colors,
  allow_productivity = true,
  allow_decomposition = true,
}

local cell_reproc = data.raw["recipe"]["nuclear-fuel-reprocessing"]
cell_reproc.crafting_machine_tint = {
  primary = {0.8, 0.4, 0},
  secondary = {0.7, 0.7, 0},
  tertiary = {0, 1, 0},
  quaternary = {0, 1, 0},
}
cell_reproc.ingredients[1].amount = 1
cell_reproc.results = {
  -- 1/4 input U
  {type="item", name="uranium-238", amount=1, probability = 0.5},
  {type="item", name="plutonium", amount=1, probability = 0.8},
  nuke_waste(5),
}

data:extend{
  {
    type = "recipe",
    name = "mox-fuel-cell",
    enabled = false,
    allow_productivity = true,
    category = "centrifuging",
    ingredients = {
      {type="item", name="uranium-235", amount=2},
      {type="item", name="plutonium", amount=10},
      {type="item", name="steel-plate", amount=10},
      {type="item", name="uranium-238", amount=20},
    },
    energy_required = 20,
    results = {
      {type="item", name="mox-fuel-cell", amount=10},
      nuke_waste(1),
    },
    main_product = "mox-fuel-cell",
    crafting_machine_tint = {
      primary = {0.8, 0.4, 0},
      secondary = {0.8, 0.8, 0},
      tertiary = {0, 1, 0},
      quaternary = {1, 1, 0},
    }
  },
  {
    type = "recipe",
    name = "breeder-fuel-cell",
    enabled = false,
    allow_productivity = true,
    category = "centrifuging",
    ingredients = {
      {type="item", name="uranium-235", amount=2},
      {type="item", name="plutonium", amount=20},
      {type="item", name="steel-plate", amount=10},
      {type="item", name="uranium-238", amount=20},
    },
    energy_required = 30,
    results = {
      {type="item", name="breeder-fuel-cell", amount=10},
      nuke_waste(1),
    },
    main_product = "breeder-fuel-cell",
    crafting_machine_tint = {
      primary = {0.8, 0.4, 0},
      secondary = {0.8, 0.8, 0},
      tertiary = {1.0, 0.5, 0},
      quaternary = {1, 0.5, 0},
    },
  },
  {
    type = "recipe",
    name = "breeder-fuel-cell-reprocessing",
    enabled = false,
    allow_productivity = true,
    category = "centrifuging",
    subgroup = "uranium-processing",
    order = "b[uranium-products]-za",
    -- TODO
    icons = pglobals.icons.mini_over(
      "__petraspace__/graphics/icons/plutonium.png",
      "__petraspace__/graphics/icons/depleted-breeder-fuel-cell.png"
    ),
    ingredients = {
      {type="item", name="depleted-breeder-fuel-cell", amount=1},
    },
    energy_required = 60,
    -- 20 -> 30
    results = {
      {type="item", name="plutonium", amount=3},
      nuke_waste(10),
    },
    allow_decomposition = false,
    crafting_machine_tint = {
      primary = {0.8, 0.4, 0},
      secondary = {0.8, 0.8, 0},
      tertiary = {1.0, 0.5, 0},
      quaternary = {1, 0.5, 0},
    },
  },

  -- The objective is for dumping waste to be dramatically worst in terms of
  -- centrifuge-pollution-seconds/waste.
  -- But making reprocessing take a long time can undermine that;
  -- if it took 10x as long to reprocess one piece of waste as to
  -- dump it at 10x pollution, that's the same amount of pollution.
  -- Also, measure centrifuge-seconds/waste

  -- 30 CPS/W
  -- 30 CS/W
  {
    type = "recipe",
    name = "nuclear-waste-reprocessing",
    enabled = false,
    category = "centrifuging",
    subgroup = "uranium-processing",
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/arrows/signal-shuffle.png",
      "__petraspace__/graphics/icons/nuclear-waste.png"
    ),
    order = "z-a",
    ingredients = {
      {type="item", name="nuclear-waste", amount=10},
      {type="fluid", name="nitric-acid", amount=20},
    },
    energy_required = 300,
    results = {
      -- STONE AND STONE BYPRODUCTS
      {type="item", name="stone", amount=5},
      {type="item", name="iron-ore", amount=3},
      -- note you can get productivity here
      {type="item", name="uranium-ore", amount=10},
    },
    allow_decomposition = false,
    -- why not
    allow_productivity = true,
    crafting_machine_tint = {
      primary = {1.0, 1.0, 0},
      secondary = {0.8, 1.0, 0},
      tertiary = {0, 1.0, 0},
      quaternary = {1, 1, 0},
    },
  },
  -- 2 CPS/W
  -- 2 CS/W
  {
    type = "recipe",
    name = "barreled-nuclear-waste",
    enabled = false,
    category = "centrifuging",
    subgroup = "uranium-processing",
    order = "z-b",
    ingredients = {
      {type="item", name="nuclear-waste", amount=10},
      {type="item", name="barrel", amount=1},
      {type="fluid", name="water", amount=100},
    },
    energy_required = 5,
    results = {{type="item", name="barreled-nuclear-waste", amount=1}},
    allow_decomposition = true,
    allow_productivity = false,
    auto_recycle = false,
    crafting_machine_tint = {
      primary = {1.0, 1.0, 0},
      secondary = {0.8, 0.8, 0},
      tertiary = {0.5, 1.0, 0},
      quaternary = {1, 1, 0},
    },
  },
  -- 92 CPS/W
  -- 1 CS/W
  {
    type = "recipe",
    name = "nuclear-waste-dumping",
    enabled = false,
    category = "centrifuging",
    subgroup = "uranium-processing",
    order = "z-c",
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/signal/signal-trash-bin.png",
      "__petraspace__/graphics/icons/nuclear-waste.png"
    ),
    ingredients = {{type="item", name="nuclear-waste", amount=1}},
    energy_required = 1,
    results = {},
    allow_decomposition = false,
    allow_productivity = false,
    allow_efficiency = false,
    allow_pollution = false,
    crafting_machine_tint = {
      primary = {1.0, 1.0, 0},
      secondary = {0.8, 0.8, 0},
      tertiary = {0.5, 1.0, 0},
      quaternary = {1, 1, 0},
    },
    -- U atomic number
    emissions_multiplier = 92,
  },
}

-- TODO: give these actual prereqs
for _,tech in ipairs{"atomic-bomb", "captive-biter-spawner"} do
  local proto = data.raw["technology"][tech]
  for i,req in ipairs(proto.prerequisites) do
    if req == "kovarex-enrichment-process" then
      table.remove(proto.prerequisites, i)
      goto continue
    end
  end
  ::continue::
end
data.raw["technology"]["kovarex-enrichment-process"] = nil
data.raw["recipe"]["kovarex-enrichment-process"] = nil

-- Replace cryo with centrifuge for chemical recipes that are just
-- whacking things together
for _,recipename in ipairs{
  "acid-neutralisation", "holmium-solution"
} do
  local recipe = data.raw["recipe"][recipename]
  recipe.category = "chemistry"
  recipe.additional_categories = {"centrifuging"}
end
