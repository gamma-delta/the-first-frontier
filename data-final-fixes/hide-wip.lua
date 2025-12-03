local function hide(ty, names)
  for _,name in ipairs(names) do
    data.raw[ty][name].hidden = true
  end
end

hide("item", {
  "pktff-magpie-alloy"
})

hide("electric-energy-interface", {"pktff-electrostatic-funneler"})
hide("planet", {"pktff-lepton"})
