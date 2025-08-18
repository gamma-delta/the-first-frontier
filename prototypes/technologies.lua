local pglobals = require "globals"
local util = require "__core__/lualib/util"

local function science(s)
  local mapping = {
    r = "automation-science-pack",
    g = "logistic-science-pack",
    b = "chemical-science-pack",
    m = "military-science-pack",
    o = "orbital-science-pack",
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
  table.insert(lab.inputs, "orbital-science-pack")
end

-- Move fluid mining all the way to the beginning of the game
local fluid_mining = data.raw["technology"]["uranium-mining"]
fluid_mining.icon = "__petraspace__/graphics/technologies/fluid-mining.png"
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

table.insert(data.raw["technology"]["electronics"].effects, recipe("circuit-substrate-stone"))
table.insert(data.raw["technology"]["electronics"].effects, recipe("circuit-substrate-wood"))
table.insert(data.raw["technology"]["plastics"].effects, recipe("circuit-substrate-plastic"))

table.insert(
  data.raw["technology"]["logistic-science-pack"].prerequisites,
  "steel-processing"
)

data:extend{
  -- Should I do this as a tip and trick?
  {
    type = "technology",
    name = "bauxite-hint",
    icon = "__petraspace__/graphics/icons/bauxite/1.png",
    icon_size = 64,
    prerequisites = { "electric-mining-drill" },
    effects = {},
    research_trigger = {
      type = "mine-entity",
      entity = "bauxite-ore",
    },
  },
  {
    type = "technology",
    name = "simple-bauxite-extraction",
    -- TODO
    icon = "__petraspace__/graphics/icons/bauxite/1.png",
    icon_size = 64,
    prerequisites = {"sulfur-processing", "bauxite-hint"},
    unit = {
      count = 150,
      ingredients = science("rgb"),
      time = 30,
    },
    effects = {
      recipe("simple-bauxite-extraction"),
      recipe("native-aluminum-to-plate"),
    },
  },
}
-- I wonder why lamp isn't a prereq of optics anymore
local laser = data.raw["technology"]["laser"]
table.insert(laser.prerequisites, "lamp")
table.insert(laser.prerequisites, "solar-energy")
-- it doesn't have any effects by default. why include it??
laser.effects = {{type="unlock-recipe", recipe="precision-optical-component-high-pressure"}}

-- So why the hell can you research laser upgrades BEFORE
-- laser turrets?
table.insert(
  data.raw["technology"]["laser-shooting-speed-1"].prerequisites,
  "laser-turret"
)
table.insert(
  data.raw["technology"]["laser-weapons-damage-1"].prerequisites,
  "laser-turret"
)
table.insert(
  data.raw["technology"]["night-vision-equipment"].prerequisites,
  "laser-turret"
)

table.insert(data.raw["technology"]["low-density-structure"].prerequisites, "simple-bauxite-extraction")

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

data:extend{
-- Push into space --
  {
    type = "technology",
    name = "orbital-science-pack",
    icon = "__petraspace__/graphics/technologies/orbital-science-pack.png",
    icon_size = 256,
    prerequisites = { "low-density-structure", "laser", "processing-unit" },
    unit = {
      count = 500,
      ingredients = science("rgb"),
      time = 60,
    },
    effects = { 
      recipe("data-card-programmer"),
      recipe("orbital-data-card-high-pressure"),
      recipe("orbital-science-pack"),
    },
  },
  {
    type = "technology",
    name = "rocket-propellants",
    icon = "__petraspace__/graphics/technologies/electrolysis.png",
    icon_size = 1024,
    prerequisites = { "orbital-science-pack" },
    unit = {
      count = 250,
      ingredients = science("2r2g2bo"),
      time = 60,
    },
    effects = {
      recipe("water-electrolysis"),
      recipe("thruster-fuel-from-hydrogen"),
      recipe("thruster-oxidizer-from-oxygen"),
      recipe("thruster-fuel-from-rocket-fuel"),
    }
  },
  {
    type = "technology",
    name = "nitric-propellants",
    icon = "__petraspace__/graphics/technologies/nitric-propulsion.png",
    icon_size = 1024,
    prerequisites = { "rocket-propellants" },
    unit = {
      count = 100,
      ingredients = science("rg4bo"),
      time = 60,
    },
    effects = {
      recipe("ammonia-synthesis"),
      recipe("thruster-fuel-from-ammonia"),
      recipe("nitric-acid"),
      recipe("thruster-oxidizer-from-nitric-acid"),
      -- recipe("n2o4-thruster-oxidizer"),
    }
  },
  {
    type = "technology",
    name = "discover-viate",
    icons = PlanetsLib.technology_icon_moon("__petraspace__/graphics/icons/space-location/viate.png", 2048),
    localised_description = {"space-location-description.viate"},
    prerequisites = { 
      "orbital-science-pack",
      "rocket-propellants", "electric-engine", "concrete",
      "heating-tower", "construction-robotics"
      -- robots are so you can remotely move items to your silo
    },
    unit = {
      count = 300,
      ingredients = science("rgb2o"),
      time = 60,
    },
    effects = {
      {
        type = "unlock-space-location",
        space_location = "viate",
        -- dunno what this does
        use_icon_overlay_constant = true,
      },
      -- should i split this into LRS and Viate researches?
      -- it would p be bloat
      recipe("lunar-rocket-silo"),
      recipe("rocket-control-unit"),
      -- recipe("ice-melting"),
      recipe("orbital-data-card-low-pressure"),
      recipe("precision-optical-component-low-pressure"),
    }
  },
}

-- Welcome to Viate
data:extend{
  {
    type = "technology",
    name = "discover-regolith",
    icon = "__petraspace__/graphics/technologies/discover-regolith.png",
    icon_size = 256,
    prerequisites = { "discover-viate" },
    research_trigger = {
      type = "mine-entity",
      entity = "regolith-deposit",
    },
    effects = { 
      recipe("washing-regolith"),
      recipe("dissolving-regolith"),
      recipe("stone-bricks-from-regolith"),
    },
  }
}
-- Play with tech costs.
-- To give some fun progress feeling on Viate, make it a trigger tech.
-- I'd rather have it be "melt or mine N ice", but these are both not
-- possible in the trigger system due to WOKE
local tech_cse = data.raw["technology"]["chcs-concentrated-solar-energy"]
tech_cse.prerequisites = {"discover-viate"}
tech_cse.unit = nil
tech_cse.research_trigger = {
  type = "mine-entity",
  entity = "ice-deposit",
}
tech_cse.effects = {
  recipe("chcs-solar-power-tower"),
  recipe("chcs-heliostat-mirror"),
  recipe("ice-melting"),
}

local tech_vanilla_spience = data.raw["technology"]["space-science-pack"]
tech_vanilla_spience.prerequisites = {"discover-viate"}
tech_vanilla_spience.research_trigger = nil
tech_vanilla_spience.unit = {
  count = 1000,
  time = 60,
  ingredients = science("rgbo"),
}
tech_vanilla_spience.effects = { recipe("space-science-pack") }
-- SPACE AGE!
data:extend{
  {
    type = "technology",
    name = "dust-spraydown",
    -- TODO
    icon = "__base__/graphics/technology/fluid-handling.png",
    icon_size = 256,
    prerequisites = { "space-science-pack" },
    unit = { count = 50, time = 10, ingredients = science("s") },
    effects = {
      recipe("dust-sprayer"),
      recipe("dust-spraydown-water"),
    },
  },
}

local tech_vanilla_rocket = data.raw["technology"]["rocket-silo"]
tech_vanilla_rocket.prerequisites = { "space-science-pack" }
tech_vanilla_rocket.unit = {
  count = 500,
  time = 60,
  ingredients = science("2r2b2g2os"),
}
tech_vanilla_rocket.effects = {
  recipe("rocket-silo"),
  recipe("cargo-landing-pad"),
  recipe("space-platform-foundation"),
  recipe("space-platform-starter-pack"),
}
local tech_vanilla_splatform = data.raw["technology"]["space-platform"]
tech_vanilla_splatform.effects = {
  recipe("cargo-bay"),
  recipe("thruster"),
  recipe("empty-platform-tank"),
  recipe("platform-fuel-tank"),
  recipe("platform-oxidizer-tank"),
}
for _,planet_tech in ipairs{"vulcanus", "fulgora", "gleba"} do
  local tech = data.raw["technology"]["planet-discovery-" .. planet_tech]
  tech.prerequisites[1] = "space-platform"
  table.insert(tech.unit.ingredients, {"orbital-science-pack", 1})
end
local vanilla_thruster_tech = data.raw["technology"]["space-platform-thruster"]
vanilla_thruster_tech.enabled = false
vanilla_thruster_tech.visable_when_disabled = false

-- TIER 1 --

-- Nauvian research
data:extend{
  {
    type = "technology",
    name = "basic-uranium-processing",
    icon = "__petraspace__/graphics/technologies/basic-uranium-processing.png",
    icon_size = 256,
    -- "uranium mining" == fracking
    -- There's no real reason for it to require splatform
    -- other than symmetry
    prerequisites = {"space-platform", "uranium-mining"},
    effects = {recipe("depleted-uranium")},
    unit = {
      count = 1000,
      time = 60,
      ingredients = science("rgbs"),
    }
  },
}
local vanilla_u = data.raw["technology"]["uranium-processing"]
vanilla_u.prerequisites = {"basic-uranium-processing"}
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
    name = "nuclear-waste-processing",
    icon = "__petraspace__/graphics/technologies/nuclear-waste-processing.png",
    icon_size = 256,
    prerequisites = {"uranium-processing"},
    effects = {
      recipe("nuclear-waste-reprocessing"),
      recipe("barreled-nuclear-waste"),
      recipe("nuclear-waste-dumping"),
    },
    research_trigger = {
      type = "craft-item",
      item = "nuclear-waste",
      -- enough for it to get annoying
      count = 100,
    }
  },
  {
    type = "technology",
    name = "plutonium-processing",
    icon = "__petraspace__/graphics/technologies/plutonium-processing.png",
    icon_size = 256,
    prerequisites = {"nuclear-power"},
    effects = {
      recipe("mox-fuel-cell"),
      recipe("breeder-fuel-cell"),
      recipe("breeder-fuel-cell-reprocessing"),
    },
    research_trigger = {
      type = "craft-item",
      item = "plutonium",
      count = 1,
    },
  },
}
local purple_sci = data.raw["technology"]["production-science-pack"]
table.insert(purple_sci.prerequisites, "nuclear-waste-processing")
table.insert(purple_sci.unit.ingredients, {"space-science-pack", 1})
local yellow_sci = data.raw["technology"]["utility-science-pack"]
table.insert(yellow_sci.prerequisites, "plutonium-processing")
table.insert(yellow_sci.prerequisites, "exoskeleton-equipment")
table.insert(yellow_sci.unit.ingredients, {"space-science-pack", 1})

-- Vulcanus I
pglobals.tech.remove_unlock("foundry", "casting-low-density-structure")
pglobals.tech.add_unlock("foundry", "lime-calcination")
-- Intermediate: tungsten heat pipes
data:extend{
  {
    type = "technology",
    name = "tungsten-heat-pipe",
    -- TODO
    icon = "__petraspace__/graphics/technologies/geothermal-heat-exchanger.png",
    icon_size = 256,
    prerequisites = {"metallurgic-science-pack"},
    effects = {recipe("tungsten-heat-pipe")},
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
table.insert(recyc.effects, recipe("archaeological-scrap-recycling"))

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
pglobals.tech.add_unlock("planet-discovery-fulgora", "fulgoran-sludge-refining")
data:extend{
  {
    type = "technology",
    name = "lightning-rod",
    icon = "__petraspace__/graphics/technologies/lightning-rod.png",
    icon_size = 256,
    prerequisites = {"electromagnetic-science-pack"},
    effects = {recipe("lightning-rod")},
    unit = {
      count = 100,
      ingredients = science("E"),
      time = 30
    }
  },
  {
    type = "technology",
    name = "superconductor",
    icon = "__petraspace__/graphics/technologies/superconductor.png",
    icon_size = 256,
    prerequisites = {"electromagnetic-science-pack"},
    effects = {recipe("superconductor")},
    -- TODDO
    unit = {
      count = 999999999,
      ingredients = science("E"),
      time = 30
    }
  },
}

-- Gleba I
-- Strike out coal synth and good sulfur
pglobals.tech.remove_unlock("rocket-turret", "coal-synthesis")
pglobals.tech.remove_unlock("bioflux-processing", "biosulfur")

table.insert(data.raw["technology"]["bacteria-cultivation"].effects, 
  recipe("light-oil-reforming"))
table.insert(data.raw["technology"]["bacteria-cultivation"].effects, 
  recipe("heavy-oil-reforming"))
-- With oil reformation, all the special bio-recipes are no longer
-- necessary. (Plastic, rocket fuel, sulfur, and jelly.)
data.raw["technology"]["bioflux-processing"].hidden = true
pglobals.tech.remove_prereq("agricultural-science-pack", "bioflux-processing")

data:extend{
  {
    type = "technology",
    name = "boompuff",
    icon = "__petraspace__/graphics/technologies/boompuff-agriculture.png",
    icon_size = 256,
    effects = {
      { type="unlock-recipe", recipe="boompuff-processing" },
    },
    prerequisites = {"agriculture"},
    research_trigger = {
      type = "mine-entity",
      entity = "boompuff",
    }
  },
  {
    type = "technology",
    name = "fertilizer",
    -- TODO
    icon = "__petraspace__/graphics/technologies/boompuff-agriculture.png",
    icon_size = 256,
    effects = {
      { type="unlock-recipe", recipe="fertilizer" },
      { type="unlock-recipe", recipe="anfo-explosives" },
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
    name = "presto-fuel",
    -- TODO
    icon = "__petraspace__/graphics/technologies/boompuff-agriculture.png",
    icon_size = 256,
    effects = {
      { type="unlock-recipe", recipe="presto-fuel" },
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
turbelts.prerequisites = {"metallurgic-science-pack", "agricultural-science-pack"}
turbelts.unit = {
  count = 1000,
  ingredients = science("rgbspMA"),
  time = 60,
}

data:extend{
  {
    type = "technology",
    name = "advanced-bauxite-extraction",
    icon = "__petraspace__/graphics/icons/fluid/molten-aluminum.png",
    icon_size = 64,
    prerequisites = {
      "simple-bauxite-extraction",
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
      recipe("bauxite-liquor"),
      recipe("bauxite-liquor-electrolysis"),
      recipe("casting-aluminum-plate"),
      recipe("casting-low-density-structure"),
    },
  }
}
