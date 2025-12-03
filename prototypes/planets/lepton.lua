local effects = require("__core__.lualib.surface-render-parameter-effects")

local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout

local pglobals = require("globals")

-- Three sectors:
-- - Mixed Carbon/sulfur ore
-- - Steam geysers (that ebb and flow in time with the rotation?)
-- - Not sure what to put here, but I don't want to divide it just into two.

-- What's everything you need to get rockets?
-- - Blurcuits: Plastic, copper, iron, H2SO4
-- - POC: Copper, iron, hvy. oil
-- - LDS: Plastic, copper, iron, Aluminum
-- - Thruster & Oxidizer: lots of stuff
-- So total bill is:
-- - Copper & Iron from lava
-- - Oil products from coal liquefaction
-- - Steam & water from ... steam
-- - Aluminum is the interesting part. Perhaps make a shit recipe to extract
--   traces of bauxite from stone; then you have to use the old bad Al recipe.
-- I should probably only block out Lepton once I have the rest of the mod
-- blocked out, *especially* Vulc II.
-- But I like the idea of having to use the old bad recipes again.

data:extend{
  {
    type = "noise-expression",
    -- Minimum radius
    name = "pktff_lepton_radius",
    expression = 40 -- or whatever
  },
  {
    type = "noise-expression",
    -- Minimum radius
    name = "pktff_lepton_overhang_ok",
    expression = 10 -- or whatever
  },
  {
    type = "noise-expression",
    -- Minimum radius
    name = "pktff_lepton_overhang_bonus",
    expression = 0.9
  },
  {
    type = "noise-expression",
    name = "pktff_lepton_clock",
    expression = "atan2(y, x)",
  },
  pglobals.make_blobby_radius_expr{
    name = "pktff_lepton_has_ground",
    input_scale = "3",
    radius = "pktff_lepton_radius",
    overhang_ok = "pktff_lepton_overhang_ok",
    overhang_bonus = "pktff_lepton_overhang_bonus",
    seed = '"lepton_has_ground"'
  },
  {
    type = "noise-expression",
    name = "pktff_lepton_elevation",
    expression = "0"
  }
}

-- I don't have any idea what this does
local lepton_offset = 80

data:extend{
  {
    type = "item-subgroup",
    name = "pktff-lepton-tiles",
    group = "tiles",
    order = "f-b",
  },
  -- Place empty space *first*, then fill the hole
  pglobals.make_empty_space(
    "pktff-lepton",
    {
      offset = lepton_offset,
      order = "![before-everything]",
      autoplace = {
        probability_expression = "(pktff_lepton_has_ground == 0) * 999999",
      }
    }
  ),
  pglobals.copy_then(
    data.raw["tile"]["volcanic-cracks-hot"],
    {
      name = "pktff-lepton-cracks-hot",
      subgroup = "pktff-lepton-tiles",
      offset = lepton_offset + 1,
      autoplace = {
        probability_expression="1"
      },
    }
  ),
}

PlanetsLib:extend{{
  type = "planet",
  name = "pktff-lepton",
  icon = "__space-age__/graphics/icons/vulcanus.png",
  starmap_icon = "__space-age__/graphics/icons/starmap-planet-vulcanus.png",
  starmap_icon_size = 512,
  orbit = {
    parent={type="planet", name="vulcanus"},
    distance=1, orientation=0.7
  },
  magnitude = 0.3,
  label_orientation = 0.5,
  draw_orbit = false,

  gravity_pull = 10,
  order = "b[vulcanus]-a",
  subgroup = "planets",
  pollutant_type = nil,
  solar_power_in_space = 1000,
  platform_procession_set =
  {
    arrival = {"planet-to-platform-b"},
    departure = {"platform-to-planet-a"}
  },
  planet_procession_set =
  {
    arrival = {"platform-to-planet-b"},
    departure = {"planet-to-platform-a"}
  },
  procession_graphic_catalogue = planet_catalogue_vulcanus,
  asteroid_spawn_influence = 1,
  asteroid_spawn_definitions = {},

  surface_render_parameters = {
    clouds = nil,
    day_night_cycle_color_lookup = data.raw["planet"]["vulcanus"].
      surface_render_parameters.day_night_color_cycle_lookup
  },

  map_gen_settings = {
    property_expression_names = {
      elevation = "pktff_lepton_elevation",
      cliffiness = 0,
      -- it does not look like you can change this?
      cliff_elevation = 0,
      cliff_smoothing = 0.0,
      richness = 3.5,
      aux = 0,
      moisture = 0,
    },
    cliff_settings = nil,
    autoplace_controls = {
    },
    autoplace_settings = {
      tile = { settings = pglobals.set_with({}){
        "pktff-lepton-empty-space",
        "pktff-lepton-cracks-hot",
      } },
      decorative = { settings = {} },
      entity = { settings = {} },
    }
  },
  surface_properties = {
    ["day-night-cycle"] = 0.75 * minute,
    ["solar-power"] = 700,
    pressure = 0,
    gravity = 1,
    ["magnetic-field"] = 0,
  },
}}


