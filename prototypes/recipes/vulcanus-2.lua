data:extend{
  -- See here
  -- https://github.com/danielmartin0/Cerys-Moon-of-Fulgora/blob/main/prototypes/recipe/recipe.lua#L190
  {
    type = "recipe",
    name = "magpie-alloy",
    category = "demolisher-squishing",
    hidden = true,
    enabled = false,
    ingredients = {
      {type="item", name="aluminum-plate", amount=12},
      {type="item", name="magnesium-slag", amount=10},
      {type="item", name="lithium-plate", amount=10},
    },
    energy_required = 1,
    results = {
      {type="item", name="magpie-alloy", amount=10},
    },
    always_show_made_in = true,
    hide_from_player_crafting = true,
    allow_decomposition = false,
    always_show_products = true,
    auto_recycle = false,
  }
}
