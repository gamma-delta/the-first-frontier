-- https://mods.factorio.com/mod/distant-misfires

local pglobals = require "globals"

local function ensure_array(tbl)
  if tbl == "nil" then
    return {}
  elseif type(tbl) ~= "table" or tbl[1] == nil then
    return {tbl}
  else
    return tbl
  end
end

local function projectileify(ammo_name, color, range, inaccuracy, pierce)
  local ammo_item = data.raw["ammo"][ammo_name]

  -- Muzzle flashes
  local source_effects = {}
  -- Hit explosion, damage, noise
  local target_effects = {}

  for _,action in ipairs(ensure_array(ammo_item.ammo_type.action)) do
    if action.type == "direct" then
      for _,ad in ipairs(ensure_array(action.action_delivery)) do
        if ad.type == "instant" then
          for _,sfx in ipairs(ensure_array(ad.source_effects)) do
            -- distant-misfires for some reason insists it needs an
            -- offset of {0, 1} here.
            -- doing this just makes the muzzle flash happen a tile
            -- too low. It's beyond me.
            table.insert(source_effects, sfx)
          end
          for _,tfx in ipairs(ensure_array(ad.target_effects)) do
            table.insert(target_effects, tfx)
          end
        end
      end
    end
  end
  
  local new_projectile_name = ammo_name .. "-projectile"
  data.extend{{
    type = "projectile",
    name = new_projectile_name,
    flags = {"not-on-map"},
    hidden = true,
    collision_box = {{-0.5, -0.3}, {0.5, 0.3}},
    acceleration = 0,
    direction_only = true,
    piercing_damage = pierce,
    action = {
      type = "direct",
      action_delivery = {
        type = "instant",
        target_effects = target_effects,
      }
    },
    animation = {
      filename = "__base__/graphics/entity/bullet/bullet.png",
      frame_count = 1,
      width = 3,
      height = 50,
      priority = "high",
      blend_mode = "additive",
      -- shift = {0, 1},
      tint = color,
    },
    hit_at_collision_position = true,
    -- this way, trees and rocks get hit
    force_condition = "not-same",
    hit_collision_mask = {
      layers = {object = true, player = true, trigger_target = true, train = true},
      not_colliding_with_itself = true,
    }
  }}

  ammo_item.ammo_type = {
    target_type = "direction",
    -- Don't shoot if it's out of the bullet's range
    clamp_position = true,
    action = {
      {
        type = "direct",
        action_delivery = {
          type = "projectile",
          projectile = new_projectile_name,
          starting_speed = 1,
          direction_deviation = 0.02 * inaccuracy,
          range_deviation = 0.02 * inaccuracy,
          max_range = range,
          source_effects = source_effects,
        }
      },
    }
  }
end

-- If we don't give some projectiles a silly long range,
-- the SLEGT wastes shots shooting out of bounds.
projectileify("firearm-magazine", {1, 1, 1}, 30, 1, 0)
projectileify("piercing-rounds-magazine", {1, 0.5, 0.5}, 18, 1.5, 40)
projectileify("uranium-rounds-magazine", {0.5, 1, 0.5}, 12, 1)

-- Make shotgun pellets go over walls
local shotgun_proj = data.raw["projectile"]["shotgun-pellet"]
shotgun_proj.force_condition = "not-same"
shotgun_proj.hit_collision_mask = {
  layers = {object = true, player = true, trigger_target = true, train = true},
  not_colliding_with_itself = true,
}

data.raw["ammo-turret"]["gun-turret"].attack_parameters.damage_modifier = 1.5

-- Fiddle with SLEGT
local slegt_item = data.raw["item"]["snouz_long_electric_gun_turret"]
slegt_item.default_import_location = "nauvis"
-- Basic turrets do NOT lead their shots, in the vanilla code
-- Let's make Snouz's fancy turrets do so:
local slegt_turret = data.raw["ammo-turret"]["snouz_long_electric_gun_turret"]
-- The doc comment for this is wrong, this is important for non-leading shots too
slegt_turret.attack_parameters.lead_target_for_projectile_speed = 1
-- Nerf SLEGT. In the original impl it's unlocked after Fulgora.
-- Base cooldown=6
slegt_turret.attack_parameters.cooldown = 5
slegt_turret.attack_parameters.damage_modifier = 1.2 -- 0
-- Base has 18. Lasers have 20. Flamethrowers have 30.
slegt_turret.attack_parameters.range = 24
-- Snouz fixed the rotation issue for me :] thx snouz
-- Recipe and tech are in their respective files

-- Shotgun turrets
local function shotgun_top_gfx(cfg)
  local flags
  if cfg.mask then
    flags = {"mask"}
  else
    flags = {}
  end
  -- Beats me
  local size = cfg.mask and 128 or 192
  local scale = cfg.mask and 0.75 or 0.5
  return {
    filename = "__petraspace__/graphics/entities/shotgun-turret/" .. cfg.file,
    width = size, height = size,
    scale = scale,
    direction_count = 64,
    -- It spins around, but each direction only has one frame
    frame_count = 1,
    line_length = 8,
    axially_symmetrical = false,
    run_mode = "forward",
    shift = {0.25, -0.3},
    flags = flags,
    draw_as_shadow = cfg.shadow,
    apply_runtime_tint = cfg.mask,
  }
end
local function shotgun_base_gfx(cfg)
  local flags
  if cfg.mask then
    flags = {"mask", "low-object"}
  else
    flags = {}
  end
  return {
    filename = "__petraspace__/graphics/entities/shotgun-turret/" .. cfg.file,
    width = 128, height = 128,
    scale = 0.5,

    frame_count = 1,
    flags = flags,
    apply_runtime_tint = cfg.mask,
  }
end

local top_ani = {
  layers = {
    shotgun_top_gfx{file="top.png"},
    shotgun_top_gfx{file="top-shadow.png", shadow=true},
    shotgun_top_gfx{file="top-mask.png", mask=true},
  }
}
local base_ani = {
  layers = {
    shotgun_base_gfx{file="base.png"},
    shotgun_base_gfx{file="base-mask.png", mask=true},
  }
}
local turret_circuit = circuit_connector_definitions["gun-turret"][1]
data:extend{
  pglobals.copy_then(
    data.raw["ammo-turret"]["gun-turret"],
    {
      name = "shotgun-turret",
      icon = "__petraspace__/graphics/icons/shotgun-turret.png",
      icon_size = 64,
      flags = {"placeable-player", "player-creation"},
      minable = {mining_time=0.5, result="shotgun-turret"},
      max_health = 600,
      collision_box = {{-0.7, -0.71}, {0.7, 0.71}},
      selection_box = {{-1, -1}, {1, 1}},
      turret_base_has_direction = true,

      circuit_connector = {turret_circuit, turret_circuit, turret_circuit, turret_circuit},
      circuit_wire_max_distance = default_circuit_wire_max_distance,

      -- Does not have a "get ready" animation
      folded_animation = top_ani,
      preparing_animation = top_ani,
      prepared_animation = top_ani,
      attacking_animation = top_ani,
      folding_animation = top_ani,
      graphics_set = {
        base_visualization = {
          animation = base_ani
        }
      },

    -- Based on the combat shotgun
    -- (How do you have a non-combat shotgun? What else are shotguns for?)
      attack_parameters = pglobals.copy_then(
        data.raw["gun"]["combat-shotgun"].attack_parameters,
        {
          -- default 30
          cooldown = 30,
          -- default 15. this makes them feel different than the gun turrets.
          range = 15,
          min_range = 4,
          prepare_range = 18,
          shoot_in_prepare_state = false,
          -- If they don't lead shots they can't hit strafers
          lead_target_for_projectile_speed = 1
          use_shooter_direction = true,
          turn_range = 1 / 3,
          damage_modifier = 2,
    
          -- Based on the gfx
          projectile_creation_distance = 1.5,
          projectile_center = {0, 0.2},
          -- looks like all guns use the same base particles
          shell_particle = {
            name = "shell-particle",
            direction_deviation = 0.1,
            speed = 0.1,
            speed_deviation = 0.03,
            center = {0, 0.2},
            creation_distance = -1.925,
            starting_frame_speed = 0.2,
            starting_frame_speed_deviation = 0.1
          },
        }
      )
    }
  )
  -- The item is in items.lua
}
