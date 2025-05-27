local pglobals = require "globals"

data:extend{
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
      {type="item", name="quicklime", amount=40},
      {type="item", name="magnesium-slag", amount_min=0, amount_max=4}
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
  -- Keep the basic planetside recipes using normal calcite.
  -- This is metal from lava and simple liquefaction.
  -- This way if you're a madman you can make use orbital quicklime to
  -- run your foundaries, and it's still easier to get set up on Vulc.
  "acid-neutralisation", "molten-iron", "molten-copper",
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

pglobals.recipe.add("metallurgic-science-pack",
  {type="item", name="native-aluminum", amount=1})

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
  }
}
