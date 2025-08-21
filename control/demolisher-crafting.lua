local util = require "__core__/lualib/util"
local putil = require("__petraspace__/control/utils")

local squishing_recipes = prototypes.get_recipe_filtered({
  {filter="category", category="demolisher-squishing"},
})

return {
  events = {
    [defines.events.on_entity_died] = function(evt)
      if evt.cause == nil 
        or not evt.cause.name:find("demolisher")
        or evt.entity.name ~= "tungsten-steel-strongbox"
      then
        return
      end

      -- Map recipe names to successful craft counts
      local inv = evt.entity.get_inventory(defines.inventory.chest)
      for _,recipe in pairs(squishing_recipes) do
        -- game.print("attempting to squish " .. tostring(recipe))
        local limit_count = 99999999
        for _,ingredient in ipairs(recipe.ingredients) do
          local crafts = math.floor(inv.get_item_count(ingredient.name) / ingredient.amount)
          limit_count = math.min(limit_count, crafts)
        end
        if limit_count ~= 0 then
          -- game.print("we got crafts: " .. limit_count)
          -- for SOME REASON it's called PRODUCTS OVER HERE?????
          for _,result in ipairs(recipe.products) do
            evt.loot.insert{name=result.name, count=result.amount * limit_count}
          end
        end
      end

    end
  }
}
