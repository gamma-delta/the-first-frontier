local pglobals = require("globals")
local procession_gfx = require("procession-gfx")

local effects = require("__core__.lualib.surface-render-parameter-effects")

local tile_collision_masks = require("__base__/prototypes/tile/tile-collision-masks")
local tile_graphics = require("__base__/prototypes/tile/tile-graphics")
local tile_spritesheet_layout = tile_graphics.tile_spritesheet_layout
local tile_sounds = require("__base__/prototypes/tile/tile-sounds")
local sa_tile_sounds = require("__space-age__/prototypes/tile/tile-sounds")


local hit_itself = {
  layers={water_tile=true, doodad=true},
  colliding_with_tiles=true
}

local viate_crust_decal = pglobals.copy_then(
  data.raw["optimized-decorative"]["sand-decal"],
  {name="viate-crust"}
)
viate_crust_decal.autoplace.probability_expression = [[
  (viate_elevation >= 20)
  * (viate_meteorness < 1) / (1-viate_meteorness) * 0.01
]]
-- Intersect with itself, but appear under other rocks and stuff
viate_crust_decal.collision_mask = hit_itself
for i,tbl in ipairs(viate_crust_decal.pictures) do
  tbl.filename = string.format(
    "__petraspace__/graphics/decorations/viate/crust-decal-%i.png", i
  )
end
data:extend{ viate_crust_decal }

local function viate_maria_edge_pebble(cfg)
  local rocc = util.copy(data.raw["optimized-decorative"][cfg.src])
  rocc.name = cfg.name
  rocc.autoplace = {
    order = "a[doodad]-a[rock]-c[maria]-" .. cfg.order,
    local_expressions = { prob = cfg.prob } ,
    probability_expression = [[
      ((3 - abs(viate_elevation-10) + (viate_elevation<10)) * prob)
        + (prob * 0.2)
    ]],
    -- control = "rocks",
  }
  rocc.collision_mask_connector = hit_itself
  data:extend{rocc}
end
viate_maria_edge_pebble{
  src = "medium-volcanic-rock",
  name = "viate-medium-maria-rock",
  order = "a",
  prob = 0.05,
}
viate_maria_edge_pebble{
  src = "small-volcanic-rock",
  name = "viate-small-maria-rock",
  order = "b",
  prob = 0.07,
}
viate_maria_edge_pebble{
  src = "tiny-volcanic-rock",
  name = "viate-tiny-maria-rock",
  order = "c",
  prob = 0.1,
}

local function viate_crater_lining_pebble(cfg)
  local rocc = util.copy(data.raw["optimized-decorative"][cfg.src])
  rocc.name = cfg.name
  rocc.autoplace = {
    order = "a[doodad]-a[rock]-d[crater]-" .. cfg.order,
    local_expressions = { 
      prob = cfg.prob,
      p = "1.3", -- period of trongle
      triangle = "1 / p * abs((viate_meteorness - p/4) % p)"
    },
    probability_expression = [[
      viate_above_basins * (viate_meteorness > 1.5) * (triangle > 0.95) * prob
    ]],
    -- control = "rocks",
  }
  rocc.collision_mask = hit_itself
  data:extend{rocc}
end
viate_crater_lining_pebble{
  -- TODO: lighter rocks
  src = "medium-volcanic-rock",
  name = "viate-medium-crater-rock",
  order = "a",
  prob = 0.3,
}
viate_crater_lining_pebble{
  src = "small-volcanic-rock",
  name = "viate-small-crater-rock",
  order = "b",
  prob = 0.5,
}
viate_crater_lining_pebble{
  src = "tiny-volcanic-rock",
  name = "viate-tiny-crater-rock",
  order = "c",
  prob = 0.6,
}

local function viate_maria_flavor(cfg)
  local deco = util.copy(data.raw["optimized-decorative"][cfg.src])
  deco.name = cfg.name
  deco.autoplace = {
    -- Place after the maria liners so they don't overflow
    order = "a[doodad]-z[maria-flavor]-" .. cfg.order,
    local_expressions = {prob = cfg.prob},
    probability_expression = [[
      (viate_elevation < -5) * prob * 0.02
    ]],
  }
  deco.collision_mask = hit_itself
  data:extend{ deco }
end
viate_maria_flavor{
  src="waves-decal",
  name="viate-maria-waves",
  order="a",
  prob=0.03
}
viate_maria_flavor{
  src="pumice-relief-decal",
  name="viate-maria-pumice",
  order="b",
  prob=0.20
}
viate_maria_flavor{
  src="nuclear-ground-patch",
  name="viate-maria-dirt",
  order="c",
  prob=0.05
}

local function viate_random_crater(cfg)
  local deco = util.copy(data.raw["optimized-decorative"][cfg.src])
  deco.name = cfg.name
  deco.autoplace = {
    -- Place after the maria liners so they don't overflow
    order = "a[doodad]-b[crater]-" .. cfg.order,
    local_expressions = {prob = cfg.prob},
    probability_expression = [[
      (viate_above_basins) * prob * 0.3
    ]],
  }
  deco.collision_mask = hit_itself
  data:extend{ deco }
end
viate_random_crater{
  src="calcite-stain-small",
  name="viate-white-stain",
  order="a",
  prob=0.017
}
viate_random_crater{
  src="crater-large",
  name="viate-crater-large",
  order="b",
  prob=0.01
}
viate_random_crater{
  src="crater-small",
  name="viate-crater-small",
  order="c",
  prob=0.015
}

data:extend(
  {
    pglobals.copy_then(
      data.raw["simple-entity"]["huge-volcanic-rock"],
      {
        name = "viate-meteorite",
        autoplace = {
          probability_expression = "viate_meteor_spot > 0"
        },
        -- This way, more than one doesn't try to generate in each crater
        map_generator_bounding_box = {{-20, -20}, {20, 20}},
        minable = {
          mining_particle = "stone-particle",
          mining_time = 3,
          results = {
           {type = "item", name = "regolith", amount_min = 10, amount_max = 20},
           {type = "item", name = "iron-ore", amount_min = 5, amount_max = 15},
           {type = "item", name = "stone", amount_min = 5, amount_max = 30},
           {type = "item", name = "native-aluminum", amount_min = 20, amount_max = 30},
        } },
        -- dying_trigger_effect = {
        --   type = "create-entity",
        --   entity_name = "dust-squib-white",
        -- }
      }
    )
  }
)

data:extend{
  pglobals.make_blobby_radius_expr{
    name = "viate_has_ground",
    input_scale = "150",
    radius = "1200",
    overhang_ok = "70",
    overhang_bonus = "0.9",
    seed = '"viate_has_ground"',
    persistence = "0.4",
  },
  {
    type = "noise-expression",
    name = "viate_starting_area_radius",
    expression = "0.15",
  },
  {
    type = "autoplace-control",
    -- size = 0 value
    -- frequency = noise scale
    name = "viate_basin",
    category = "terrain",
  },
  {
    type = "autoplace-control",
    name = "viate_spotness",
    category = "terrain",
  },
  {
    type = "autoplace-control",
    name = "viate_meteors",
    category = "terrain",
  },
  -- Cliffs won't spawn at y=0, so make a HUGE difference in height
  -- and just make the basins really really deep.
  {
    type = "noise-expression",
    name = "viate_above_basins",
    expression = "viate_elevation >= 10"
  },
  {
    type = "noise-expression",
    name = "viate_elevation",
    local_expressions = {
      -- so "coverage" in the GUI is actually `size`,
      -- and "scale" is `frequency`??
      -- anyways: use spot noise to create the basins, but mask it on perlin noise
      -- to add some ~interest~
      -- basin_spots and basin_noise both get higher the *more* basin-y it is
      basin_spots = [[
        clamp(
          basis_noise{
            x=x, y=y, seed0=map_seed, seed1="viate_basin_spots",
            input_scale = 0.002 * control:viate_spotness:frequency
          }
          * slider_to_linear(control:viate_spotness:size, 0.7, 2)
          * 2,
        0, 1)
      ]],
      basin_noise = [[
        max(0, multioctave_noise{
          x=x, y=y,
          seed0=map_seed, seed1="viate_basin_noise",
          input_scale = 0.01 * control:viate_basin:frequency,
          persistence = 0.7, octaves = 4
        } - 0.1)
      ]],
      basin_required = "(0.7 / slider_rescale(control:viate_basin:size, 12)) * 0.1",
      -- make the bottoms of the basins REALLY DEEP
      -- to make sure that ice doesn't spawn in the middle
      basins = [[
        if(
          (basin_spots * basin_noise) > basin_required,
          ((basin_spots * basin_noise) - basin_required) * -100,
          0
        )
      ]],
      canals = [[
        lerp(
          (0.4-abs(multioctave_noise{
            x=x, y=y*0.7,
            seed0=map_seed, seed1="canals",
            persistence=0.9,
            octaves=3,
            input_scale = 0.007
          })) * multioctave_noise{
            x=x, y=y,
            seed0=map_seed, seed1="canals2",
            persistence=0.4,
            octaves=2,
            input_scale = 0.004
          },
          0, -20
        )
      ]],
    },
    expression = "20 + basins",
  },
  {
    type = "noise-expression",
    name = "viate_meteor_size_noise",
    expression = [[ basis_noise{
      x=x, y=y, seed0=map_seed, seed1="viate_meteor_size",
      input_scale=0.03
    } + 1 ]]
  },
  {
    type = "noise-function",
    name = "viate_meteor_spot_noise",
    parameters = { "radius" },
    expression = [[
      spot_noise{
        x=x, y=y, seed0=map_seed, seed1=12345,
        density_expression = 10000000,
        spot_quantity_expression = viate_meteor_size_noise^2
          * 7000,
        spot_radius_expression = radius,
        spot_favorability_expression = 1,
        basement_value = 0,
        maximum_spot_basement_radius = 300,
        region_size = 1024,
        candidate_point_count = 20,
        suggested_minimum_candidate_point_spacing = 400
      } * 5
    ]]
  },
  {
    type = "noise-expression",
    name = "viate_meteorness",
    local_expressions = {
      -- spot_noise::seed1 does not accept strings
      raw_spots = [[ viate_meteor_spot_noise(
        70 * viate_meteor_size_noise
      ) ]],
      flavor = [[
        multioctave_noise{
          x=x, y=y,
          seed0=map_seed, seed1="viate_meteor_flavor",
          persistence=0.5,
          octaves=4,
          input_scale = 0.13
        } * 0.2 + 0.8
      ]]
    },
    expression = "raw_spots * flavor"
  },
  {
    type = "noise-expression",
    -- For things like the tile rings around the meteors so they don't look
    -- too artificial
    name = "viate_meteorness_deco",
    local_expressions = {
      -- spot_noise::seed1 does not accept strings
      raw_spots = [[ viate_meteor_spot_noise(
        70 * viate_meteor_size_noise
      ) ]],
      flavor = [[
        multioctave_noise{
          x=x, y=y, seed0=map_seed, seed1="viate_meteorness_deco",
          persistence=0.7, octaves=4, input_scale=0.92
        }
      ]]
    },
    expression = [[
      viate_meteorness * (flavor / 3 + 1)
    ]]
  },
  {
    type = "noise-expression",
    name = "viate_meteor_spot",
    -- Use same config as meteors but have a tiny radius,
    -- so that they're spotlike
    expression = [[
      viate_meteor_spot_noise(1)
      >
      slider_to_linear(control:viate_meteors:size, 0, 3)
    ]],
  }
}
PlanetsLib:extend{
  {
    type = "planet",
    name = "viate",
    icon = "__petraspace__/graphics/icons/space-location/viate.png",
    icon_size = 2048,
    starmap_icon = "__petraspace__/graphics/icons/space-location/viate.png",
    starmap_icon_size = 2048,
    orbit = {
      parent={type="planet", name="nauvis"},
      distance=1.2, orientation=0.7
    },
    magnitude = 0.6,
    label_orientation = 0.5,
    draw_orbit = false,

    gravity_pull = 10,
    order = "a[nauvis]-a",
    subgroup = "planets",
    pollutant_type = "dust",
    solar_power_in_space = 300,
    platform_procession_set =
    {
      arrival = {"planet-to-platform-b"},
      departure = {"platform-to-planet-a"}
    },
    planet_procession_set =
    {
      arrival = {"platform-to-planet-b"},
      departure = {"planet-to-platform-a"}
    },
    --[[
    procession_graphic_catalogue = procession_gfx.make_gfx{
      clouds = "__space-age__/graphics/procession/clouds/aquilo-cloudscape.png",
      clouds_l0 = "__space-age__/graphics/procession/clouds/aquilo-cloudscape-layered-0.png",
      clouds_l1 = "__space-age__/graphics/procession/clouds/aquilo-cloudscape-layered-1.png",
      clouds_l2 = "__space-age__/graphics/procession/clouds/aquilo-cloudscape-layered-2.png",
      clouds_l3 = "__space-age__/graphics/procession/clouds/aquilo-cloudscape-layered-3.png",
      planet_tint = "__space-age__/graphics/procession/clouds/aquilo-sky-tint.png",
    },
    ]]
    procession_graphic_catalogue = require("__space-age__/prototypes/planet/procession-catalogue-aquilo"),
    surface_properties =
    {
      ["day-night-cycle"] = 31 * minute,
      ["solar-power"] = 200,
      pressure = 0,
      gravity = 2,
      ["magnetic-field"] = 0,
    },
    asteroid_spawn_influence = 1,
    asteroid_spawn_definitions = {},
    surface_render_parameters = {
      -- TODO: could maybe use this to render meteor shadows?
      clouds = nil,
      day_night_cycle_color_lookup = {
        -- sharpish transitions, i guess, to mimic the sharp
        -- terminator that the real moon has
        -- but it can't be too sharp because then the solar panel
        -- power cut off looks really weird
        -- TODO steal cerys' dynamic thing
        { 0.30, "identity" },
        { 0.45, "__petraspace__/graphics/luts/viate-night.png" },
        { 0.65, "__petraspace__/graphics/luts/viate-night.png" },
        { 0.75, "identity" },
      }
    },
    map_gen_settings = {
      property_expression_names = {
        elevation = "viate_elevation",

        cliffiness = "cliffiness_basic",
        -- it does not look like you can change this?
        cliff_elevation = "cliff_elevation_from_elevation",
        cliff_smoothing = 0.0,
        richness = 3.5,
      },
      cliff_settings = {
        name = "cliff-viate",
        cliff_elevation_interval = 60,
        cliff_elevation_0 = 10,
      },
      autoplace_controls = {
        ["viate_basin"]={},
        ["viate_spotness"]={},
        ["viate_meteors"]={},
      },
      autoplace_settings = {
        tile = { settings = {
          ["viate-empty-space"] = {},
          ["viate-smooth-basalt"] = {},
          ["viate-dust-crests"] = {},
          ["viate-dust-lumpy"] = {},
          ["viate-dust-patchy"] = {},
        } },
        decorative = { settings = {
          ["viate-crust"] = {},
          ["viate-medium-maria-rock"] = {},
          ["viate-small-maria-rock"] = {},
          ["viate-tiny-maria-rock"] = {},
          ["viate-maria-waves"] = {},
          ["viate-maria-pumice"] = {},
          ["viate-maria-dirt"] = {},
          ["viate-medium-crater-rock"] = {},
          ["viate-small-crater-rock"] = {},
          ["viate-tiny-crater-rock"] = {},
          ["viate-white-stain"] = {},
          ["viate-crater-large"] = {},
          ["viate-crater-small"] = {},
        } },
        entity = { settings = {
          ["ice-deposit"] = {},
          ["regolith-deposit"] = {},
          ["viate-meteorite"] = {},
        } },
      }
    },
  },
}

local viate_offset = 70

-- genuinely have no idea what most of this stuff does
local viate_transitions = {
  {
    to_tiles = {"out-of-map","empty-space"},
    transition_group = out_of_map_transition_group_id,

    background_layer_offset = 1,
    background_layer_group = "zero",
    offset_background_layer_by_tile_layer = true,

    spritesheet = "__space-age__/graphics/terrain/out-of-map-transition/volcanic-out-of-map-transition.png",
    layout = tile_spritesheet_layout.transition_4_4_8_1_1,
    overlay_enabled = false
  },
  {
    -- stolen from vanilla dirt->water
    -- i think this makes the basalt appear "sunken"?
    to_tiles = {"viate-smooth-basalt"},
    transition_group = water_transition_group_id,
    -- dark enough
    -- aquilo uses the ice transition even when it's dust, which I guess
    -- makes sense
    spritesheet = "__base__/graphics/terrain/water-transitions/nuclear-ground.png",
    layout = tile_spritesheet_layout.transition_8_8_8_2_4,
    background_enabled = false,
  },
}

local function viate_tile(cfg)
  return util.merge{
    {
      type = "tile",
      name = cfg.name,
      order = "b[natural]-j[viate]-" .. cfg.order,
      subgroup = "viate-tiles",

      collision_mask = tile_collision_masks.ground(),
      autoplace = cfg.autoplace,
      absorptions_per_second = cfg.absorptions_per_second,

      walking_sound = cfg.walking_sound,
      landing_steps_sound = sa_tile_sounds.landing.rock,
      driving_sound = sa_tile_sounds.driving.stone,

      layer = viate_offset + cfg.offset,
      variants = tile_variations_template(
        cfg.texture, "__base__/graphics/terrain/masks/transition-4.png",
        {
          max_size = 4,
          [1] = { weights = {0.085, 0.085, 0.085, 0.085, 0.087, 0.085, 0.065, 0.085, 0.045, 0.045, 0.045, 0.045, 0.005, 0.025, 0.045, 0.045 } },
          [2] = { probability = 1, weights = {0.018, 0.020, 0.015, 0.025, 0.015, 0.020, 0.025, 0.015, 0.025, 0.025, 0.010, 0.025, 0.020, 0.025, 0.025, 0.010 }, },
          [4] = { probability = 0.1, weights = {0.018, 0.020, 0.015, 0.025, 0.015 }, },
          --[8] = { probability = 1.00, weights = {0.090, 0.125, 0.125, 0.125, 0.125, 0.125, 0.125, 0.025, 0.125, 0.005, 0.010, 0.100, 0.100, 0.010, 0.020, 0.020} }
        }),
    map_color = cfg.map_color,
    scorch_mark_color = {0.318, 0.222, 0.152},
  },
  cfg.etc}
end

local dusty_absorb = {
  dust = 0.1 / 60 / (32*32)
}

data:extend{
  {
    type = "item-subgroup",
    name = "viate-tiles",
    group = "tiles",
    order = "f-a",
  },
  -- Place empty space *first*, then fill the hole
  pglobals.make_empty_space(
    "viate",
    {
      offset = viate_offset,
      order = "![before-everything]",
      autoplace = {
        probability_expression = "(viate_has_ground == 0) * 999999",
      }
    }
  ),
  viate_tile{
    name = "viate-smooth-basalt",
    order = "a",
    offset = 0,
    absorptions_per_second = { dust = 2 / 60 / (32*32) },
    autoplace = {probability_expression="viate_above_basins==0"},
    texture = "__petraspace__/graphics/tiles/viate/smooth-basalt.png",
    map_color = { 0.2, 0.21, 0.25 },
    walking_sound = sa_tile_sounds.walking.rocky_stone({}),
    etc = {walking_speed_modifier = 1.2}
  },
  viate_tile{
    name = "viate-dust-crests",
    order = "zzz",
    offset = 1,
    absorptions_per_second = dusty_absorb,
    autoplace = {
      probability_expression=[[
        (viate_above_basins) * 0.01
      ]]
    },
    texture = "__space-age__/graphics/terrain/aquilo/dust-crests.png",
    map_color = { 0.6, 0.61, 0.7 },
    walking_sound = sa_tile_sounds.walking.rocky_stone({}),
    etc = { transitions=viate_transitions },
  },
  viate_tile{
    name = "viate-dust-lumpy",
    order = "bb",
    offset = 2,
    absorptions_per_second = dusty_absorb,
    autoplace = {
      probability_expression=[[
        (viate_above_basins) * (viate_meteorness_deco / 50)
      ]]
    },
    texture = "__space-age__/graphics/terrain/aquilo/dust-lumpy.png",
    map_color = { 0.7, 0.71, 0.80 },
    walking_sound = sa_tile_sounds.walking.rocky_stone({}),
    etc = { transitions=viate_transitions },
  },
  viate_tile{
    name = "viate-dust-patchy",
    order = "ba",
    offset = 3,
    absorptions_per_second = dusty_absorb,
    autoplace = {
      probability_expression=[[
        (viate_above_basins) * (viate_meteorness > 5)
      ]]
    },
    texture = "__space-age__/graphics/terrain/aquilo/dust-patchy.png",
    map_color = { 0.8, 0.81, 0.85 },
    walking_sound = tile_sounds.walking.sand,
    etc = { transitions=viate_transitions },
  },
}
