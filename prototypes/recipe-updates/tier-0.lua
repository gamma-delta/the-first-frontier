local pglobals = require "globals"
-- Recipes before space

-- Circuit substrates
pglobals.recipe.replace("electronic-circuit", "iron-plate", "pktff-circuit-substrate")
-- they are very tall
table.insert(data.raw["recipe"]["advanced-circuit"].ingredients,
  {type="item", name="pktff-circuit-substrate", amount=2})
data.raw["recipe"]["processing-unit"].ingredients = {
  {type="item", name="advanced-circuit", amount=2},
  {type="item", name="electronic-circuit", amount=20},
  {type="item", name="pktff-circuit-substrate", amount=5},
  -- more properly, nitric acid is used for this IRL
  -- however, i want sulfuric and acid to have seperate identities.
  -- Sulfuric is used for grungy mechanical processes
  -- Nitric is used for clean futuristic processes
  {type="fluid", name="pktff-nitric-acid", amount=20},
}

-- stop POSTING about SHOVING STONE INTO CHESTS
-- this is only 1 iron plate per 50 stone, quite cheap,
-- but it means you can't compress stone 50->1 and need to
-- actually handle it.
-- Turn it into ourple science or make your walls thicker or something.
table.insert(data.raw["recipe"]["landfill"].ingredients,
  {type="item", name="iron-stick", amount=2})

-- Steel needs nasty fuel
-- Apparently there are only 4 smelting recipes in vanilla:
-- iron, copper, steel, and bricks
data.raw["recipe"]["steel-plate"].category = "pktff-dirty-smelting"

-- Misc mall ingredient changes
table.insert(data.raw["recipe"]["medium-electric-pole"].ingredients,
  {type="item", name="stone-brick", amount=2})
table.insert(data.raw["recipe"]["big-electric-pole"].ingredients,
  {type="item", name="concrete", amount=2})
table.insert(data.raw["recipe"]["substation"].ingredients,
  {type="item", name="refined-concrete", amount=10})

-- Sulfur can be produced with only petro gas,
-- so cracking can require sulfuric acid.
pglobals.recipe.replace("heavy-oil-cracking", "water",
  {type="fluid", name="sulfuric-acid", amount=20})
pglobals.recipe.replace("light-oil-cracking", "water",
  {type="fluid", name="sulfuric-acid", amount=20})

-- SLEGT: Now on Nauvis!
local slegt_recipe = data.raw["recipe"]["snouz_long_electric_gun_turret"]
slegt_recipe.category = "crafting"
slegt_recipe.energy_required = 5
slegt_recipe.ingredients = {
  {type="item", name="gun-turret", amount=2},
  {type="item", name="pktff-precision-optical-component", amount=1},
  {type="item", name="electronic-circuit", amount=2},
}
-- Make shotgun turrets autocraftable w/o Gleba
pglobals.recipe.replace("combat-shotgun", "wood",
  {type="item", name="pktff-aluminum-plate", amount=5})
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
  energy_required = 10,
  results = {{type="item", name="pktff-shotgun-turret", amount=1}}
}}

-- Make things use POC
data.raw["recipe"]["laser-turret"].ingredients = {
  -- vanilla is 20 grurcuits
  {type="item", name="advanced-circuit", amount=10},
  {type="item", name="pktff-precision-optical-component", amount=20},
  {type="item", name="steel-plate", amount=20},
  {type="item", name="battery", amount=20},
}
table.insert(
  data.raw["recipe"]["night-vision-equipment"].ingredients,
  {type="item", name="pktff-precision-optical-component", amount=20}
)

-- Make things use aluminum
-- Fix up LDS recipe
-- The molten one is in vulcanus-1
data.raw["recipe"]["low-density-structure"].ingredients = {
  { type="item", name="steel-plate", amount=2 },
  { type="item", name="copper-plate", amount=10 },
  { type="item", name="pktff-aluminum-plate", amount=1 },
  { type="item", name="plastic-bar", amount=5 },
}
pglobals.recipe.replace("flying-robot-frame", "steel-plate", "low-density-structure")

-- These things are SO expensive. Why?
local heat_pipe_recipe = data.raw["recipe"]["heat-pipe"]
heat_pipe_recipe.category = "advanced-crafting"
heat_pipe_recipe.ingredients = {
  { type="item", name="copper-plate", amount=5 },
  { type="item", name="steel-plate", amount=2 },
  { type="fluid", name="water", amount=100 },
}
heat_pipe_recipe.allow_decomposition = true
