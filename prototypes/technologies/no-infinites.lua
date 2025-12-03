local function craft_trigger(item, count)
  return {
    type = "craft-item",
    item = item,
    count = count
  }
end

-- Strike out ALL (most) infinite upgrades!
-- They're boring!
local infinites = {
  -- Damage
  "artillery-shell-range",
  "artillery-shell-speed",
  "artillery-shell-damage",
  "physical-projectile-damage",
  "weapon-shooting-speed",
  "stronger-explosives",
  "railgun-shooting-speed",
  "railgun-damage",
  "refined-flammables",
  "laser-weapons-damage",
  "laser-shooting-speed",
  "electric-weapons-damage",

  -- Productivities (nausea emoji)
  "asteroid-productivity",
  "low-density-structure-productivity",
  "mining-productivity",
  "plastic-bar-productivity",
  "processing-unit-productivity",
  "scrap-recycling-productivity",
  "steel-plate-productivity",
  "research-productivity",
  "rocket-fuel-productivity",
  "rocket-part-productivity",

  -- Other stuff
  "research-speed",
  -- WHY is this in the game
  "health",

  -- TODO check if this messes up combat bots rework
  "follower-robot-count",
  -- I re-add these later
  "braking-force",
  "inserter-capacity-bonus",
  -- Transport belt capacity is just tweaked, not re-added
}
for _,tech in pairs(data.raw["technology"]) do
  local strikeout = false
  for _,infinite in ipairs(infinites) do
    -- true = turn on plain search mode
    -- god i hate Lua
    if tech.name:find(infinite, 0, true) then
      strikeout = true
      break
    end
  end
  if strikeout then
    tech.hidden = true
    tech.enabled = false
    tech.visible_when_disabled = false
  end
end

-- === Tweaks to existing infinites === --

-- Braking force
local function tech_braking(tier, count, bonus)
  local prereq = "railway"
  if tier > 1 then
    prereq = "pktff-braking-force-" .. (tier - 1)
  end
  return {
    type = "technology",
    name = "pktff-braking-force-" .. tier,
    icons = util.technology_icon_constant_braking_force("__base__/graphics/technology/braking-force.png"),
    prerequisites = {prereq},
    upgrade = true,

    -- Cargo wagon, because braking force gets more important
    -- the more wagons you have.
    -- And fluid wagons aren't real
    research_trigger = craft_trigger("cargo-wagon", count),
    effects = {
      {type="train-braking-force-bonus", modifier=bonus},
    }
  }
end
data:extend{
  tech_braking(1, 50, 0.2),
  tech_braking(2, 100, 0.2),
  tech_braking(3, 500, 0.3),
  tech_braking(4, 1000, 0.3),
  -- sums to +1.00, the max in vanilla
}

-- Inserter capacity
local function tech_inserter_cap(tier, count, bulk_stack, main_stack)
  local main_stack_bonus = nil
  if main_stack ~= 0 then
    main_stack_bonus = {type="inserter-stack-size-bonus", modifier=main_stack}
  end
  local prereq = "bulk-inserter"
  if tier > 1 then
    prereq = "pktff-inserter-capacity-bonus-" .. (tier - 1)
  end
  return {
    type = "technology",
    name = "pktff-inserter-capacity-bonus-" .. tier,
    icons = util.technology_icon_constant_stack_size("__base__/graphics/technology/inserter-capacity.png"),
    prerequisites = {prereq},
    upgrade = true,

    research_trigger = craft_trigger("bulk-inserter", count),
    effects = {
      {type="bulk-inserter-capacity-bonus", modifier=bulk_stack},
      main_stack_bonus
    },
  }
end
data:extend{
  -- Equivalent of vanilla ICB1. Bulk=>3, main=1
  tech_inserter_cap(1, 50, 1, 0),
  -- Equivalent of vanilla ICB2. Bulk=>4, main=>2
  tech_inserter_cap(2, 100, 1, 1),
  -- Equivalent of vanilla ICB6. Bulk=>10, main=2
  tech_inserter_cap(3, 1000, 6, 0),
}
-- Stack inserter unlocks equivalent of vanilla ICB7, the highest possible
-- Bulk=>12, main=>3
for _,fx in ipairs{
  {type="bulk-inserter-capacity-bonus", modifier=2},
  {type="inserter-stack-size-bonus", modifier=1},
} do
  table.insert(data.raw["technology"]["stack-inserter"].effects, fx)
end

-- Belt stacc
local belt_stack_1 = data.raw["technology"]["transport-belt-capacity-1"]
belt_stack_1.unit = nil
belt_stack_1.research_trigger = {
  type = "craft-item",
  item = "stack-inserter",
  count = 500,
}
-- Also gives +1 to normal inserter hand size
local belt_stack_2 = data.raw["technology"]["transport-belt-capacity-2"]
belt_stack_2.unit = nil
belt_stack_2.research_trigger = {
  type = "craft-item",
  item = "transport-belt",
  -- hehehehe. this might be unreasonable.
  -- some user data:
  -- - 6M belts, 250 hours, SA no mods
  -- - 50k belts, SA no mods
  -- Who knows.
  count = 10000,
}
