local pglobals = require "globals"

-- we make our own with blackjack and hookers
data.raw["recipe"]["rocket-part"].hidden = true

local splatform_tiles = data.raw["recipe"]["space-platform-foundation"]
splatform_tiles.ingredients = {
  {type="item", name="low-density-structure", amount=20},
  {type="item", name="electric-engine-unit", amount=10},
  {type="item", name="copper-cable", amount=50},
}
splatform_tiles.results[1].amount = 5
local starterpack = data.raw["recipe"]["space-platform-starter-pack"]
starterpack.ingredients = {
  {type="item", name="space-platform-foundation", amount=60},
  {type="item", name="electric-engine-unit", amount=50},
  {type="item", name="processing-unit", amount=50},
  {type="item", name="pktff-precision-optical-component", amount=50},
}

-- You cannot ship this, you have to make it on Viate.
-- I want it to be the precursor challenge to space science.
-- So, don't make it hideously expensive ...
local spt = data.raw["recipe"]["chcs-solar-power-tower"]
spt.ingredients = {
  -- Keep it the same, also this way it encourages you to make conc reat babay
  {type = "item", name="concrete", amount=500},
  -- Split half of FeC to Al
  {type = "item", name="pktff-aluminum-plate", amount=200},
  {type = "item", name="steel-plate", amount=200},
  {type = "item", name="pktff-precision-optical-component", amount=100}, -- Cu -> POC
  -- This is only turned on in the Krastorio compat. Why? It makes sense.
  {type = "item", name="heat-pipe", amount=20}
}
-- Ship up exactly one, it's easier that way
data.raw["item"]["chcs-solar-power-tower"].weight = 1000 * kg
-- I want to encourage, but not require, making the mirrors on the moon.
local hsm = data.raw["recipe"]["chcs-heliostat-mirror"]
hsm.ingredients = {
  {type="item", name="electronic-circuit", amount=5},
  {type="item", name="pktff-aluminum-plate", amount=5}, -- FeC -> Al
  {type="item", name="iron-gear-wheel", amount=10},
}
-- make the SLT more expensive than in the base game because
-- you don't really need hardcore combat utils as much until later.
local slt = data.raw["recipe"]["chcs-solar-laser-tower"]
slt.ingredients = {
  {type = "item", name="concrete", amount=500},
  -- i guess it needs to be lighter or something to be able to swivel
  {type = "item", name="pktff-aluminum-plate", amount=400},
  {type = "item", name="pktff-precision-optical-component", amount=100},
  {type = "item", name="electric-engine-unit", amount=20},
}

-- Make oxide asteroids drop quicklime
-- It turns out that we don't actually know very much about the makeup
-- of comets, so this is 100% alright (lies)
data.raw["recipe"]["advanced-oxide-asteroid-crushing"].results[2].name = "pktff-quicklime"
-- Make acid-powered platforms feasible
data.raw["recipe"]["acid-neutralisation"].surface_conditions = nil

-- Remove OG rocket juice recipes
data.raw["recipe"]["thruster-fuel"].hidden = true
data.raw["recipe"]["thruster-oxidizer"].hidden = true
data.raw["recipe"]["advanced-thruster-fuel"].hidden = true
data.raw["recipe"]["advanced-thruster-oxidizer"].hidden = true
