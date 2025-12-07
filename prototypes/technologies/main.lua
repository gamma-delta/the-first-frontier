local pglobals = require "globals"
local util = require "__core__/lualib/util"

local function science(s)
  local mapping = {
    r = "automation-science-pack",
    g = "logistic-science-pack",
    b = "chemical-science-pack",
    m = "military-science-pack",
    o = "pktff-orbital-science-pack",
    p = "production-science-pack",
    y = "utility-science-pack",
    s = "space-science-pack",
    M = "metallurgic-science-pack",
    E = "electromagnetic-science-pack",
    A = "agricultural-science-pack",
    C = "cryogenic-science-pack",
    P = "prometheum-science-pack",
  }

  local unit = {}
  -- this is so dumb
  local count = 1
  s:gsub(".", function(c)
    local as_num = tonumber(c)
    if as_num then
      count = as_num
    end
    local v = mapping[c]
    if v then
      table.insert(unit, {v, count})
      count = 1
    end
  end)
  return unit
end

local function recipe(name)
  return { type="unlock-recipe", recipe=name }
end

-- Make sure that the labs can actually take all of this stuff
for _,lab in pairs(data.raw["lab"]) do
  table.insert(lab.inputs, "pktff-orbital-science-pack")
end

-- Move fluid mining all the way to the beginning of the game
local fluid_mining = data.raw["technology"]["uranium-mining"]
fluid_mining.icon = Asset"graphics/technologies/fluid-mining.png"
fluid_mining.prerequisites = {"electric-mining-drill"}
fluid_mining.unit = {
  count = 30,
  ingredients = science("r"),
  time = 10,
}
data.raw["technology"]["uranium-processing"].prerequisites = {
  "uranium-mining",
  "chemical-science-pack",
}

table.insert(data.raw["technology"]["electronics"].effects,
  recipe("pktff-circuit-substrate-stone"))
table.insert(data.raw["technology"]["electronics"].effects,
  recipe("pktff-circuit-substrate-wood"))
table.insert(data.raw["technology"]["plastics"].effects,
  recipe("pktff-circuit-substrate-plastic"))

table.insert(
  data.raw["technology"]["logistic-science-pack"].prerequisites,
  "steel-processing"
)

data:extend{
  -- Should I do this as a tip and trick?
  {
    type = "technology",
    name = "pktff-bauxite-hint",
    icon = Asset"graphics/icons/bauxite/1.png",
    icon_size = 64,
    prerequisites = { "electric-mining-drill" },
    effects = {},
    research_trigger = {
      type = "mine-entity",
      entity = "pktff-bauxite-ore",
    },
  },
  {
    type = "technology",
    name = "pktff-simple-bauxite-extraction",
    -- TODO
    icon = Asset"graphics/icons/bauxite/1.png",
    icon_size = 64,
    prerequisites = {"sulfur-processing", "pktff-bauxite-hint"},
    unit = {
      count = 150,
      ingredients = science("rgb"),
      time = 30,
    },
    effects = {
      recipe("pktff-simple-bauxite-extraction"),
      recipe("pktff-aluminum-plate"),
    },
  },
}
-- I wonder why lamp isn't a prereq of optics anymore
local laser = data.raw["technology"]["laser"]
table.insert(laser.prerequisites, "lamp")
table.insert(laser.prerequisites, "solar-energy")
-- it doesn't have any effects by default. why include it??
laser.effects = {{type="unlock-recipe", recipe="pktff-precision-optical-component-high-pressure"}}
table.insert(
  data.raw["technology"]["night-vision-equipment"].prerequisites,
  "laser"
)

table.insert(data.raw["technology"]["low-density-structure"].prerequisites, "pktff-simple-bauxite-extraction")

local heating_tower = data.raw["technology"]["heating-tower"]
heating_tower.prerequisites = {"chemical-science-pack"}
heating_tower.unit = {
  count = 300,
  ingredients = science("rgb"),
  time = 30,
}
heating_tower.research_trigger = nil
heating_tower.effects = {
  recipe("heating-tower"),
  recipe("heat-pipe"),
  recipe("heat-exchanger"),
  recipe("steam-turbine"),
}

-- Military stuff
data:extend{
  pglobals.copy_then(data.raw["technology"]["gun-turret"], {
    name = "pktff-shotgun-turret",
    prerequisites = {"military-science-pack"},
    unit = {
      count = 100,
      ingredients = science("rgm"),
      time = 30
    },
    effects = {
      recipe("pktff-shotgun-turret")
    }
  })
}

local slegt_tech = data.raw["technology"]["snouz_long_electric_gun_turret"]
slegt_tech.prerequisites = {"military-3", "laser"}
slegt_tech.unit = {
  -- The military sciences are pretty cheap in the vanilla game,
  -- presumably cause you want to do it fast if you're under biter attack.
  count = 100,
  ingredients = science("rgbm"),
  time = 30,
}
-- Combat shotguns use Al instead of wood now
table.insert(data.raw["technology"]["military-3"].prerequisites,
  "pktff-simple-bauxite-extraction")

-- Nitric acid
data:extend{
  {
    type = "technology",
    name = "pktff-advanced-chemistry",
    icon = Asset"graphics/technologies/electrolysis.png",
    icon_size = 1024,
    prerequisites = { "chemical-science-pack" },
    unit = {
      count = 250,
      ingredients = science("rg2b"),
      time = 60,
    },
    effects = {
      recipe("pktff-water-electrolysis"),
      recipe("pktff-ammonia-synthesis"),
      recipe("pktff-nitric-acid"),
      -- TODO: add dinitrogen tetroxide here?
    }
  }
}
table.insert(data.raw["technology"]["processing-unit"].prerequisites, "pktff-advanced-chemistry")

data:extend{
-- Push into space
-- There are three parts that are hard about going to the moon:
-- - finding the moon (astrodynamic science)
-- - making the propellant
-- - making the rocket (rocket silo)
  {
    type = "technology",
    name = "pktff-orbital-science-pack",
    icon = Asset"graphics/technologies/orbital-science-pack.png",
    icon_size = 256,
    prerequisites = { "low-density-structure", "laser", "processing-unit" },
    unit = {
      count = 500,
      ingredients = science("rgb"),
      time = 60,
    },
    effects = {
      recipe("pktff-orbital-data-card-high-pressure"),
      recipe("pktff-orbital-science-pack"),
    },
  },
  {
    type = "technology",
    name = "pktff-discover-viate",
    icons = PlanetsLib.technology_icon_moon(Asset"graphics/icons/space-location/viate.png", 2048),
    localised_description = {"space-location-description.pktff-viate"},
    prerequisites = {
      "pktff-orbital-science-pack",
    },
    unit = {
      count = 300,
      ingredients = science("rgb2o"),
      time = 60,
    },
    effects = {
      {
        type = "unlock-space-location",
        space_location = "pktff-viate",
        -- dunno what this does
        use_icon_overlay_constant = true,
      },
      recipe("pktff-orbital-data-card-low-pressure"),
      recipe("pktff-precision-optical-component-low-pressure"),
    }
  },
}

local tech_vanilla_rocket = data.raw["technology"]["rocket-silo"]
tech_vanilla_rocket.prerequisites = {
  "processing-unit", "concrete", "electric-engine"
}
tech_vanilla_rocket.unit = {
  count = 500,
  time = 60,
  ingredients = science("rbgo"),
}
tech_vanilla_rocket.effects = {
  recipe("rocket-silo"),
  recipe("cargo-landing-pad"),
  recipe("pktff-space-platform-scaffolding"),
  recipe("pktff-space-platform-starter-pack-scaffolding"),
  recipe("pktff-empty-platform-tank"),
  recipe("pktff-platform-fuel-tank"),
  recipe("pktff-platform-oxidizer-tank"),
  recipe("thruster"),
  recipe("pktff-thruster-fuel-from-pktff-hydrogen"),
  recipe("pktff-thruster-oxidizer-from-pktff-oxygen"),
  recipe("pktff-thruster-fuel-from-rocket-fuel"),
  recipe("pktff-thruster-fuel-from-ammonia"),
  recipe("pktff-thruster-oxidizer-from-pktff-nitric-acid"),
}

-- Welcome to Viate
data:extend{
  {
    type = "technology",
    name = "pktff-discover-regolith",
    icon = Asset"graphics/technologies/discover-regolith.png",
    icon_size = 256,
    prerequisites = { "pktff-discover-viate" },
    research_trigger = {
      type = "mine-entity",
      entity = "pktff-regolith-deposit",
    },
    effects = { 
      recipe("pktff-washing-regolith"),
      recipe("pktff-dissolving-regolith"),
      recipe("pktff-stone-bricks-from-regolith"),
    },
  }
}
-- Play with tech costs.
-- To give some fun progress feeling on Viate, make it a trigger tech.
-- I'd rather have it be "melt or mine N ice", but these are both not
-- possible in the trigger system due to WOKE
local tech_cse = data.raw["technology"]["chcs-concentrated-solar-energy"]
tech_cse.prerequisites = {"pktff-discover-viate"}
tech_cse.unit = nil
tech_cse.research_trigger = {
  type = "mine-entity",
  entity = "pktff-ice-deposit",
}
tech_cse.effects = {
  recipe("chcs-solar-power-tower"),
  recipe("chcs-heliostat-mirror"),
  recipe("ice-melting"),
}

local tech_vanilla_spience = data.raw["technology"]["space-science-pack"]
tech_vanilla_spience.prerequisites = {"pktff-discover-viate", "rocket-silo"}
tech_vanilla_spience.research_trigger = nil
tech_vanilla_spience.unit = {
  count = 1000,
  time = 60,
  ingredients = science("rgbo"),
}
tech_vanilla_spience.effects = { recipe("space-science-pack") }
-- SPACE AGE! here's your mini reward:
data:extend{
  {
    type = "technology",
    name = "pktff-dust-spraydown",
    -- TODO
    icon = "__base__/graphics/technology/fluid-handling.png",
    icon_size = 256,
    prerequisites = { "space-science-pack" },
    unit = { count = 50, time = 10, ingredients = science("s") },
    effects = {
      recipe("pktff-dust-sprayer"),
      recipe("pktff-dust-spraydown-water"),
    },
  },
}
-- this is what you get as a reward for figuring out space science!
local tech_vanilla_splatform = data.raw["technology"]["space-platform"]
tech_vanilla_splatform.prerequisites = {"space-science-pack"}
tech_vanilla_splatform.unit = {
  count = 500,
  time = 60,
  ingredients = science("rgbos")
}

tech_vanilla_splatform.effects = {
  recipe("space-platform-foundation"),
  recipe("cargo-bay"),
  recipe("crusher"),
  recipe("asteroid-collector"),
}
tech_vanilla_splatform.research_trigger = nil

for _,planet_tech in ipairs{"vulcanus", "fulgora", "gleba"} do
  local tech = data.raw["technology"]["planet-discovery-" .. planet_tech]
  tech.prerequisites[1] = "space-platform"
  table.insert(tech.unit.ingredients, {"pktff-orbital-science-pack", 1})
end
local vanilla_thruster_tech = data.raw["technology"]["space-platform-thruster"]
vanilla_thruster_tech.enabled = false
vanilla_thruster_tech.visible_when_disabled = false

-- TIER 1 --

-- Nauvian research
data:extend{
  {
    type = "technology",
    name = "pktff-basic-uranium-processing",
    icon = Asset"graphics/technologies/basic-uranium-processing.png",
    icon_size = 256,
    -- "uranium mining" == fracking
    -- There's no real reason for it to require splatform
    -- other than symmetry
    prerequisites = {"space-platform", "uranium-mining"},
    effects = {recipe("pktff-depleted-uranium")},
    unit = {
      count = 1000,
      time = 60,
      ingredients = science("rgbs"),
    }
  },
}
local vanilla_u = data.raw["technology"]["uranium-processing"]
vanilla_u.prerequisites = {"pktff-basic-uranium-processing"}
vanilla_u.unit = nil
vanilla_u.research_trigger = {
  type = "craft-item",
  item = "uranium-238",
  count = 5,
}
local vanilla_upower = data.raw["technology"]["nuclear-power"]
vanilla_upower.prerequisites = {"uranium-processing", "heating-tower"}
vanilla_upower.effects = {recipe("nuclear-reactor"), recipe("uranium-fuel-cell")}

data:extend{
  {
    type = "technology",
    name = "pktff-nuclear-waste-processing",
    icon = Asset"graphics/technologies/nuclear-waste-processing.png",
    icon_size = 256,
    prerequisites = {"uranium-processing"},
    effects = {
      recipe("pktff-nuclear-waste-reprocessing"),
      recipe("pktff-barreled-nuclear-waste"),
      recipe("pktff-nuclear-waste-dumping"),
    },
    research_trigger = {
      type = "craft-item",
      item = "pktff-nuclear-waste",
      -- enough for it to get annoying
      count = 100,
    }
  },
  {
    type = "technology",
    name = "pktff-plutonium-processing",
    icon = Asset"graphics/technologies/plutonium-processing.png",
    icon_size = 256,
    prerequisites = {"nuclear-power"},
    effects = {
      recipe("pktff-mox-fuel-cell"),
      recipe("pktff-breeder-fuel-cell"),
      recipe("pktff-breeder-fuel-cell-reprocessing"),
    },
    research_trigger = {
      type = "craft-item",
      item = "pktff-plutonium",
      count = 1,
    },
  },
}
local purple_sci = data.raw["technology"]["production-science-pack"]
table.insert(purple_sci.prerequisites, "pktff-nuclear-waste-processing")
table.insert(purple_sci.unit.ingredients, {"space-science-pack", 1})
local yellow_sci = data.raw["technology"]["utility-science-pack"]
table.insert(yellow_sci.prerequisites, "pktff-plutonium-processing")
table.insert(yellow_sci.prerequisites, "exoskeleton-equipment")
table.insert(yellow_sci.unit.ingredients, {"space-science-pack", 1})

-- Vulcanus I
pglobals.tech.add_unlock("planet-discovery-vulcanus", "pktff-geothermal-heat-exchanger")
pglobals.tech.remove_unlock("foundry", "casting-low-density-structure")
pglobals.tech.add_unlock("foundry", "pktff-lime-calcination")
pglobals.tech.add_unlock("tungsten-steel", "pktff-tungsten-steel-strongbox")
-- Intermediate: tungsten heat pipes
data:extend{
  {
    type = "technology",
    name = "pktff-tungsten-heat-pipe",
    -- TODO
    icon = Asset"graphics/technologies/geothermal-heat-exchanger.png",
    icon_size = 256,
    prerequisites = {"metallurgic-science-pack"},
    effects = {recipe("pktff-tungsten-heat-pipe")},
    unit = {
      count = 100,
      ingredients = science("M"),
      time = 30,
    }
  }
}

-- Fulgora I
-- Unlock recyclers by mining scrap, so you can keep the vaults for electricity
local recyc = data.raw["technology"]["recycling"]
recyc.research_trigger = {
  type = "mine-entity",
  entity = "scrap",
}
table.insert(recyc.effects, recipe("pktff-archaeological-scrap-recycling"))
table.insert(recyc.effects, recipe("pktff-fulgoran-sludge-refining"))

local em_plant = data.raw["technology"]["electromagnetic-plant"]
em_plant.research_trigger = {
  type = "craft-item",
  item = "superconductor",
  count = 5,
}
em_plant.effects = {
  recipe("electromagnetic-plant"),
  recipe("supercapacitor"),
  recipe("electrolyte"),
}

-- Intermediate tech: Lightning rods
pglobals.tech.remove_unlock("planet-discovery-fulgora", "lightning-rod")
data:extend{
  {
    type = "technology",
    name = "pktff-lightning-rod",
    icon = Asset"graphics/technologies/lightning-rod.png",
    icon_size = 256,
    prerequisites = {"electromagnetic-science-pack"},
    effects = {recipe("lightning-rod")},
    unit = {
      count = 100,
      ingredients = science("E"),
      time = 30
    }
  },
  -- Need to figure out how I can let players make supercons.
}

-- Gleba I
-- Strike out coal synth and good sulfur
pglobals.tech.remove_unlock("rocket-turret", "coal-synthesis")

table.insert(data.raw["technology"]["bacteria-cultivation"].effects, 
  recipe("pktff-light-oil-reforming"))
table.insert(data.raw["technology"]["bacteria-cultivation"].effects, 
  recipe("pktff-heavy-oil-reforming"))
-- With oil reformation, all the special bio-recipes are no longer
-- necessary. (Plastic, rocket fuel, sulfur, and jelly.)
data.raw["technology"]["bioflux-processing"].hidden = true
pglobals.tech.remove_prereq("agricultural-science-pack", "bioflux-processing")

data:extend{
  {
    type = "technology",
    name = "pktff-boompuff",
    icon = Asset"graphics/technologies/boompuff-agriculture.png",
    icon_size = 256,
    effects = {
      { type="unlock-recipe", recipe="pktff-boompuff-processing" },
    },
    prerequisites = {"agriculture"},
    research_trigger = {
      type = "mine-entity",
      entity = "boompuff",
    }
  },
  {
    type = "technology",
    name = "pktff-fertilizer",
    -- TODO
    icon = Asset"graphics/technologies/boompuff-agriculture.png",
    icon_size = 256,
    effects = {
      { type="unlock-recipe", recipe="pktff-fertilizer" },
      { type="unlock-recipe", recipe="pktff-anfo-explosives" },
    },
    prerequisites = {"agricultural-science-pack"},
    unit = {
      count = 1000,
      ingredients = science("rgbyA"),
      time = 60,
    }
  },
  {
    type = "technology",
    name = "pktff-presto-fuel",
    hidden = true,
    -- TODO
    icon = Asset"graphics/technologies/boompuff-agriculture.png",
    icon_size = 256,
    effects = {
      { type="unlock-recipe", recipe="pktff-presto-fuel" },
    },
    prerequisites = {"agricultural-science-pack"},
    unit = {
      count = 4000,
      ingredients = science("rgbspyA"),
      time = 60,
    }
  },
}

-- Each pair of inner planets has its own cool technology.
-- Fulgora+Vulc already is ... deep oil ocean rails? seems lame.
-- may play with that.
-- Fulgora+Gleba is Logi system (complex robotics and swarming behaviors)
-- Gleba+Vulc is Turbelts
local logibots = data.raw["technology"]["logistic-system"]
logibots.prerequisites = {"electromagnetic-science-pack", "agricultural-science-pack"}
logibots.unit = {
  count = 1000,
  ingredients = science("rgbsyEA"),
  time = 60
}
-- Recipe is in post-t1
local turbelts = data.raw["technology"]["turbo-transport-belt"]
turbelts.prerequisites = {"metallurgic-science-pack", "carbon-fiber"}
turbelts.unit = {
  count = 1000,
  ingredients = science("rgbspMA"),
  time = 60,
}

data:extend{
  {
    type = "technology",
    name = "pktff-advanced-bauxite-extraction",
    icon = Asset"graphics/icons/fluid/molten-aluminum.png",
    icon_size = 64,
    prerequisites = {
      "pktff-simple-bauxite-extraction",
      "metallurgic-science-pack",
      "electromagnetic-science-pack",
      "carbon-fiber",
    },
    unit = {
      count = 4000,
      ingredients = science("rgbpMEA"),
      time = 60,
    },
    effects = {
      recipe("pktff-bauxite-liquor"),
      recipe("pktff-bauxite-liquor-electrolysis"),
      recipe("pktff-casting-aluminum-plate"),
      recipe("casting-low-density-structure"),
    },
  }
}

-- TEMP
data:extend{
  {
    type = "technology",
    name = "pktff-superalloys",
    hidden = true,
    -- TODO
    icon = "__space-age__/graphics/technology/tungsten-steel.png",
    unit = {
      count = 4000,
      ingredients = science("rgbp2MC"),
      time = 60,
    },
    effects = {
      recipe("pktff-magpie-alloy"),
    },
  }
}

-- These are automatically researched at runtime, for QAI
for _,tech_name in ipairs{
  "bob-near-inserters",
  "bob-long-inserters-1",
  "bob-long-inserters-2",
  "bob-more-inserters-1",
  "bob-more-inserters-2",
} do
  local tech = data.raw["technology"][tech_name]
  if tech then
    tech.hidden = true
  end
end

