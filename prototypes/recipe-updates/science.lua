local pglobals = require "globals"

-- Do i want to mess with red science? Maybe?
-- There's not a lot of things you could add that are
-- - not annoying
-- - not redundant with green science
-- pipes maybe?

-- Fuck you make steel
-- I think part of the vertical difficulty curve of bluence is
-- that you have to make steel *and* oil, and steel requires
-- a startlingly huge footprint
table.insert(
  data.raw["recipe"]["logistic-science-pack"].ingredients,
  {type="item", name="steel-plate", amount=1}
)

table.insert(
  data.raw["recipe"]["chemical-science-pack"].ingredients,
  {type="item", name="concrete", amount=1}
)

-- Not super sure what to put here either.
-- In ye olden days it required gun turrets, but they dropped that
-- because the turrets were so spensive.
-- Maybe shotun shells, to make sure you make some for defense?
table.insert(
  data.raw["recipe"]["military-science-pack"].ingredients,
  {type="item", name="shotgun-shell", amount=1}
)

local spience = data.raw["recipe"]["space-science-pack"]
-- Spience makes 5 of them
-- you way overproduce iron on the moon, given that you have
-- to ship in all of your steel.
-- therefore I want spience to be a huge iron hog.
spience.ingredients = {
  {type="item", name="pktff-space-platform-scaffolding", amount=5},
  {type="item", name="pktff-precision-optical-component", amount=5},
  {type="item", name="long-handed-inserter", amount=5},
  {type="item", name="storage-tank", amount=1},
}
spience.surface_conditions = {{ property="gravity", max=2.5 }}

local purple_sci = data.raw["recipe"]["production-science-pack"]
purple_sci.ingredients = {
  {type="item", name="electric-furnace", amount=1},
  {type="item", name="productivity-module", amount=1},
  {type="item", name="rail", amount=30},
  {type="item", name="pktff-circuit-substrate", amount=30},
  {type="item", name="pktff-nuclear-waste", amount=1, ignored_by_stats=1},
}
purple_sci.results[1].amount = 5
-- On average, slowly consumes waste. But like really, really slowly
table.insert(purple_sci.results,
  {type="item", name="pktff-nuclear-waste", amount=1, probability = 0.99,
    ignored_by_productivity = 9999, ignored_by_stats=1})
purple_sci.main_product = "production-science-pack"

local yellow_sci = data.raw["recipe"]["utility-science-pack"]
yellow_sci.ingredients = {
  {type="item", name="flying-robot-frame", amount=1},
  {type="item", name="low-density-structure", amount=3},
  {type="item", name="exoskeleton-equipment", amount=1},
  {type="item", name="pktff-plutonium", amount=1, ignored_by_stats=1},
}
yellow_sci.results[1].amount = 5
table.insert(yellow_sci.results,
  {type="item", name="pktff-plutonium", amount=1, probability = 0.99,
    ignored_by_productivity = 9999, ignored_by_stats=1})
yellow_sci.main_product = "utility-science-pack"

-- Forces reliance on the old bauxite recipe
pglobals.recipe.add("metallurgic-science-pack",
  {type="item", name="pktff-native-aluminum", amount=1})
-- this one is honestly a little half-baked
pglobals.recipe.add("electromagnetic-science-pack",
  {type="item", name="substation", amount=1})
-- nitrification! force you to interact with more of the glebafied recipes.
-- this is kind of half-baked too
pglobals.recipe.add("agricultural-science-pack",
  {type="fluid", name="pktff-nitric-acid", amount=20})
