local pglobals = require("globals")

data:extend{
  {
    type = "recipe-category",
    -- Smelting done in fueled furnaces
    name = "pktff-dirty-smelting",
  },
  {
    type = "recipe-category",
    name = "pktff-dust-spraydown",
  },
  {
    type = "recipe-category",
    name = "pktff-mystery-flesh-pit",
  },
  {
    -- Cheating here
    -- https://github.com/danielmartin0/Cerys-Moon-of-Fulgora/blob/main/prototypes/recipe/recipe.lua#L190
    type = "recipe-category",
    name = "pktff-demolisher-squishing",
  },

  -- TODO: switch things back to using this
  {
    type = "item-subgroup",
    group = "intermediate-products",
    name = "pktff-chemistry",
  },
  {
    type = "item-subgroup",
    name = "pktff-rocket-juice",
    group = "space",
    order = "zzz"
  },

  -- Add new collision layer for things that can't go on the light scaffolding
  {
    type = "collision-layer",
    name = "pktff-space-platform-scaffolding"
  },

  {
    type = "burner-usage",
    name = "pktff-mfp-scouts",
    empty_slot_sprite = {
      filename = "__core__/graphics/icons/mip/empty-robot-slot.png",
      priority = "extra-high-no-scale",
      size = 64, mipmap_count = 2,
      flags = {"gui-icon"},
    },
    empty_slot_caption = {"gui.pktff-mfp-scouts"},
    empty_slot_description = {"gui.pktff-mfp-scouts-description"},
    icon = {
      filename = Asset"graphics/icons/mfp-no-scouts.png",
      priority = "extra-high-no-scale",
      size = 64,
      flags = {"icon"},
    },
    no_fuel_status = {"entity-status.pktff-mfp-no-scouts"},
    accepted_fuel_key = "description.pktff-mfp-accepted-scouts",
    burned_in_key = "pktff-mfp-scout-burned-in",
  },
  {
    type = "fuel-category",
    name = "pktff-mfp-scouts",
    fuel_value_type = {"description.pktff-mfp-scouts-energy-value"}
  },
}
