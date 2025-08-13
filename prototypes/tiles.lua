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
          picture = "__petraspace__/graphics/tiles/fulgora-scaffolding.png",
          size = 1,
          scale = 0.5,
          count = 12,
          line_length = 6,
          x = 64,
          y = 64,
        },
        {
          picture = "__petraspace__/graphics/tiles/fulgora-scaffolding.png",
          size = 2,
          scale = 0.5,
          count = 6,
          line_length = 3,
          x = 64,
          y = 64 * 3,
        },
      },
      -- TODO figure out transition
      transition = {
        overlay_layout = {
          -- inner_corner
          side = {
            spritesheet = "__petraspace__/graphics/tiles/fulgora-scaffolding.png",
            count = 32,
            scale = 0.5,
            tile_height = 1,
            x = 8 * 64,
            y = 0,
            count = 6,
            line_length = 6,
          },
          outer_corner = {
            spritesheet = "__petraspace__/graphics/tiles/fulgora-scaffolding.png",
            count = 6,
            scale = 0.5,
            tile_height = 1,
            x = 8 * 64,
            y = 4 * 64,
            count = 1,
            line_length = 1,
          },
          -- double_side
          -- u_transition
          -- o_transition
        },
      }

      -- material_background =
      -- {
      --   picture = "__space-age__/graphics/terrain/space-platform/space-platform.png",
      --   count = 8,
      --   scale = 0.5
      -- }
    },

    walking_sound = base_tile_sounds.walking.concrete,
    build_sound = space_age_tile_sounds.building.space_platform,
    map_color = {80, 61, 59},
    scorch_mark_color = {r = 0.373, g = 0.307, b = 0.243, a = 1.000}
  }
}
