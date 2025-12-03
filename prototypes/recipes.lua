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
  {
    type = "item-subgroup",
    group = "intermediate-products",
    name = "pktff-chemistry",
  },
}

require("recipes/rocket-parts")

require("recipes/nauvis-1")
require("recipes/viate")

require("recipes/fulgora-1")
require("recipes/vulcanus-1")
require("recipes/gleba-1")
require("recipes/post-t1")

require("recipes/vulcanus-2")

require("recipes/science")
