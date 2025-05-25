local pglobals = require("globals")

data:extend{
  {
    type = "item-subgroup",
    name = "rocket-juice",
    group = "space",
    order = "zzz"
  }
}

local function rocket_juice_icon(result)
  return function(original_icon)
    return pglobals.icons.mini_over(original_icon, result)
  end
end
local fuel_icon = rocket_juice_icon("__space-age__/graphics/icons/fluid/thruster-fuel.png")
local oxy_icon = rocket_juice_icon("__space-age__/graphics/icons/fluid/thruster-oxidizer.png")

local function to_rocket_juice(result, iconator, order_stub)
  -- amount is the amount produced by 1 drop, or 1 item
  -- fluid ingredients are scaled by 10 first
  return function (name, amount, type)
    type = type or "fluid"
    local multiplier = (type == "fluid") and 10 or 1

    -- please don't do any funny business here
    local ingr_proto = data.raw[type][name]
    local ingr_size = ingr_proto.icon_size or 64
    local juice_proto = data.raw["fluid"][result]
    local juice_size = juice_proto.icon_size or 64
    return {
      type = "recipe",
      name = result .. "-from-" .. name,
      category = "chemistry-or-cryogenics",
      enabled = false,
      ingredients = {{ type=type, name=name, amount=1*multiplier }},
      energy_required = 1,
      results = {{ type="fluid", name=result, amount=amount*multiplier }},
      subgroup = "rocket-juice",
      order = "z[auto]-" .. order_stub,
      localised_name = {
        "recipe-name." .. result .. "-from-whatever",
        {type .. "-name." .. name},
      },
      icons = iconator(ingr_proto.icon),
    }
  end
end
local to_fuel = to_rocket_juice("thruster-fuel", fuel_icon, "a")
local to_oxy = to_rocket_juice("thruster-oxidizer", oxy_icon, "b")

--[[
  Water -> H2 + O2
  H2 -> Fuel
  O2 -> Oxidizer
  Pgas + Fe + N (atmosphere) = Ammonia
  Ammonia + O2 -> Nitric acid + water
  Nitric acid + steam + copper -> N2O4
]]

data:extend{
  -- Phase 0: plain electrolysis
  {
    type = "recipe",
    name = "water-electrolysis",
    category = "chemistry",
    ingredients = {
      {type="fluid", name="water", amount=100},
    },
    results = {
      -- Do it in mols, I guess? This is what GT does
      {type="fluid", name="hydrogen", amount=200},
      {type="fluid", name="oxygen", amount=100},
    },
    -- So the play here is to just make a buttload of chemmy plants
    -- and use *efficiency* modules, not speed mods
    energy_required = 300,
    enabled = false,
    subgroup = "chemistry",
    order = "d[electro]-a",
    icons = pglobals.icons.one_into_two(
      "__base__/graphics/icons/fluid/water.png",
      "__petraspace__/graphics/icons/fluid/molecule-hydrogen.png",
      "__petraspace__/graphics/icons/fluid/molecule-oxygen.png"
    ),
  },
  {
    type = "recipe",
    name = "the-cooler-water-electrolysis",
    category = "electromagnetics",
    ingredients = {
      {type="fluid", name="water", amount=100},
      {type="fluid", name="electrolyte", amount=10},
    },
    results = {
      {type="fluid", name="hydrogen", amount=200},
      {type="fluid", name="oxygen", amount=100},
    },
    energy_required = 60,
    enabled = false,
    subgroup = "chemistry",
    order = "d[electro]-b",
    -- TODO
    icons = pglobals.icons.one_into_two(
      "__space-age__/graphics/icons/fluid/electrolyte.png",
      "__petraspace__/graphics/icons/fluid/molecule-hydrogen.png",
      "__petraspace__/graphics/icons/fluid/molecule-oxygen.png"
    ),
  },
  to_fuel("hydrogen", 0.5),
  to_oxy("oxygen", 1),

  -- or you can do the one block vertical difficulty curve for the beef
  -- Phase 1: nitrogen compound oxidizers, ammonia or kerosene fuel
  -- TODO: I should probably not unlock all of these with the LRS.
  -- If I'm going to implement nitric acid I want it used all over the mod.
  {
    type = "recipe",
    name = "ammonia-synthesis",
    category = "chemistry-or-cryogenics",
    ingredients = {
      {type="fluid", name="petroleum-gas", amount=20},
      -- this way you have something to do with all that hydrogen,
      -- but you still have to juice some of it
      {type="fluid", name="hydrogen", amount=10},
      -- this is your "finely powdered iron".
      -- i am an iron stick truther. if the devs added it, it should
      -- be used for things
      {type="item", name = "iron-stick", amount=4},
    },
    surface_conditions = {
      {property="atmospheric-nitrogen", min=30}
    },
    energy_required = 5,
    enabled = false,
    results = {{type="fluid", name="ammonia", amount=10}},
    subgroup = "chemistry",
    order = "e[synthesis]-a",
    -- Ignore the iron stick cause it's silly
    icons = pglobals.icons.two_into_one(
      "__base__/graphics/icons/fluid/petroleum-gas.png",
      "__petraspace__/graphics/icons/fluid/molecule-hydrogen.png",
      "__space-age__/graphics/icons/fluid/ammonia.png"
    )
  },
  -- is this just silly?
  to_fuel("ammonia", 2),
  {
    type = "recipe",
    name = "nitric-acid",
    category = "oil-processing",
    additional_categories = {"cryogenics"},
    ingredients = {
      -- Friendship ended with ostwald process
      -- now this made up thing is my new friend
      {type="fluid", name="ammonia", amount=10},
      {type="fluid", name="oxygen", amount=20},
      {type="item", name="sulfur", amount=1},
    },
    energy_required = 7,
    enabled = false,
    results = {
      {type="fluid", name="nitric-acid", amount=10},
      -- half the efficiency of the normal recipe
      {type="fluid", name="sulfuric-acid", amount=5},
    },
    main_product = "nitric-acid",
    subgroup = "chemistry",
    order = "e[synthesis]-b",
  },
  to_oxy("nitric-acid", 2),
  {
    type = "recipe",
    name = "n2o4-thruster-oxidizer",
    category = "chemistry-or-cryogenics",
    ingredients = {
      {type="fluid", name="nitric-acid", amount=10},
      {type="fluid", name="steam", amount=100},
      {type="item", name="copper-plate", amount=1},
    },
    energy_required = 35,
    enabled = false,
    results = {
      {type="fluid", name="thruster-oxidizer", amount=300},
    },
    subgroup = "rocket-juice",
    order = "b[oxy]-a",
    icons = pglobals.icons.two_into_one(
      "__petraspace__/graphics/icons/fluid/molecule-nitric-acid.png",
      "__base__/graphics/icons/copper-plate.png",
      "__space-age__/graphics/icons/fluid/thruster-oxidizer.png"
    ),
  },
  to_fuel("rocket-fuel", 500, "item"),
}
