-- After conquering all planets once (where vanilla spage ends)
local pglobals = require "globals"

-- Petrichor enrichment process (holy shit hexcasting reference)
data:extend{
  {
    type = "recipe",
    name = "pktff-bauxite-liquor",
    category = "metallurgy",
    subgroup = "pktff-aluminum-processes",
    order = "c[aluminum]-b",
    ingredients = {
      { type="item", name="pktff-bauxite-ore", amount=100 },
      { type="item", name="calcite", amount=4 },
      { type="fluid", name="sulfuric-acid", amount=200 },
    },
    energy_required = 64,
    results = {
      { type="fluid", name="pktff-bauxite-liquor", amount=500 },
    },
    main_product = "pktff-bauxite-liquor",
    auto_recycle = false,
    enabled = false,
    unlock_results = true,
    allow_productivity = true,
    allow_decomposition = true,
    icons = pglobals.icons.three_into_one(
      "__base__/graphics/icons/fluid/sulfuric-acid.png",
      "__space-age__/graphics/icons/calcite.png",
      Asset"graphics/icons/bauxite/1.png",
      Asset"graphics/icons/fluid/red-mud.png"
    )
  },
  {
    type = "recipe",
    name = "pktff-bauxite-liquor-electrolysis",
    category = "electromagnetics",
    subgroup = "pktff-aluminum-processes",
    order = "c[aluminum]-c",
    enabled = false,
    allow_decomposition = false,
    ingredients = {
      { type="fluid", name="pktff-bauxite-liquor", amount=100 },
      -- two electrodes, two items
      { type="item", name="carbon-fiber", amount=2 },
    },
    -- it's atomic number 13. also this makes the math dreadful
    -- i want the number of EM plants and foundries to be quite mismatched,
    -- because it makes the setups look more interesting
    energy_required = 130,
    results = {
      { type="fluid", name="pktff-molten-aluminum", amount=50 },
      { type="item", name="iron-ore", amount_min = 0, amount_max = 20 },
    },
    main_product = "pktff-molten-aluminum",
    allow_productivity = true,
    -- This should probably involve some kind of zapping
    icons = pglobals.icons.two_into_one(
      "__space-age__/graphics/icons/carbon-fiber.png",
      Asset"graphics/icons/fluid/red-mud.png",
      Asset"graphics/icons/fluid/molten-aluminum.png"
    ),
  },
  {
    type = "recipe",
    name = "pktff-casting-aluminum-plate",
    category = "metallurgy",
    subgroup = "pktff-aluminum-processes",
    order = "zd[casting-aluminum-plate]",
    enabled = false,
    ingredients = {
      { type="fluid", name="pktff-molten-aluminum", amount=10 },
    },
    energy_required = 3.2,
    results = {
      { type="item", name="pktff-aluminum-plate", amount=1 },
    },
    icons = pglobals.icons.mini_over(
      Asset"graphics/icons/fluid/molten-aluminum.png",
      Asset"graphics/icons/aluminum-plate.png"
    ),
    -- This way the tooltip shows the native aluminum, not liquid,
    -- which will be relevant for longer
    allow_decomposition = false,
    allow_productivity = true,
  },
}
