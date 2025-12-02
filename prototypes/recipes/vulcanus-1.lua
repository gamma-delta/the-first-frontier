local pglobals = require "globals"

data:extend{
  {
    type = "recipe",
    name = "geothermal-heat-exchanger",
    category = "crafting",
    additional_categories = {"metallurgy"},
    enabled = false,
    ingredients = {
      {type="item", name="heating-tower", amount=4},
      {type="item", name="heat-pipe", amount=20},
      {type="item", name="concrete", amount=50},
    },
    energy_required = 10,
    results = {{type="item", name="geothermal-heat-exchanger", amount=1}},
  },
  {
    type = "recipe",
    name = "lime-calcination",
    category = "metallurgy",
    enabled = false,
    show_amount_in_title = false,
    surface_properties = {
      {name="pressure", min=4000, max=4000}
    },
    ingredients = {
      {type="item", name="calcite", amount=50},
    },
    energy_required = 60,
    results = {
      -- Low quicklime amount means
      -- 1. you have to mine a lot of calcite
      --    (in vanilla, calcite is less of a resource and more of a check)
      -- 2. you need a lot of foundries
      {type="item", name="quicklime", amount=10},
      -- TODO: swap back to magslag once I implement post-Aquilo1
      {type="item", name="native-aluminum", amount_min=0, amount_max=4}
    },
    main_product = "quicklime",
  },
  -- I don't THINK that you can infinitely generate resources like this
  -- because you can't get 300% productivity without a prod research
  {
    type = "recipe",
    name = "concrete-from-quicklime",
    category = "metallurgy",
    enabled = false,
    auto_recycle = false,
    allow_productivity = true,
    allow_decomposition = false,
    icons = pglobals.icons.two_into_one(
      "__petraspace__/graphics/icons/quicklime/1.png",
      "__space-age__/graphics/icons/fluid/molten-iron.png",
      "__base__/graphics/icons/concrete.png"
    ),
    ingredients = {
      {type="item", name="stone-brick", amount=20},
      {type="item", name="quicklime", amount=1},
      {type="fluid", name="molten-iron", amount=10},
      {type="fluid", name="water", amount=100},
    },
    energy_required = 10,
    results = {
      {type="item", name="concrete", amount=20},
    },
    main_product = "concrete",
  },
  {
    type = "recipe",
    name = "refined-concrete-from-quicklime",
    category = "metallurgy",
    enabled = false,
    auto_recycle = false,
    allow_productivity = true,
    allow_decomposition = false,
    icons = pglobals.icons.two_into_one(
      "__petraspace__/graphics/icons/quicklime/1.png",
      "__space-age__/graphics/icons/fluid/molten-iron.png",
      "__base__/graphics/icons/refined-concrete.png"
    ),
    ingredients = {
      {type="item", name="concrete", amount=20},
      {type="item", name="quicklime", amount=5},
      {type="item", name="steel-plate", amount=1},
      {type="fluid", name="molten-iron", amount=10},
      {type="fluid", name="water", amount=100},
    },
    energy_required = 10,
    results = {
      {type="item", name="refined-concrete", amount=20},
    },
    main_product = "refined-concrete",
  },
}

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
      ingredient.name = "quicklime"
    end
  end
end

pglobals.recipe.add("coal-liquefaction",
  {type="item", name="calcite", amount=1})
pglobals.recipe.add("casting-steel",
  {type="item", name="carbon", amount=1})

data:extend{
  {
    type = "recipe",
    name = "tungsten-heat-pipe",
    category = "metallurgy",
    enabled = false,
    -- TODO this does not recycle
    -- big mining drills and turbelts are ~* hard coded *~ I GUESS,
    -- all other metallurgy is no recycling. will need to fix this.
    allow_productivity = true,
    allow_decomposition = true,
    surface_conditions = {
      {property="pressure", min=4000, max=4000},
    },
    ingredients = {
      {type="item", name="tungsten-plate", amount=5},
      {type="item", name="copper-plate", amount=10},
      {type="fluid", name="water", amount=200},
    },
    energy_required = 2,
    results = {
      {type="item", name="tungsten-heat-pipe", amount=1},
    },
  },
  {
    type = "recipe",
    name = "tungsten-steel-strongbox",
    category = "metallurgy",
    enabled = false,
    -- TODO also does not recycle
    allow_productivity = false,
    allow_decomposition = true,
    ingredients = {
      {type="item", name="steel-chest", amount=4},
      {type="item", name="tungsten-plate", amount=8},
    },
    energy_required = 4,
    results = {
      {type="item", name="tungsten-steel-strongbox", amount=1},
    }
  }
}
