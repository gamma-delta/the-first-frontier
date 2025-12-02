local pglobals = require "globals"

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
  },
}

local function make_sps_transitions(path, count)
  return {
    -- bottom, left, top, right
    side = {
      spritesheet = "__petraspace__/graphics/tiles/" .. path,
      count = count,
      scale = 0.5,
      tile_height = 1,
      x = 0,
      y = 3 * 64,
    },
    -- LD, LU, RU, RD
    outer_corner = {
      spritesheet = "__petraspace__/graphics/tiles/" .. path,
      count = count,
      scale = 0.5,
      tile_height = 1,
      x = 0,
      y = 7 * 64,
    },
  }
end

data:extend{
  -- Add new collision layer for things that can't go on the light scaffolding
  {
    type = "collision-layer",
    name = "pk-space-platform-scaffolding"
  },
  {
    type = "tile",
    name = "space-platform-scaffolding",
    order = "a[artificial]-za",
    subgroup = "artificial-tiles",
    minable = {mining_time = 0.5, result = "space-platform-scaffolding"},
    -- mined_sound = base_sounds.deconstruct_bricks(0.8),
    is_foundation = true,
    allows_being_covered = true,
    max_health = 20,
    -- default is 200
    weight = 10,
    collision_mask = (function()
      local ground = tile_collision_masks.ground()
      ground.layers["pk-space-platform-scaffolding"] = true
      return ground
    end)(),
    -- normal foundation is 15; go over it.
    layer = 16,
    -- layer_group = "ground-artificial" -- should space-platform-foundation be in the ground-artifical group?

    -- transitions = landfill_transitions,
    -- transitions_between_transitions = landfill_transitions_between_transitions,
    trigger_effect = tile_trigger_effects.landfill_trigger_effect(),

    bound_decoratives =
    {
      "space-platform-decorative-1x1",
      "space-platform-decorative-tiny",
    },

    build_animations = data.raw["tile"]["space-platform-foundation"].build_animations,
    build_animations_background = data.raw["tile"]["space-platform-foundation"].build_animations_background,
    built_animation_frame = 32,

    sprite_usage_surface = "space",

    variants = {
      -- TODO idfc
      main = {
        {
          picture = "__petraspace__/graphics/tiles/space-scaffolding.png",
          size = 1,
          scale = 0.5,
          count = 8,
          line_length = 8,
          x = 0,
          y = 0,
        },
        {
          picture = "__petraspace__/graphics/tiles/space-scaffolding.png",
          size = 2,
          scale = 0.5,
          count = 4,
          line_length = 4,
          x = 0,
          y = 64,
        },
      },
      -- TODO finish this
      transition = {
        draw_background_layer_under_tiles = true,
        -- ??
        side_variations_in_group = 8,
        double_side_variations_in_group = 4,

        -- These are completely invisible ????
        overlay_layout = pglobals.deepcopy(data.raw["tile"]["space-platform-foundation"].variants.transition.overlay_layout),
        -- mask_layout = make_sps_transitions("space-scaffolding-mask.png", 8),
        background_layout = make_sps_transitions("space-scaffolding.png", 8),
      }
    },

    walking_sound = base_tile_sounds.walking.concrete,
    build_sound = space_age_tile_sounds.building.space_platform,
    map_color = {80, 61, 59},
    scorch_mark_color = {r = 0.373, g = 0.307, b = 0.243, a = 1.000}
  }
}
