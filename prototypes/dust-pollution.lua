-- Prototypes used exclusively for implementing dust and associated slowdown,
-- as well as adding dust emissions to vanilla stuff

data:extend{
  {
    type = "airborne-pollutant",
    name = "pktff-dust",
    icon = {
      filename = "__core__/graphics/icons/mip/side-map-menu-buttons.png",
      priority = "high",
      size = 64,
      mipmap_count = 2,
      y = 3 * 64,
      flags = {"gui-icon"}
    },
    chart_color = { r=100, g=120, b=190, a=100 },
    affects_evolution = false,
    affects_water_tint = false,
  },

  -- Implement dust slowdown by putting a !!SECRET!! invisible
  -- beacon on top of every entity
  {
    type = "module-category",
    name = "pktff-dust-secret-module",
  },
  {
    type = "module",
    name = "pktff-dust-secret-module",
    category = "pktff-dust-secret-module",
    hidden = true,
    effect = {
      speed = -0.01,
      -- 1% of this is to offset slowdown energy reduction
      consumption = 0.02,
    },
    tier = 1,
    -- whatever
    icon = "__base__/graphics/icons/speed-module.png",
    stack_size = 1,
  },
  {
    type = "beacon",
    name = "pktff-dust-secret-beacon",
    -- needs to be more than 1, apparently,
    -- even though there's the reaganomics power gen
    energy_usage = "1W",
    energy_source = { type="void" },
    supply_area_distance = 1,
    -- it does not matter because it will only cover one thing
    distribution_effectivity = 1,
    -- don't nerf other beacons
    profile = {1},
    module_slots = 100,
    allowed_module_categories = { "pktff-dust-secret-module" },
    allowed_effects = { "speed" },

    pictures = util.empty_sprite(),
    hidden = true,
    collision_mask = {layers={}},
    selectable_in_game = false,
    selection_priority = 0,
    flags = {
      "not-on-map", "not-flammable",
      "no-automated-item-insertion", "no-automated-item-removal",
      "get-by-unit-number",
    },
  },
}

-- Make things dusty
data.raw.planet["fulgora"].pollutant_type = "pktff-dust"

-- Unfortunately inserters ignore their pollution on their power source,
-- and it would not be easy to make them or belts only emit when moving.

local function energy_dust(energy, amount)
  if energy.emissions_per_minute == nil then
    energy.emissions_per_minute = {}
  end
  energy.emissions_per_minute["pktff-dust"] = amount
end
local function passive_dust(entity, amount)
  if entity.emissions_per_second == nil then
    entity.emissions_per_second = {}
  end
  entity.emissions_per_second["pktff-dust"] = amount / 60
end

-- Burner mining drills emit (toxic) pollution at 12/minute
-- Electrics do 10.
-- Let's say 10 is the "normal" amount
-- although as with normal pollution, drills will be the biggest contributor.
local drills = data.raw["mining-drill"]
energy_dust(drills["burner-mining-drill"].energy_source, 10)
energy_dust(drills["electric-mining-drill"].energy_source, 15)
energy_dust(drills["big-mining-drill"].energy_source, 80)

-- electrostatic dust, I guess, iunno, it makes high-quality
-- accumulators more interesting on Fulgora
energy_dust(data.raw["accumulator"]["accumulator"], 10)

-- for some reason higher-quality assembling machines produce less pollution?
local asm = data.raw["assembling-machine"]
energy_dust(asm["assembling-machine-1"].energy_source, 5)
energy_dust(asm["assembling-machine-2"].energy_source, 15)
energy_dust(asm["assembling-machine-3"].energy_source, 20)
energy_dust(asm["centrifuge"].energy_source, 30)
local furnaces = data.raw["furnace"]
energy_dust(furnaces["recycler"].energy_source, 15)
energy_dust(data.raw["roboport"]["roboport"].energy_source, 30)

-- todo: make tesla turrets dusty? it will be quite the PITA to impl
-- you'll never use them on Viate or Fulgora anyways

-- local poles = data.raw["electric-pole"]
-- passive_dust(poles["small-electric-pole"], 5)
-- passive_dust(poles["medium-electric-pole"], 7)
-- passive_dust(poles["big-electric-pole"], 10)
-- passive_dust(poles["substation"], 20)

-- the blades kick up dust.
-- it's a fun inversion to have pollution produced by boilers (and not engines),
-- but dust produced by engines (and not boilers)
local generators = data.raw["generator"]
energy_dust(generators["steam-engine"].energy_source, 5)
energy_dust(generators["steam-turbine"].energy_source, 30)

local function make_tile_undusty(tile, amount_per_minute_per_chunk)
  local tileobj = data.raw["tile"][tile]
  if tileobj.absorptions_per_second == nil then
    tileobj.absorptions_per_second  = {}
  end
  tileobj.absorptions_per_second["pktff-dust"] = amount_per_minute_per_chunk 
    / 60 / (32 * 32)
end
make_tile_undusty("stone-path", 0.3)
local conc_absorb = 0.5
make_tile_undusty("concrete", conc_absorb)
make_tile_undusty("hazard-concrete-left", conc_absorb)
make_tile_undusty("hazard-concrete-right", conc_absorb)
-- very high to encourage making refined concrete on fulgora instead of
-- just paving with the normal concrete
local refined_conc_absorb = 1.0
make_tile_undusty("refined-concrete", refined_conc_absorb)
make_tile_undusty("refined-hazard-concrete-left", refined_conc_absorb)
make_tile_undusty("refined-hazard-concrete-right", refined_conc_absorb)
-- it slurps up the dust cause it's sticky, I guess?
-- slurp slurp
-- I don't want this to be too high though, to make sure
-- you actually have to worry about disposing of dust
-- on fulgora
make_tile_undusty("oil-ocean-shallow", 1.0)
make_tile_undusty("oil-ocean-deep", 2.5)
