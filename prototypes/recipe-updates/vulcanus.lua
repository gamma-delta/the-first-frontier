local pglobals = require "globals"

for _,calcite2lime in ipairs{
  -- Switch most things to use quicklime, but leave a few calcite-only ones
  -- Calcite is now Vulcanus-only! Quicklime can be obtained from space.
  -- If I end up implementing glass, then calcite can be used for
  -- more efficiency there too.
  "molten-iron", "molten-copper",
  "molten-iron-from-lava", "molten-copper-from-lava",
  "acid-neutralisation",
  -- just like expanding grout!
  "cliff-explosives",
} do
  local recipe = data.raw["recipe"][calcite2lime]
  for _,ingredient in ipairs(recipe.ingredients) do
    if ingredient.type == "item" and ingredient.name == "calcite" then
      ingredient.name = "pktff-quicklime"
    end
  end
end

pglobals.recipe.add("coal-liquefaction",
  {type="item", name="calcite", amount=1})
pglobals.recipe.add("casting-steel",
  {type="item", name="carbon", amount=1})

-- Foundries only allow 2 fluids :<
data.raw["recipe"]["casting-low-density-structure"].ingredients = {
  { type="fluid", name="molten-copper", amount=250 },
  { type="fluid", name="pktff-molten-aluminum", amount=8 },
  { type="item", name="steel-plate", amount=2 },
  { type="item", name="plastic-bar", amount=5 },
}
