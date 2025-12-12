local pglobals = require "globals"

local resource_autoplace = require("resource-autoplace")
local factoriopedia_util = require("__base__/prototypes/factoriopedia-util")

data:extend{
  pglobals.copy_then(
    data.raw["resource"]["stone"],
    {
      name = "pktff-ice-deposit",
      map_color = { 0.5, 0.7, 1.0 },
      mining_visualization_tint = { 0.75, 0.75, 0.1 },
      icons = pglobals.icons.ore_deposit "__space-age__/graphics/icons/ice.png",
      minable = {
        mining_particle = "stone-particle",
        mining_time = 1,
        result = "ice",
      },
      stages = { sheet = {
        filename = Asset"graphics/entities/ice-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
      } },
      autoplace = {
        local_expressions = {
          spread = 10,
          near_zero = "(spread - abs(elevation)) / spread",
          flavor = [[ multioctave_noise{
            x=x, y=y, persistence=0.75,
            octaves=3,
            seed0=map_seed, seed1="ice",
            input_scale=0.2
          } ]],
          blobs = [[ basis_noise{
            x=x, y=y,
            seed0=map_seed, seed1="ice-blobs",
            input_scale=0.006
          } > 0.4 ]],
        },
        probability_expression = "near_zero * blobs - flavor/3",
        richness_expression = "(near_zero + flavor*30) * 5 * (70+sqrt(distance))",
      },
      factoriopedia_simulation = {
        init = make_resource("pktff-ice-deposit"),
      }
    }
  ),
  pglobals.copy_then(
    data.raw["resource"]["stone"],
    {
      name = "pktff-regolith-deposit",
      -- dark brown?
      map_color = { 0.6, 0.2, 0.1 },
      -- mining_visualization_tint = { 0.75, 0.75, 0.1 },
      icons = pglobals.icons.ore_deposit(Asset"graphics/icons/regolith/1.png"),
      minable = {
        mining_particle = "stone-particle",
        mining_time = 2,
        result = "pktff-regolith",
      },
      stages = { sheet = {
        filename = Asset"graphics/entities/regolith-ore.png",
        priority = "extra-high",
        size = 128,
        frame_count = 8,
        variation_count = 8,
        scale = 0.5,
      } },
      autoplace = {
        local_expressions = {
          flavor = [[ multioctave_noise{
            x=x, y=y, persistence=0.75,
            octaves=3,
            seed0=map_seed, seed1="regolith",
            input_scale=0.02
          } * 0.5 + 0.6 ]],
        },
        probability_expression = [[
          (pktff_viate_above_basins * (pktff_viate_meteor_spot < 0.7))
          * (pktff_viate_meteorness > max(5 - sqrt(distance / 100), 3.8))
        ]],
        richness_expression = "pktff_viate_meteorness * (100 + sqrt(distance))",
      },
      factoriopedia_simulation = {
        init = make_resource("pktff-regolith-deposit"),
      }
    }
  ),
}

local bauxite = pglobals.copy_then(
  data.raw["resource"]["stone"],
  {
    name = "pktff-bauxite-ore",
    map_color = { 0.75, 0.50, 0.45 },
    mining_visualization_tint = { 0.75, 0.50, 0.45 },
    icons = pglobals.icons.ore_deposit(Asset "graphics/icons/bauxite/1.png"),
    minable = {
      mining_particle = "stone-particle",
      mining_time = 1,
      result = "pktff-bauxite-ore",
    },
    stages = { sheet = {
      filename = Asset"graphics/entities/bauxite-ore.png",
      priority = "extra-high",
      size = 128,
      frame_count = 8,
      variation_count = 8,
      scale = 0.5,
    } },
    -- Make it search farther in the hope that it covers the whole
    -- patch of stone or w/e
    resource_patch_search_radius = 8,
    factoriopedia_description = { "factoriopedia-description.pktff-bauxite-ore" },
    -- TODO: probably need to make this stone with inclusions
    factoriopedia_simulation = {
      init = make_resource("pktff-bauxite-ore"),
    },
  }
)
-- right before stone (which is `b`)
bauxite.autoplace.order = "azzzz"
local stone_autoplace = data.raw["resource"]["stone"].autoplace
data:extend{
  bauxite,
  {
    type = "noise-expression",
    name = "pktff-bauxite-inclusions-probability",
    -- basis noise returns from [-1, 1], so this is actually a 2% chance
    -- originally, it was 1/40 (2.5%)
    -- i need to give a number that doesn't make a nice fraction of 1 to
    -- the scale. How the scale works is beyond me but this looks nice
    -- in Hanodest's visualizer
    expression = "(" .. stone_autoplace.probability_expression .. ")"
      .. [[ * (basis_noise{
        x=x, y=y, seed0=map_seed, seed1="bauxite",
        input_scale = 0.76
      } > 0.99) ]],
  },
  {
    type = "noise-expression",
    name = "pktff-bauxite-inclusions-richness",
    expression = "(" .. stone_autoplace.richness_expression .. ") * 10",
  },
}

-- play with coal
local anthracite = pglobals.copy_then(data.raw["resource"]["coal"], {
  name = "pktff-anthracite-coal",
  map_color = { 0, 0, 0 },
  icons = pglobals.icons.ore_deposit "__base__/graphics/icons/coal.png",
  minable = {
    mining_particle = "coal-particle",
    mining_time = 2,
    result = "coal",
    required_fluid = "steam",
    -- 1 coal produces 4MJ * (60 steam/s / 1.8 MW) = 133 steam
    -- However, this is per TEN ore mined. Of course the wiki does
    -- not in any way mention this
    fluid_amount = 200,
  },
  stages = { sheet = {
    filename = Asset"graphics/entities/anthracite-coal.png",
    priority = "extra-high",
    size = 128,
    frame_count = 8,
    variation_count = 8,
    scale = 0.5,
  } },

  factoriopedia_simulation = {
    init = make_resource("pktff-anthracite-coal"),
  }
})
-- override coal
anthracite.autoplace.probability_expression =
  "(" .. anthracite.autoplace.richness_expression ..
  ") > sqrt(distance + 100) * 100 + distance"
anthracite.autoplace.richness_expression =
  "(" .. anthracite.autoplace.richness_expression .. ") * 1.7"
data:extend{anthracite}

-- Make OG coal spawn around anthracite
local coal = data.raw["resource"]["coal"]
coal.map_color = {0.1, 0.1, 0.1}
-- spawn right after
coal.autoplace.order = "ba"

local nauvis_mgs = data.raw["planet"]["nauvis"].map_gen_settings
-- Place anthracite on Nauvis
nauvis_mgs.autoplace_settings.entity.settings["pktff-anthracite-coal"] = {}
-- Place bauxite on nauvis
nauvis_mgs.autoplace_settings.entity.settings["pktff-bauxite-ore"] = {}
-- Instead of using the normal probabilities, use the custom ones
nauvis_mgs.property_expression_names["entity:pktff-bauxite-ore:probability"] = "pktff-bauxite-inclusions-probability"
nauvis_mgs.property_expression_names["entity:pktff-bauxite-ore:richness"] = "pktff-bauxite-inclusions-richness"
nauvis_mgs.property_expression_names["entity:lalalaltest:richness"] = "pktff-bauxite-inclusions-richness"

local vulcanus_mgs = data.raw["planet"]["vulcanus"].map_gen_settings
-- allow anthracite on Vulc
vulcanus_mgs.autoplace_settings.entity.settings["pktff-anthracite-coal"] = {}
-- disallow coal on vulc
vulcanus_mgs.autoplace_settings.entity.settings["coal"] = nil
vulcanus_mgs.property_expression_names["entity:coal:probability"] = nil
vulcanus_mgs.property_expression_names["entity:coal:richness"] = nil
-- set the prob/richness of anthracite to what was previously coal
vulcanus_mgs.property_expression_names["entity:pktff-anthracite-coal:probability"] = "vulcanus_coal_probability"
vulcanus_mgs.property_expression_names["entity:pktff-anthracite-coal:richness"] = "vulcanus_coal_richness"
