local out = {}

out.demo_squishing = {
  checkerboard = true,
  planet = "vulcanus",
  mods = {"petraspace"},
  init = [[
    game.simulation.camera_alt_info = true
    game.simulation.camera_zoom = 1.0

    local s = game.surfaces[1]
    s.create_entity{name="small-demolisher", position={-10, 0}}
    local lb = s.create_entity{name="tungsten-steel-strongbox", position={0, 0}}
    local inv = lb.get_inventory(defines.inventory.chest)

    local magpie_alloy = prototypes.recipe["magpie-alloy"]
    for _,ingr in ipairs(magpie_alloy.ingredients) do
      inv.insert{name=ingr.name, count=ingr.amount * 20}
    end
  ]]
}

return out
