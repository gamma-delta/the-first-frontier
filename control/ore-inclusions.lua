-- Code based on Mylon's DivOresity
-- Thanks for making it MIT licensed, but less thanks for not distributing
-- the source code anywhere...
-- Ideally this would be done at generation time :<
local function add_inclusions(evt)
  local surface = evt.surface

  if surface.name == "nauvis" then
    local resources = surface.find_entities_filtered{
      type="resource", area=evt.area, name={"stone"},
    }

    for _,res in pairs(resources) do
      if res.name == "stone" then
        if math.random() < 1/40 then
          -- One "richness" is 10%, for some reason
          -- Let's make it start at 100% minimum
          local new_richness = math.max(res.amount * 0.001, 10)
            + (math.random() * 6 - 3)

          surface.create_entity{
            name="pktff-bauxite-ore", position=res.position, amount=new_richness,
          }
          res.destroy()
        end
      end
    end
  end
end

return {
  events = {
    [defines.events.on_chunk_generated] = add_inclusions
  }
}
