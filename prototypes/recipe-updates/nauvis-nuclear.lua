local pglobals = require "globals"

-- Nuclear science. NOT for early-game recipes, those go in tier-0

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
centri_recipe.crafting_machine_tint = pglobals.colors.nuclear

local reactor_recipe = data.raw["recipe"]["nuclear-reactor"]
table.insert(reactor_recipe.ingredients,
  {type="item", name="uranium-238", amount=500})
local u_proc = data.raw["recipe"]["uranium-processing"]
u_proc.crafting_machine_tint = pglobals.colors.nuclear
table.insert(u_proc.results, pglobals.recipe.nuclear_waste(1))

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
    pglobals.recipe.nuclear_waste(1),
  },
  main_product = "uranium-fuel-cell",
  crafting_machine_tint = pglobals.colors.nuclear,
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
  {type="item", name="pktff-plutonium", amount=1, probability = 0.8},
  pglobals.recipe.nuclear_waste(5),
}

-- Replace cryo with centrifuge for chemical recipes that are just
-- whacking things together
for _,recipename in ipairs{
  "acid-neutralisation", "holmium-solution"
} do
  local recipe = data.raw["recipe"][recipename]
  recipe.category = "chemistry"
  recipe.additional_categories = {"centrifuging"}
end
data.raw["recipe"]["kovarex-enrichment-process"].hidden = true
