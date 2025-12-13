local pglobals = require("globals")

-- Make OG coal spawn around anthracite
-- see prototypes/entities/resources.lua
local coal = data.raw["resource"]["coal"]
coal.map_color = {0.1, 0.1, 0.1}
-- spawn right after
coal.autoplace.order = "ba"

---@type data.PlanetPrototypeMapGenSettings
local nauvis_mgs = data.raw["planet"]["nauvis"].map_gen_settings
-- Place anthracite on Nauvis
nauvis_mgs.autoplace_settings.entity.settings["pktff-anthracite-coal"] = {}
-- Place bauxite on nauvis
nauvis_mgs.autoplace_settings.entity.settings["pktff-bauxite-ore"] = {}
-- Instead of using the normal probabilities, use the custom ones
nauvis_mgs.property_expression_names["entity:pktff-bauxite-ore:probability"] = "pktff-bauxite-inclusions-probability"
nauvis_mgs.property_expression_names["entity:pktff-bauxite-ore:richness"] = "pktff-bauxite-inclusions-richness"
nauvis_mgs.property_expression_names["entity:lalalaltest:richness"] = "pktff-bauxite-inclusions-richness"

---@type data.PlanetPrototypeMapGenSettings
local vulcanus_mgs = data.raw["planet"]["vulcanus"].map_gen_settings
-- allow anthracite on Vulc
vulcanus_mgs.autoplace_settings.entity.settings["pktff-anthracite-coal"] = {}
-- disallow coal on vulc
vulcanus_mgs.autoplace_settings.entity.settings["coal"] = nil
vulcanus_mgs.property_expression_names["entity:coal:probability"] = nil
vulcanus_mgs.property_expression_names["entity:coal:richness"] = nil
-- set the prob/richness of anthracite to what was previously coal
vulcanus_mgs.property_expression_names["entity:pktff-anthracite-coal:probability"] = "vulcanus_coal_probability"
vulcanus_mgs.property_expression_names["entity:pktff-anthracite-coal:richness"] = "vulcanus_coal_richness"
