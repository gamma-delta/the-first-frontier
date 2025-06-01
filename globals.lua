local pglobals = {
  -- Gensym for nil
  null = {},
  platform_juice_tank_volume = 50000
}

pglobals.planet_moon_map = {
  nauvis = "viate",
  viate = "nauvis",
  vulcanus = "lepton",
  lepton = "vulcanus",
}
-- From util but listens to sentinels
function pglobals.deepcopy(object)
  if object == pglobals.null then return nil end
  local lookup_table = {}
  local function _copy(object)
    if type(object) ~= "table" then
      return object
    elseif lookup_table[object] then
      return lookup_table[object]
    end
    local new_table = {}
    lookup_table[object] = new_table
    for index, value in pairs(object) do
      new_table[_copy(index)] = _copy(value)
    end
    return setmetatable(new_table, getmetatable(object))
  end
  return _copy(object)
end

function pglobals.merge(tables)
  local ret = {}
  for i, tab in ipairs(tables) do
    for k, v in pairs(tab) do
      if (type(v) == "table") then
        if (type(ret[k] or false) == "table") then
          ret[k] = pglobals.merge{ret[k], v}
        else
          ret[k] = pglobals.deepcopy(v)
        end
      else
        ret[k] = v
      end
    end
  end
  return ret
end
 
function pglobals.merge1(tables)
  local ret = {}
  for i, tab in ipairs(tables) do
    for k, v in pairs(tab) do
      if (type(v) == "table") then
        ret[k] = pglobals.deepcopy(v)
      else
        ret[k] = v
      end
    end
  end
  return ret
end

function pglobals.copy_then(tbl, ...)
  local table2 = util.copy(tbl)
  -- So PIL just lies to me and i have to use `...` and not `arg`
  -- also, i can't just ipairs over varargs due to ?????
  local varargs = table.pack(...)
  for _,splat in ipairs(varargs) do
    table2 = pglobals.merge1{table2, splat}
  end
  return table2
end

-- Returns a function that makes a set, each key of the array mapped to default
function pglobals.set_with(default)
  return function(array)
    local out = {}
    for _,v in ipairs(array) do
      out[v] = default
    end
    return out
  end
end
function pglobals.set(array)
  return pglobals.set_with(true)(array)
end

function pglobals.surface_prop(planet, prop_name)
  local default = data.raw["surface-property"].default_value
  
  local prop_value = data.raw["planet"].surface_properties[prop_name]
  return prop_value or default
end

function pglobals.make_empty_space(prefix, etc)
  return pglobals.copy_then(
    data.raw["tile"]["empty-space"],
    {
      name = prefix .. "-empty-space",
      subgroup = prefix .. "-tiles",
      default_cover_tile = nil,
    	collision_mask = {
    		colliding_with_tiles_only = true,
    		not_colliding_with_itself = true,
    		layers = data.raw.tile["empty-space"].collision_mask.layers,
    	},
    	destroys_dropped_items = true,
    },
    etc or {}
  )
end

function pglobals.make_blobby_radius_expr(cfg)
  local out = {
    type = "noise-expression",
    name = cfg.name,
    local_expressions = {
      hang = "distance - " .. cfg.radius,
      is = cfg.input_scale .. " / distance",
      radius = cfg.radius,
      overhang_ok = cfg.overhang_ok,
      overhang_bonus = cfg.overhang_bonus,
      persistence = cfg.persistence or "0.7",
      octaves = cfg.octaves or "3",
    },
    -- Have ground if it's in the safe zone,
    -- or if the noise from 0-1 beats the overhang.
    -- So at distance 1 there's a 1/5 chance to fail, 2/5, 3/5, etc
    -- (for overhang_ok=5)
    -- Plus a little bonus so it's more differentiated
    -- Based on the angle; with a small enough scale this should disallow floating rocks
    -- because once an angle "loses" the check it can never win it again by going further.
    -- Also, clock noise needs to be done by macro every time cause noise
    -- functions require constants
    expression = string.format([[
        (distance <= radius)
        | (multioctave_noise{
            x=x*is, y=y*is, seed0=map_seed, seed1=%s,
            persistence=persistence, octaves=octaves
          }/2+0.5 > (hang/lepton_overhang_ok*lepton_overhang_bonus))
    ]], cfg.seed)
  }
  return pglobals.copy_then(out, cfg.etc or {})
end

pglobals.placevis = {
  filename = "__core__/graphics/cursor-boxes-32x32.png",
  priority = "extra-high-no-scale",
  size = 64,
  scale = 0.5,
  x = 3 * 64
}

pglobals.recipe = {
  replace = function(recipe_name, original, new)
    local recipe = data.raw["recipe"][recipe_name]
    for i,ingr in ipairs(recipe.ingredients) do
      if ingr.name == original then
        local new_tbl = new
        if type(new) ~= "table" then
          -- Keep count and type, swap name
          new_tbl = pglobals.copy_then(ingr, {name=new})
        end
        recipe.ingredients[i] = new_tbl
        return
      end
    end
    log("warning! recipe " .. recipe.name .. " did not have ingredient " .. original)
  end,
  add = function(recipe_name, new, ...)
    local news = table.pack(new, ...)
    local recipe = data.raw["recipe"][recipe_name]
    for _,new in ipairs(news) do
      table.insert(recipe.ingredients, new)
    end
  end
}

pglobals.tech = {
  remove_unlock = function(tech_name, recipe, ...)
    local recipes = table.pack(recipe, ...)
    local tech = data.raw["technology"][tech_name]
    for i, v in ipairs(tech.effects) do
      if v.type == "unlock-recipe" then
        for _, recipe in ipairs(recipes) do
          if v.recipe == recipe then
            table.remove(tech.effects, i)
            goto continue
          end
        end
        return
      end
    ::continue::
    end
  end,
  add_unlock = function(tech_name, recipe, ...)
    local recipes = table.pack(recipe, ...)
    local tech = data.raw["technology"][tech_name]
    for _,recipe in ipairs(recipes) do
      table.insert(tech.effects, {type="unlock-recipe", recipe=recipe})
    end
  end
}

pglobals.icons = {
  mini_over = function(mini, background)
    return {
      {
        icon = background,
      },
      {
        icon = mini,
        scale = 0.3333,
        shift = {-8, -8}
      },
    }
  end,
  ore_deposit = function(ore)
    return {
      {
        icon = ore,
      },
      {
        icon = "__base__/graphics/icons/signal/signal-mining.png",
        scale = 0.3333,
        shift = {-8, -8},
        draw_background = true
      },
    }
  end,
  one_into_two = function(input, out1, out2)
    return {
      {
        icon = input,
        scale = 0.4,
        shift = {0, -4},
      },
      {
        icon = out1,
        scale = 0.25,
        shift = {-8, 8},
        draw_background = true
      },
      {
        icon = out2,
        scale = 0.25,
        shift = {8, 8},
        draw_background = true
      }
    }
  end,
  two_into_one = function(in1, in2, output)
    -- Convention set by light oil cracking is to have the inputs under the out
    return {
      {
        icon = in1,
        scale = 0.25,
        shift = {-8, -8},
        draw_background = true
      },
      {
        icon = in2,
        scale = 0.25,
        shift = {8, -8},
        draw_background = true
      },
      {
        icon = output,
        scale = 0.4,
        shift = {0, 4},
        draw_background = true
      },
    }
  end,
  three_into_one = function(in1, in2, in3, output)
      -- Convention set by light oil cracking is to have the inputs under the out
      return {
        {
          icon = in1,
          scale = 0.5,
          shift = {-16, -16},
          draw_background = true
        },
        {
          icon = in2,
          scale = 0.5,
          shift = {0, -16},
          draw_background = true
        },
        {
          icon = in3,
          scale = 0.5,
          shift = {16, -16},
          draw_background = true
        },
        {
          icon = output,
          scale = 0.75,
          shift = {0, 8},
        },
      }
    end
}

return pglobals
