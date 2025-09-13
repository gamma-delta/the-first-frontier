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

-- SLEGT have a range of 36!
-- If we don't give some projectiles a silly long range,
-- it wastes shots.
projectileify("firearm-magazine", {1, 1, 1}, 30, 1, 0)
projectileify("piercing-rounds-magazine", {1, 0.5, 0.5}, 18, 1.5, 40)
projectileify("uranium-rounds-magazine", {0.5, 1, 0.5}, 12, 1)

-- Fiddle with SLEGT
local slegt_item = data.raw["item"]["snouz_long_electric_gun_turret"]
slegt_item.default_import_location = "nauvis"
-- Basic turrets do NOT lead their shots, in the vanilla code
-- Let's make Snouz's fancy turrets do so:
local slegt_turret = data.raw["ammo-turret"]["snouz_long_electric_gun_turret"]
-- The doc comment for this is wrong, this is important for non-leading shots too
slegt_turret.attack_parameters.lead_target_for_projectile_speed = 1
slegt_turret.attack_parameters.cooldown = 8
-- 36 is a LOT
slegt_turret.range = 24
slegt_turret.turret_base_has_rotation = true
-- Unsquare hitbox keeps it from Helpfully rotating itself, i think?
slegt_turret.collision_box = {{-0.71, -0.7}, {0.71, 0.7}}
-- Recipe and tech are in their respective files
