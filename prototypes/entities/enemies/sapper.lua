local pglobals = require "globals"
local base_sounds = require("__base__/prototypes/entity/sounds")
local gleba_ai_settings = require ("__space-age__.prototypes.entity.gleba-ai-settings")
local space_age_sounds = require("__space-age__/prototypes/entity/sounds")

local spage_enemies = require("__space-age__/prototypes/entity/enemies")

local function lerp_color(a, b, amount)
  return {
    a[1] + amount * (b[1] - a[1]),
    a[2] + amount * (b[2] - a[2]),
    a[3] + amount * (b[3] - a[3]),
    a[4] + amount * (b[4] - a[4]),
  }
end
-- fades to minimal opacity grey. Low opacity is good for the mask to let the base layer show htough (instead of having a grey mask)
local function fade(tint, amount)
  return lerp_color(tint, {1, 1, 1, 2}, amount)
end

-- fades to opaque grey. Full opacity is required for body.
local function grey_overlay(tint, amount)
  return lerp_color(tint, {127, 127, 127, 255}, amount)
end

local sapper_leg_part_template_layers = {
  middle = {
    { key = "middle", row = 1 },
    { key = "middle_shadow", row = 1, draw_as_shadow = true },
    { key = "middle_tint", row = 1},
    { key = "reflection_middle", row = 1, draw_as_water_reflection = true }
  }
}
local pentapod_upper_leg_dying_trigger_effect_positions = { 0.2, 0.4, 0.6, 0.8, 1.0 }
local pentapod_lower_leg_dying_trigger_effect_positions = { 0.25, 0.5, 0.75, 1.0 }


local function make_sapper(
  prefix, scale, health, speed, power_draw, buf_size, tints, factoriopedia_simulation, sounds
)
  local tint_mask = tints.mask
  local tint_mask_thigh = tints.mask_thigh or tint_mask
  local tint_body = tints.body
  local tint_body_thigh = tints.body_thigh or tint_body
  local tint_projectile = tints.projectile
  local tint_projectile_mask = tints.projectile_mask

  local sapper_scale = 1.4 * scale
  local sapper_head_size = 0.7
  local sapper_leg_thickness = 0.8
  local sapper_leg_ground_position = {0, -6 * scale}
  local sapper_leg_mount_position = {0, -0.25 * scale}
  local sapper_hip_flexibility = 0.6
  local sapper_knee_distance_factor = 0.5
  -- Squat
  local sapper_knee_height = 0.9
  local sapper_ankle_height = 0
  local sapper_leg_orientations = {0.85, 0.65, 0.45, 0.25, 0.05}
  local sapper_speed = speed
  local sapper_resistances = {
    {
      type = "physical",
      decrease = 2,
      percent = 10
    },
    {
      type = "laser",
      percent = 30
    },
    {
      type = "electric",
      percent = 100
    }
  }

  local sapper_graphics_definitions = {
    icon = "__space-age__/graphics/icons/".. prefix .."strafer.png",
    body = {
      -- shhhhhhhhh
      -- this renders under the legs,
      -- `animation` renders over
      base_animation = {
        layers = {
          util.sprite_load("__space-age__/graphics/entity/strafer/torso/torso-main",
          {
            scale=0.5*sapper_head_size*sapper_scale,
            direction_count=64,
            multiply_shift=0.0,
            shift = util.by_pixel(0, -8),
            tint_as_overlay = true,
            -- tint = tint_body,
            surface = "gleba",
            usage = "enemy"
          }),
          util.sprite_load("__space-age__/graphics/entity/strafer/torso/torso-main",
          {
            scale=0.5*sapper_head_size*sapper_scale*0.5,
            direction_count=64,
            multiply_shift=0.0,
            shift = util.by_pixel( 0, -8),
            tint_as_overlay = true,
            tint = tint_mask,
            surface = "gleba",
            usage = "enemy"
          }),
        }
      },
      shadow_base_animation = {
        filename = "__space-age__/graphics/entity/strafer/torso/strafer-body-bottom-shadow.png",
        width = 144,
        height = 96,
        line_length = 1,
        direction_count = 1,
        scale = 0.5 * sapper_scale,
        draw_as_shadow = true,
        shift = util.by_pixel(-1 * sapper_scale, -1 * sapper_scale),
        surface = "gleba",
        usage = "enemy"
      },
      animation = {
        layers = {
          util.sprite_load(Asset"graphics/entities/sapper/body",
          {
            scale=0.5*sapper_head_size*sapper_scale,
            direction_count=64,
            multiply_shift=0.0,
            shift = util.by_pixel( 0, -8),
            tint_as_overlay = true,
            tint = tint_body,
            surface = "gleba",
            usage = "enemy"
          }),
          util.sprite_load(Asset"graphics/entities/sapper/body-mask",
          {
            scale=0.5*sapper_head_size*sapper_scale*0.5,
            direction_count=64,
            multiply_shift=0.0,
            shift = util.by_pixel( 0, -0.0),
            tint_as_overlay = true,
            tint = tint_mask,
            surface = "gleba",
            usage = "enemy"
          }),
          util.sprite_load(Asset"graphics/entities/sapper/lights",
          {
            scale=0.5*sapper_head_size*sapper_scale,
            direction_count=64,
            multiply_shift=0.0,
            shift = util.by_pixel( 0, -8),
            draw_as_glow = true,
            blend_mode = "additive",
            surface = "gleba",
            usage = "enemy",
          }),
        }
      },
      shadow_animation = {
        filename = "__space-age__/graphics/entity/strafer/torso/strafer-body-shadow.png",
        width = 192,
        height = 94,
        line_length = 8,
        direction_count = 64,
        scale = 0.5 * sapper_scale,
        draw_as_shadow = true,
        shift = util.by_pixel(26 * sapper_scale, 0.5 * sapper_scale),
        surface = "gleba",
        usage = "enemy"
      },
      water_reflection = {
        pictures = {
          filename = "__space-age__/graphics/entity/strafer/torso/strafer-body-water-reflection.png",
          width = 448,
          height = 448,
          variation_count = 1,
          scale = 0.5 * sapper_scale,
          shift = util.by_pixel(0 * sapper_scale, 0 * sapper_scale)
        }
      },
      render_layer = "under-elevated",
      base_render_layer = "higher-object-above",
    },
    leg_lower_part = {
      layers = sapper_leg_part_template_layers,

      graphics_properties = {
        middle_offset_from_top = 0.01, -- offset length in tiles (= px / 32)
        middle_offset_from_bottom = 0.01
      },

      middle =
      util.sprite_load("__space-age__/graphics/entity/strafer/legs/leg-shin",
      {
        scale=0.5,
        direction_count=32,
        multiply_shift=0,
        tint_as_overlay = true,
        tint = tint_body,
        surface = "gleba",
        usage = "enemy"
      }),

      middle_shadow =
      util.sprite_load("__space-age__/graphics/entity/strafer/legs/leg-shin-shadow",
      {
        scale=0.5,
        direction_count=32,
        multiply_shift=0,
        surface = "gleba",
        usage = "enemy"
      }),

      middle_tint =
      util.sprite_load("__space-age__/graphics/entity/strafer/legs/leg-shin-mask",
      {
        scale=0.5,
        direction_count=32,
        multiply_shift=0,
        tint=tint_mask,
        surface = "gleba",
        usage = "enemy"
      }),

      reflection_middle = {
        filename = "__space-age__/graphics/entity/strafer/legs/strafer-legs-lower-stretchable-water-reflection.png",
        width = 72,
        height = 384,
        line_length = 1,
        direction_count = 1,
        scale = 0.25,
        shift = util.by_pixel(1 * 0.5, 0)
      }
    },
    leg_upper_part = {
      layers = sapper_leg_part_template_layers,

      graphics_properties = {
        middle_offset_from_top = 0.01, -- offset length in tiles (= px / 32)
        middle_offset_from_bottom = 0.01
      },

      middle =
      util.sprite_load("__space-age__/graphics/entity/strafer/legs/leg-thigh",
      {
        scale=0.5,
        direction_count=32,
        multiply_shift=0,
        tint_as_overlay = true,
        tint = tint_body_thigh,
        surface = "gleba",
        usage = "enemy"
      }),

      middle_shadow =
      util.sprite_load("__space-age__/graphics/entity/strafer/legs/leg-thigh-shadow",
      {
        scale=0.5,
        direction_count=32,
        multiply_shift=0,
        surface = "gleba",
        usage = "enemy"
      }),
      middle_tint =
      util.sprite_load("__space-age__/graphics/entity/strafer/legs/leg-thigh-mask",
      {
        scale=0.5,
        direction_count=32,
        multiply_shift=0,
        tint=tint_mask_thigh,
        surface = "gleba",
        usage = "enemy"
      }),

      reflection_middle = {
        filename = "__space-age__/graphics/entity/strafer/legs/strafer-legs-upper-stretchable-water-reflection.png",
        width = 80,
        height = 256,
        line_length = 1,
        direction_count = 1,
        scale = 0.25,
        shift = util.by_pixel(-4 * 0.5, 0),
        surface = "gleba",
        usage = "enemy"
      }
    },
    leg_joint =
    util.sprite_load("__space-age__/graphics/entity/strafer/legs/leg-knee",
    {
      scale=0.5,
      direction_count=32,
      multiply_shift=0,
      tint_as_overlay = true,
      tint = tint_body,
      surface = "gleba",
      usage = "enemy"
    }),
    leg_joint_tint =
    util.sprite_load("__space-age__/graphics/entity/strafer/legs/leg-knee-mask",
    {
      scale=0.5,
      direction_count=32,
      multiply_shift=0,
      tint_as_overlay = true,
      tint = tint_mask,
      surface = "gleba",
      usage = "enemy"
    }),
    leg_joint_shadow =
    util.sprite_load("__space-age__/graphics/entity/strafer/legs/leg-knee",
    {
      scale=0.5,
      direction_count=32,
      multiply_shift=0,
      draw_as_shadow = true,
      surface = "gleba",
      usage = "enemy"
    })
  }

  data:extend{
    {
      type = "electric-energy-interface",
      name = "pktff-" .. prefix .. "sapper-egg",
      icon = sapper_graphics_definitions.icon,
      hidden = true,
      is_military_target = true,
      flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air", "not-repairable"},
      subgroup = "enemies",
      impact_category = "organic",
      resistances = util.table.deepcopy(sapper_resistances),
      max_health = health / 2,
      collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
      selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
      collision_mask = {
        layers={train=true, is_object=true},
        not_colliding_with_itself=true
      },
      force_condition = "not-friend", --don't hit allies or trees, rocks, etc
      energy_source = {
        type = "electric",
        usage_priority = "primary-input",
        buffer_capacity = buf_size,
        drain = power_draw,
        render_no_network_icon = false,
        render_no_power_icon = false,
      },
      picture = {
        filename = "__core__/graphics/questionmark.png",
        width = 32,
        height = 32,
      }
    },
    make_leg("pktff-" .. prefix .. "sapper-pentapod-leg", sapper_scale, sapper_leg_thickness, sapper_speed, sapper_graphics_definitions, sounds,
    {
      hip_flexibility = sapper_hip_flexibility,
      knee_height = sapper_knee_height, -- tiles, in screen space, above the ground that the knee naturally rests at
      knee_distance_factor = sapper_knee_distance_factor, -- distance from torso, as multiplier of leg length
      ankle_height = 0, -- tiles, in screen space, above the ground, the point at which the leg connects to the foot
      upper_leg_dying_trigger_effects = make_pentapod_leg_dying_trigger_effects(prefix .. "strafer-pentapod-leg-die", pentapod_upper_leg_dying_trigger_effect_positions),
      lower_leg_dying_trigger_effects = make_pentapod_leg_dying_trigger_effects(prefix .. "strafer-pentapod-leg-die", pentapod_lower_leg_dying_trigger_effect_positions),
      resistances = util.table.deepcopy(sapper_resistances),
    }),

    {
      type = "spider-unit",
      name = "pktff-" .. prefix .. "sapper-pentapod",
      icon = sapper_graphics_definitions.icon,
      collision_box = {{-1 * scale, -1 * scale}, {1 * scale, 1 * scale}},
      sticker_box = {{-1.0 * scale, -1.0 * scale}, {1.0 * scale , 1.0 * scale}},
      selection_box = {{-1.5 * scale, -1.5 * scale}, {1.5 * scale, 1.5 * scale}},
      drawing_box_vertical_extension = 3,
      flags = {"placeable-player", "placeable-enemy", "placeable-off-grid", "breaths-air", "not-repairable"},
      max_health = health,
      factoriopedia_simulation = factoriopedia_simulation,
      order = "gleba-b-sapper-"..tostring(scale),
      subgroup = "enemies",
      impact_category = "organic",
      resistances = util.table.deepcopy(sapper_resistances),
      healing_per_tick = health/500/60,
      distraction_cooldown = 30,
      min_pursue_time = 10 * 60,
      --max_pursue_time = 60 * 60,
      max_pursue_distance = 50,
      attack_parameters =
      {
        type = "projectile",
        ammo_category = "biological",
        cooldown = 400,
        cooldown_deviation = 0.15,
        range = 0.5,
        use_shooter_direction = true,
        sound = space_age_sounds.strafer_projectile,
        ammo_type = {
          target_type = "position",
          -- Fire even when the target is far
          clamp_position = true,
          action = {
            type = "direct",
            action_delivery = {
              type = "instant",
              target_effects = {
                {
                  type = "create-entity",
                  entity_name = "pktff-" .. prefix .. "sapper-egg",
                  check_buildability = true,
                  find_non_colliding_position = true
                },
                {
                  type = "invoke-tile-trigger",
                  repeat_count = 1
                },
                {
                  type = "create-sticker",
                  sticker = "strafer-sticker"
                },
                {
                  type = "play-sound",
                  sound = sounds.projectile_impact,
                },
                {
                  type = "play-sound",
                  sound = base_sounds.electric_large_close,
                },
              }
            }
          }
        },
      },
      vision_distance = 40,
      ai_settings = util.merge(
      {
        gleba_ai_settings,
        {
          strafe_settings =
          {
            max_distance = 12,
            ideal_distance = 4,
            ideal_distance_tolerance = 1,
            ideal_distance_variance = 1,
            ideal_distance_importance = 0.5,
            ideal_distance_importance_variance = 0.1,
            face_target = true
          },
          size_in_group = 3,
        }
      }),
      absorptions_to_join_attack = { spores = 15 },
      corpse = prefix .. "strafer-corpse",
      dying_explosion = prefix .. "strafer-pentapod-die",
      dying_sound = sounds.dying_sound,
      damaged_trigger_effect = gleba_hit_effects(),
      is_military_target = true,
      working_sound = sounds.working_sound,
      warcry = sounds.warcry,
      height = 1.1,
      torso_rotation_speed = 0.02,
      graphics_set = sapper_graphics_definitions.body,
      spider_engine =
      {
        -- Skitter across the ground
        walking_group_overlap = 0.8,
        legs = {
          {
            leg = "pktff-" .. prefix .. "sapper-pentapod-leg",
            mount_position = util.rotate_position(sapper_leg_mount_position, sapper_leg_orientations[1]),
            ground_position = util.rotate_position(sapper_leg_ground_position, sapper_leg_orientations[1]),
            walking_group = 1,
            leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
          },
          {
            leg = "pktff-" ..  prefix .. "sapper-pentapod-leg",
            mount_position = util.rotate_position(sapper_leg_mount_position, sapper_leg_orientations[2]),
            ground_position = util.rotate_position(sapper_leg_ground_position, sapper_leg_orientations[2]),
            walking_group = 3,
            leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
          },
          {
            leg = "pktff-" .. prefix .. "sapper-pentapod-leg",
            mount_position = util.rotate_position(sapper_leg_mount_position, sapper_leg_orientations[3]),
            ground_position = util.rotate_position(sapper_leg_ground_position, sapper_leg_orientations[3]),
            walking_group = 5,
            leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
          },
          {
            leg = "pktff-" .. prefix .. "sapper-pentapod-leg",
            mount_position = util.rotate_position(sapper_leg_mount_position, sapper_leg_orientations[4]),
            ground_position = util.rotate_position(sapper_leg_ground_position, sapper_leg_orientations[4]),
            walking_group = 2,
            leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
          },
          {
            leg = "pktff-" .. prefix .. "sapper-pentapod-leg",
            mount_position = util.rotate_position(sapper_leg_mount_position, sapper_leg_orientations[5]),
            ground_position = util.rotate_position(sapper_leg_ground_position, sapper_leg_orientations[5]),
            walking_group = 4,
            leg_hit_the_ground_trigger = get_leg_hit_the_ground_trigger()
          },
        },
      }
    },
    {
      type = "corpse",
      name = "pktff-" .. prefix .. "sapper-corpse",
      icon = sapper_graphics_definitions.icon,
      flags = {"placeable-neutral", "not-on-map"},
      hidden_in_factoriopedia = true,
      subgroup = "corpses",
      final_render_layer = "corpse",
      --animation_render_layer = "entity",
      order = "a-l-a",
      selection_box = {{-3, -3}, {3, 3}},
      collision_box = {{-2, -2}, {2, 2}},
      tile_width = 3,
      tile_height = 3,
      selectable_in_game = false,
      time_before_removed = 60 * 60 * 1, -- 3 minutes
      remove_on_tile_placement = true,
      decay_frame_transition_duration = 50,
      animation = {
        layers = {
          util.sprite_load("__space-age__/graphics/entity/strafer/strafer-corpse",
          {
            frame_count = 1,
            scale = 0.5 * sapper_scale,
            shift = util.by_pixel(0, 0),
            direction_count = 1,
            flags = {"corpse-decay"},
            tint = tint_body,
            tint_as_overlay = true,
            surface = "gleba",
            usage = "corpse-decay"
          }),
          util.sprite_load("__space-age__/graphics/entity/strafer/strafer-corpse-mask",
          {
            frame_count = 1,
            scale = 0.5 * sapper_scale,
            shift = util.by_pixel(0, 0),
            direction_count = 1,
            flags = {"corpse-decay"},
            tint = tint_mask,
            tint_as_overlay = true,
            surface = "gleba",
            usage = "corpse-decay"
          })
        }
      },
    },
  }
end

-- Sappers lean yellowy-er
local small_color = {140, 140, 120, 255}
local med_color = {160, 150, 120, 255}
local large_color = {160, 120, 100, 255}
make_sapper("small-", 0.7, 500, 1.95, "500kW", "1MJ", {
  mask = fade(small_color, 0.2),
  mask_thigh = fade(small_color, 0.4),
  body = small_color,
  projectile_mask = small_color,
  projectile = small_color,
}, nil, space_age_sounds.strafer_pentapod.small)
make_sapper("medium-", 0.9, 600, 1.90, "1MW", "2.5MJ", {
  mask = fade(med_color, 0.2),
  mask_thigh = fade(med_color, 0.4),
  body = med_color,
  projectile_mask = med_color,
  projectile = med_color,
}, nil, space_age_sounds.strafer_pentapod.medium)
make_sapper("big-", 1.1, 800, 1.85, "3MW", "8MJ", {
  mask = fade(large_color, 0.2),
  mask_thigh = fade(large_color, 0.4),
  body = large_color,
  projectile_mask = large_color,
  projectile = large_color,
}, nil, space_age_sounds.strafer_pentapod.big)

local spawner_units = data.raw["unit-spawner"]["gleba-spawner"].result_units
-- evo, prob
table.insert(spawner_units, {"pktff-small-sapper-pentapod",
  {{0.0, 0.2}, {0.1, 0.2}, {0.6, 0.0}}})
table.insert(spawner_units, {"pktff-medium-sapper-pentapod",
  {{0.1, 0.0}, {0.6, 0.35}, {0.9, 0.0}}})
table.insert(spawner_units, {"pktff-big-sapper-pentapod",
  {{0.6, 0.0}, {0.7, 0.2}, {0.95, 0.25}}})

-- While i'm here, push back stompers
for _,unit in ipairs(spawner_units) do
  if unit[1] == "small-stomper-pentapod" then
    unit[2] = {{0.0, 0.0}, {0.2, 0.0}, {0.3, 0.2}, {0.6, 0.0}}
  end
end
