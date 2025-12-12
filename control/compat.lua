local function disco_science()
  if remote.interfaces["DiscoScience"] then
    remote.call("DiscoScience", "setIngredientColor",
      "pktff-orbital-science-pack", {0.41, 0.32, 0.75, 1.0 } --[[@as Color]])
  end
end

return {
  on_init = disco_science,
  on_configuration_changed = disco_science,
}
