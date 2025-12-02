local function hide(ty, names)
  for _,name in ipairs(names) do
    data.raw[ty][name].hidden = true
  end
end

hide("item", {
  "magpie-alloy"
})

hide("electric-energy-interface", {"electrostatic-funneler"})
hide("planet", {"lepton"})
