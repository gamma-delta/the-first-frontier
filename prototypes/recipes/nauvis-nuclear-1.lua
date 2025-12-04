-- Nauvis nuclear science
local pglobals = require("globals")
data:extend{
  -- Same ratios as steel
  {
    type = "recipe",
    name = "pktff-depleted-uranium",
    category = "smelting",
    ingredients = {{type="item", name="uranium-ore", amount=5}},
    energy_required = 16,
    results = {{type="item", name="uranium-238", amount=1}},
    enabled = false,
  },
}

data:extend{
  {
    type = "recipe",
    name = "pktff-mox-fuel-cell",
    enabled = false,
    allow_productivity = true,
    category = "centrifuging",
    ingredients = {
      {type="item", name="uranium-235", amount=2},
      {type="item", name="pktff-plutonium", amount=10},
      {type="item", name="steel-plate", amount=10},
      {type="item", name="uranium-238", amount=20},
    },
    energy_required = 20,
    results = {
      {type="item", name="pktff-mox-fuel-cell", amount=10},
      pglobals.recipe.nuclear_waste(1),
    },
    main_product = "pktff-mox-fuel-cell",
    crafting_machine_tint = {
      primary = {0.8, 0.4, 0},
      secondary = {0.8, 0.8, 0},
      tertiary = {0, 1, 0},
      quaternary = {1, 1, 0},
    }
  },
  {
    type = "recipe",
    name = "pktff-breeder-fuel-cell",
    enabled = false,
    allow_productivity = true,
    category = "centrifuging",
    ingredients = {
      {type="item", name="uranium-235", amount=2},
      {type="item", name="pktff-plutonium", amount=20},
      {type="item", name="steel-plate", amount=10},
      {type="item", name="uranium-238", amount=20},
    },
    energy_required = 30,
    results = {
      {type="item", name="pktff-breeder-fuel-cell", amount=10},
      pglobals.recipe.nuclear_waste(1),
    },
    main_product = "pktff-breeder-fuel-cell",
    crafting_machine_tint = {
      primary = {0.8, 0.4, 0},
      secondary = {0.8, 0.8, 0},
      tertiary = {1.0, 0.5, 0},
      quaternary = {1, 0.5, 0},
    },
  },
  {
    type = "recipe",
    name = "pktff-breeder-fuel-cell-reprocessing",
    enabled = false,
    allow_productivity = true,
    category = "centrifuging",
    subgroup = "uranium-processing",
    order = "b[uranium-products]-za",
    -- TODO
    icons = pglobals.icons.mini_over(
      Asset"graphics/icons/plutonium.png",
      Asset"graphics/icons/depleted-breeder-fuel-cell.png"
    ),
    ingredients = {
      {type="item", name="pktff-depleted-breeder-fuel-cell", amount=1},
    },
    energy_required = 60,
    -- 20 -> 30
    results = {
      {type="item", name="pktff-plutonium", amount=3},
      pglobals.recipe.nuclear_waste(10),
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
    name = "pktff-nuclear-waste-reprocessing",
    enabled = false,
    category = "centrifuging",
    subgroup = "uranium-processing",
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/arrows/signal-shuffle.png",
      Asset"graphics/icons/nuclear-waste.png"
    ),
    order = "z-a",
    ingredients = {
      {type="item", name="pktff-nuclear-waste", amount=10},
      {type="fluid", name="pktff-nitric-acid", amount=20},
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
    name = "pktff-barreled-nuclear-waste",
    enabled = false,
    category = "centrifuging",
    subgroup = "uranium-processing",
    order = "z-b",
    ingredients = {
      {type="item", name="pktff-nuclear-waste", amount=10},
      {type="item", name="barrel", amount=1},
      {type="fluid", name="water", amount=100},
    },
    energy_required = 5,
    results = {{type="item", name="pktff-barreled-nuclear-waste", amount=1}},
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
    name = "pktff-nuclear-waste-dumping",
    enabled = false,
    category = "centrifuging",
    subgroup = "uranium-processing",
    order = "z-c",
    icons = pglobals.icons.mini_over(
      "__base__/graphics/icons/signal/signal-trash-bin.png",
      Asset"graphics/icons/nuclear-waste.png"
    ),
    ingredients = {{type="item", name="pktff-nuclear-waste", amount=1}},
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
-- TODO: move this into a better locn
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
data.raw["technology"]["kovarex-enrichment-process"].hidden = true
