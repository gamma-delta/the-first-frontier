local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_trigger_effects = require("__base__/prototypes/tile/tile-trigger-effects")
local base_tile_sounds = require("__base__/prototypes/tile/tile-sounds")
local space_age_tile_sounds = require("__space-age__/prototypes/tile/tile-sounds")

data:extend{
  {
    type = "tile",
    name = "fulgoran-scaffolding",
    order = "a[artificial]-za",
    subgroup = "artificial-tiles",
    -- minable = {mining_time = 0.5, result = "space-platform-foundation"},
    -- mined_sound = base_sounds.deconstruct_bricks(0.8),
    -- i have no idea what this does
    is_foundation = true,
    allows_being_covered = false,
    max_health = 50,
    weight = 200,
    collision_mask = tile_collision_masks.ground(),
    layer = 15,
    -- layer_group = "ground-artificial" -- should space-platform-foundation be in the ground-artifical group?

    -- transitions = landfill_transitions,
    -- transitions_between_transitions = landfill_transitions_between_transitions,
    trigger_effect = tile_trigger_effects.landfill_trigger_effect(),

    -- bound_decoratives =
    -- {
    --   "space-platform-decorative-pipes-2x1",
    --   "space-platform-decorative-pipes-1x2",
    --   "space-platform-decorative-pipes-1x1",
    --   "space-platform-decorative-4x4",
    --   "space-platform-decorative-2x2",
    --   "space-platform-decorative-1x1",
    --   "space-platform-decorative-tiny",
    -- },

    variants = {
      -- TODO idfc
      main = {
        {
          picture = "__petraspace__/graphics/tiles/fulgoran-scaffolding/main.png",
          size = 1,
          scale = 0.5,
          count = 16,
          line_length = 8,
          x = 0,
          y = 0,
        },
        {
          picture = "__petraspace__/graphics/tiles/fulgoran-scaffolding/main.png",
          size = 2,
          scale = 0.5,
          count = 8,
          line_length = 4,
          x = 0,
          y = 64 * 2,
        },
      },
      -- TODO figure out transition
      transition = data.raw["tile"]["foundation"].variants.transition,
    },

    walking_sound = base_tile_sounds.walking.concrete,
    build_sound = space_age_tile_sounds.building.space_platform,
    map_color = {80, 61, 59},
    scorch_mark_color = {r = 0.373, g = 0.307, b = 0.243, a = 1.000}
  }
}
