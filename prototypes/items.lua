local pglobals = require "globals"

local item_sounds = require("__base__/prototypes/item_sounds")
local spage_sounds = require("__space-age__/prototypes/item_sounds")
local item_tints = require("__base__/prototypes/item-tints")

local rocket_cap = 1000 * kg

local function make_pics(prefix, count, etc)
  local out = {}
  for i=1,count do
    local row = util.merge{
      {
        filename = 
          string.format(Asset"graphics/icons/%s/%s.png", prefix, i),
        size = 64, mipmap_count = 4, scale = 0.5,
      },
      etc or {}
    }
    table.insert(out, row)
  end
  return out
end

local function make_programmed_card(name, icon, order, spoil_time)
  return {
    type = "item",
    name = name,
    subgroup = "intermediate-product",
    icon = icon,
    order = order,

    -- This way it actually shows in the UI that it spoils into something.
    spoil_result = "copper-cable",
    spoil_ticks = spoil_time,

    stack_size = 100,
    weight = rocket_cap / 1000,
    pick_sound = item_sounds.electric_small_inventory_pickup,
    drop_sound = item_sounds.electric_small_inventory_move,
    move_sound = item_sounds.electric_small_inventory_move,
  }
end

data:extend{
  make_programmed_card(
    "pktff-orbital-data-card",
    Asset"graphics/icons/orbital-data-card.png",
    "ba",
    -- survive for 1 rotation
    data.raw["planet"]["nauvis"].surface_properties["day-night-cycle"]
  ),
}

-- Common components
data:extend{
  pglobals.copy_then(
    data.raw["item"]["plastic-bar"],
    {
      name = "pktff-circuit-substrate",
      order = "b[circuits]-![circuit-substrate]",
      icon = Asset"graphics/icons/circuit-substrate.png",
      weight = rocket_cap / 1000,
    }
  ),
  pglobals.copy_then(
    data.raw["item"]["electronic-circuit"],
    {
      name = "pktff-precision-optical-component",
      -- between electric engines and robot frames
      order = "c[advanced-intermediates]-ba[poc]",
      icon = Asset"graphics/icons/precision-optical-component.png",

      -- glassy sound, maybe? i don't want to use science's glassy tink
      -- cause it's only for science
      pick_sound = spage_sounds.ice_inventory_pickup,
      drop_sound = spage_sounds.ice_inventory_move,
      move_sound = spage_sounds.ice_inventory_move,
      weight = rocket_cap / 400,
    }
  ),
  pglobals.copy_then(
    data.raw["item"]["electronic-circuit"],
    {
      -- they're back!!
      name = "pktff-rocket-control-unit",
      -- right before rocket parts
      order = "d[rocket-parts]-d!",
      icon = Asset"graphics/icons/rocket-control-unit.png",

      stack_size = 20,
      weight = rocket_cap / 20,
    }
  ),
}

-- Boom headshot
data:extend{
  pglobals.copy_then(
    data.raw["item"]["gun-turret"],
    {
      name = "pktff-shotgun-turret",
      order = "b[turret]-az[shotgun-turret]",
      icon = Asset"graphics/icons/shotgun-turret.png",
      place_result = "pktff-shotgun-turret",
    }
  )
}

  -- === Aluminum === --
data:extend{
  {
    type = "item-subgroup",
    name = "pktff-aluminum-processes",
    group = "intermediate-products",
    -- right after raw-material, the row with iron&copper plates
    order = "ca",
  },
  
  pglobals.copy_then(
    data.raw["item"]["iron-ore"],
    {
      -- yes, bauxite ore is redundant
      name = "pktff-bauxite-ore",
      subgroup = "raw-resource",
      -- after copper, before uranium
      order = "fa[bauxite-ore]",
      icon = Asset"graphics/icons/bauxite/1.png",
      pictures = make_pics("bauxite", 4),
      -- Otherwise it will detect the "locked" recipe for petrichor enrichment
      -- and restrict it.
      flags = {"always-show"},
    }
  ),
  pglobals.copy_then(
    data.raw["item"]["iron-ore"],
    {
      name = "pktff-native-aluminum",
      subgroup = "pktff-aluminum-processes",
      -- after copper, before uranium
      order = "a[native-aluminum]",
      icon = Asset"graphics/icons/native-aluminum/1.png",
      pictures = make_pics("native-aluminum", 3)
    }
  ),
  pglobals.copy_then(
    data.raw["item"]["iron-plate"],
    {
      name = "pktff-aluminum-plate",
      weight = rocket_cap / 500,
      subgroup = "pktff-aluminum-processes",
      order = "b[aluminum-plate]",
      icon = Asset"graphics/icons/aluminum-plate.png",
    }
  ),
}
local spsp = pglobals.copy_then(
  data.raw["space-platform-starter-pack"]["space-platform-starter-pack"],
  {
    name = "pktff-space-platform-starter-pack-scaffolding",
    order = "!!!first",
    initial_items = {{name="pktff-space-platform-scaffolding", type="item", amount=10}}
  }
)
for _,tile in ipairs(spsp.tiles) do
  tile.tile = "pktff-space-platform-scaffolding"
end
data:extend{spsp}

-- Viate
data:extend{
  pglobals.copy_then(
    data.raw["item"]["stone"],
    {
      name = "pktff-regolith",
      subgroup = "raw-resource",
      -- after bauxite?
      order = "fb[regolith]",
      icon = Asset"graphics/icons/regolith/1.png",
      pictures = make_pics("regolith", 4)
    }
  ),
  pglobals.copy_then(
    data.raw["item"]["space-platform-foundation"],
    {
      name = "pktff-space-platform-scaffolding",
      place_as_tile = {
        result = "pktff-space-platform-scaffolding",
        condition_size = 1,
        condition = {layers={empty_space=true}},
        invert = true,
      }
      -- TODO icon
    }
  ),
}

-- Nauvis
local function fuel_cell_pic(path)
  return {
    layers = {
      {
        filename = path,
        size = 64, scale = 0.5, mipmap_count = 4,
      },
      {
        filename = "__base__/graphics/icons/uranium-fuel-cell-light.png",
        draw_as_light = true,
        size = 64, scale = 0.5, mipmap_count = 4,
      }
    }
  }
end
local u238 = data.raw["item"]["uranium-238"]
u238.icon = Asset"graphics/icons/u238/1.png"
u238.pictures = make_pics("u238", 3)
data:extend{
  {
    type = "item",
    name = "pktff-nuclear-waste",
    icon = Asset"graphics/icons/nuclear-waste.png",
    stack_size = 1,
    weight = rocket_cap * 10,
    subgroup = "uranium-processing",
    order = "z[waste]-a",

    inventory_move_sound = item_sounds.nuclear_inventory_move,
    pick_sound = item_sounds.nuclear_inventory_pickup,
    drop_sound = item_sounds.nuclear_inventory_move,
    random_tint_color = item_tints.iron_rust,

    spoil_result = "uranium-ore",
    spoil_ticks = 24 * hour,

    -- nice try
    auto_recycle = false,
  },
  pglobals.copy_then(data.raw["item"]["uranium-235"], {
    name = "pktff-plutonium",
    icon = Asset"graphics/icons/plutonium.png",
    order = "a[uranium-processing]-z",
    pictures = {
      {
        filename = Asset"graphics/icons/plutonium.png",
        size = 64, scale = 0.5, mipmap_count = 4,
      },
      {
        filename = Asset"graphics/icons/plutonium-glow.png",
        draw_as_light = true,
        size = 64, scale = 0.5, mipmap_count = 4,
      }
    }
  }),
  pglobals.copy_then(data.raw["item"]["uranium-fuel-cell"], {
    name = "pktff-mox-fuel-cell",
    order = "b[uranium-products]-c",
    icon = Asset"graphics/icons/mox-fuel-cell.png",
    pictures = fuel_cell_pic(Asset"graphics/icons/mox-fuel-cell.png"),

    burnt_result = "depleted-uranium-fuel-cell",
    -- over twice the power
    fuel_value = "120GJ",
  }),
  pglobals.copy_then(data.raw["item"]["uranium-fuel-cell"], {
    name = "pktff-breeder-fuel-cell",
    icon = Asset"graphics/icons/breeder-fuel-cell.png",
    pictures = fuel_cell_pic(Asset"graphics/icons/breeder-fuel-cell.png"),
    order = "b[uranium-products]-d",

    burnt_result = "pktff-depleted-breeder-fuel-cell",
    -- less power
    fuel_value = "20GJ",
  }),
  pglobals.copy_then(data.raw["item"]["depleted-uranium-fuel-cell"], {
    name = "pktff-depleted-breeder-fuel-cell",
    order = "b[uranium-products]-e",
    icon = Asset"graphics/icons/depleted-breeder-fuel-cell.png",
  }),
  pglobals.copy_then(data.raw["item"]["depleted-uranium-fuel-cell"], {
    name = "pktff-barreled-nuclear-waste",
    order = "z[waste]-b",
    icon = Asset"graphics/icons/barreled-nuclear-waste.png",
    stack_size = 1,
    mass = 10 * rocket_cap,
    auto_recycle = false,
    spoil_result = "barrel",
    spoil_ticks = 24 * hour,
  }),
}

-- Vulcanus
data:extend{
  pglobals.copy_then(data.raw["item"]["calcite"], {
    name = "pktff-quicklime",
    order = "a[melting]-za",
    icon = Asset"graphics/icons/quicklime/1.png",
    pictures = make_pics("quicklime", 3),
  }),
  pglobals.copy_then(data.raw["item"]["tungsten-ore"], {
    name = "pktff-magnesium-slag",
    order = "za[refinement]-a[magnesium-slag]",
    -- Using malcolm's titanium as "magnesium" to get the consistent color
    -- in my mind magnesium is pinkish? but this is probably because of greg
    -- Only using the first 3 images b/c they have better contrast
    icon = Asset"graphics/icons/magnesium-slag/1.png",
    pictures = make_pics("magnesium-slag", 3),
  }),
}

-- Fulgora
data:extend{
  pglobals.copy_then(data.raw["item"]["scrap"], {
    name = "pktff-archaeological-scrap",
    order = "a[scrap]-b[archaelogicical-scrap]",
    icon = Asset"graphics/icons/archaeological-scrap/1.png",
    pictures = make_pics("archaeological-scrap", 3),
  })
}

-- Gleba
data:extend{
  pglobals.copy_then(data.raw["capsule"]["yumako"], {
    type = "item",
    name = "pktff-boompuff-propagule",
    icon = Asset"graphics/icons/boompuff-propagule.png",
    order = "b[agriculture]-b[jellynut]-a[boompuff-propagule]",
    -- place_result overrides the normal name/desc stuff
    localised_name = {"item-name.pktff-boompuff-propagule"},
    localised_description = {"item-description.pktff-boompuff-propagule"},
    pictures = { sheet = {
      filename = Asset"graphics/icons/boompuff-propagule-sheet.png",
      width = 64, height = 64, scale = 0.5,
      variation_count = 8,
    }},
    -- same as wood
    stack_size = 100,
    weight = rocket_cap / 500,
    plant_result = "pktff-boompuff-plant",
    place_result = "pktff-boompuff-plant",
    -- no i'm not making it explode! i'm pulling that joke already
    -- with particle physics!
    -- i might steal lordmiguels' grenades-at-home tho
    spoil_ticks = 5 * minute,
    capsule_action = nil,
    fuel_category = "chemical",
    -- a little better than coal
    fuel_value = "5MJ",
  }),
}
-- Stop burning these wet fruits that makes no sense
for _,stopthat in ipairs{"yumako", "jellynut"} do
  local it = data.raw["capsule"][stopthat]
  it.fuel_value = nil
  it.fuel_category = nil
end
-- sigh
data:extend{
  {
    name = "pktff-fertilizer",
    type = "item",
    icon = Asset"graphics/icons/fertilizer/1.png",
    subgroup = "agriculture-products",
    order = "c[nutrients]-z-a[fertilizer]",
    pictures = make_pics("fertilizer", 3, {size=64, scale=0.5, mipmap_count=4}),
    fuel_category = "nutrients",
    -- nutrience is 2MJ
    fuel_value = "1.5MJ",
    inventory_move_sound = spage_sounds.agriculture_inventory_move,
    pick_sound = spage_sounds.agriculture_inventory_pickup,
    drop_sound = spage_sounds.agriculture_inventory_move,
    stack_size = 100,
    spoil_ticks = nil,
    spoil_result = nil,
    weight = rocket_cap / 1000,
    default_import_location = "gleba",
  },
  {
    type = "item",
    name = "pktff-presto-fuel",
    icon = "__base__/graphics/icons/rocket-fuel.png",
    fuel_category = "chemical",
    fuel_value = "1MJ",
    fuel_acceleration_multiplier = 12.1,
    fuel_top_speed_multiplier = 2,
    subgroup = "agriculture-products",
    order = "a[organic-products]-z-d[presto-fuel]",
    inventory_move_sound = item_sounds.fuel_cell_inventory_move,
    pick_sound = item_sounds.fuel_cell_inventory_pickup,
    drop_sound = item_sounds.fuel_cell_inventory_move,
    stack_size = 1,
    weight = rocket_cap / 100,
  }
}

-- Superalloys
data:extend {
  pglobals.copy_then(data.raw["item"]["tungsten-plate"], {
    name = "pktff-magpie-alloy",
    subgroup = "vulcanus-processes",
    order = "zb[superalloys]-a",
    icon = Asset"graphics/icons/magpie-alloy/1.png",
    pictures = make_pics("magpie-alloy", 8),
    stack_size = 20,
    weight = rocket_cap / 20,
    random_tint_color = item_tints.iron_rust,
  }),
}

-- === Science! === --
local function science_pack(name, order, icon, tint)
  return pglobals.copy_then(
    data.raw["tool"]["automation-science-pack"],
    {
      name = name,
      icon = icon,
      order = order,
      random_tint_color = tint,
    }
  )
end
data:extend{
  science_pack(
    "pktff-orbital-science-pack", "d[chemical-science-pack]-a",
    Asset"graphics/icons/orbital-science-pack.png",
    item_tints.bluish_science
  ),
}
