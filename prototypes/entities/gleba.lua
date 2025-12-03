-- Thank you, LordMiguel!
-- https://mods.factorio.com/mod/boompuff-agriculture?from=search

-- I think I can do it a little smarter than them though.
-- The Plant prototype (for farmables) extends TreePrototype,
-- and only adds a few more fields!
-- So just clone the boompuff and turn it into a plampt
local pglobals = require "globals"

local vanilla_boompuff = data.raw["tree"]["boompuff"]
-- Make boompuffs weak to their own explosions
-- Perhaps this is how they propogate in the wild
vanilla_boompuff.resistances = {
  -- They have 50 health by default
  -- I don't want any explosion to completely wipe out a grove, but i do want it to be
  -- fairly deadly. Mine it quick!
  {type="explosion", decrease=-5}
}
vanilla_boompuff.minable.results = {
  -- instead of spoilage.
  -- remember that, even though each tree drops 50 fruit, there's only a 2%
  -- chance to get another seed out.
  -- LordMiguel had a really smart idea here -- you can't count on every
  -- harvest giving you a propagule! but you also can't buffer the seeds.
  {type="item", name="pktff-boompuff-propagule", amount_min=0, amount_max=10},
  {type="item", name="wood", amount=4},
}

local boompuff_plant = pglobals.copy_then(vanilla_boompuff, {
  name = "pktff-boompuff-plant",
  type = "plant",
  -- Same as yumako and jellynut
  growth_ticks = 5 * minute,
  harvest_emissions = { spores=15 },
  -- Primary is the mash on the outside ("plant-mask")
  -- Secondary is the churning inside the tower ("light")
  -- Or something.
  agricultural_tower_tint = {
    -- kind of a puce yellow, from the stems
    primary = {r = 0.671, g = 0.518, b = 0.353, a = 1.000},
    -- violent red, from the harvest
    secondary = {r = 0.416, g = 0.165, b = 0.125, a = 1.000},
  },
  -- TODO: look into why they vibrate violenty
})
-- Stop placing the cute decoratives everywhere.
-- Have to do this imperatively because lua ignores nil keys
boompuff_plant.created_effect = nil
-- The autoplace restriction is binding for some reason?
-- Make them also plantable on yumako soil, idfk,
-- I don't want to add special new yellow soil
boompuff_plant.autoplace.tile_restriction = pglobals.concat{
  data.raw["plant"]["yumako-tree"].autoplace.tile_restriction,
  {"midland-yellow-crust", "midland-yellow-crust-2", "midland-yellow-crust-3", "midland-yellow-crust-4"},
}
-- Only plant "natural" boompuffs
boompuff_plant.autoplace.probability_expression = 0.0

data:extend{boompuff_plant}

-- Show the little spores the boompuffs puff
local boompuff_boom = data.raw["projectile"]["boompuff-seed"]
local seed_shot = {
  filename = Asset"graphics/icons/boompuff-propagule-sheet.png",
  draw_as_glow = true,
  size = 64,
  x = 0, y = 0,
  scale = 0.2,
  priority = "high",
}
boompuff_boom.animation = seed_shot
-- Hit walls
boompuff_boom.hit_collision_mask = { layers={
  player=true, train=true, trigger_target = true,
  object=true,
}}
boompuff_boom.collision_box = {{-0.1, -0.1}, {0.1, 0.1}}
-- Shrink radius, make the seeds fly farther.
-- This makes walls useable
boompuff_boom.action[2].radius = 1
local boompuff_explode_fx = data.raw["explosion"]["boompuff-explosion"].created_effect
boompuff_explode_fx.cluster_count = 7
boompuff_explode_fx.distance = 5

-- Need to have 3 slots now for propagules, wood, spoilage
data.raw["agricultural-tower"]["agricultural-tower"].output_inventory_size = 3

local function invincible()
  local out = {}
  for name,dmg in pairs(data.raw["damage-type"]) do
    table.insert(out, {type=name, percent=100})
  end
  return out
end

-- Man-made horrors beyond YOUR comprehension!
data:extend{
  {
    type = "furnace",
    name = "pktff-mystery-flesh-pit",
    flags = {
      "placeable-neutral", "not-deconstructable", "not-blueprintable",
      "not-repairable", "not-upgradable"
    },
    icon = "__space-age__/graphics/icons/big-stomper.png",
    map_color = {0.20, 0.06, 0.09, 1.0},
    -- Make the collision box much smaller,
    -- because it's annoying to get caught on the invisible corners
    tile_width = 12,
    tile_height = 7,
    collision_box = {{-5.4, -3.1}, {5.4, 3.1}},
    selection_box = {{-6, -3.5}, {6, 3.5}},
    remove_decoratives = "true",
    selectable_priority = 60,
    subgroup = "enemies",
    order = "gleba-z",

    crafting_speed = 1,
    crafting_categories = {"pktff-mystery-flesh-pit"},
    source_inventory_size = 1,
    result_inventory_size = 12,
    circuit_connector = nil,
    circuit_connector_flipped = nil,
    energy_usage = "1MW",
    energy_source = {
      type = "burner",
      fuel_inventory_size = 1,
      burner_usage = "pktff-mfp-scouts",
      fuel_categories = {"pktff-mfp-scouts"},
    },

    integration_patch = {
      filename = Asset"graphics/entities/mystery-flesh-pit/mystery-flesh-pit.png",
      width = 960, height = 675, scale = 0.5,
      surface = "gleba",
    },

    max_health = 999999999,
    healing_per_tick = 999999999,
    hide_resistances = true,
    resistances = invincible(),
  }
}
