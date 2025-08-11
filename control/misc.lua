local util = require "__core__/lualib/util"
local putil = require("__petraspace__/control/utils")

local function add_qai_techs(force)
  for _,tech_name in ipairs{
    "near-inserters",
    "long-inserters-1",
    "long-inserters-2",
    "more-inserters-1",
    "more-inserters-2",
  } do
    local tech = force.technologies[tech_name]
    tech.researched = true
    tech.enabled = false
    tech.visible_when_disabled = false
  end
end

local fill_up_rocket_juice = putil.on_any_built(function(evt)
  local entity = evt.entity
  local juice_name
  if entity.name == "platform-fuel-tank" then
    juice_name = "thruster-fuel"
  elseif entity.name == "platform-oxidizer-tank" then
    juice_name = "thruster-oxidizer"
  end
  if not juice_name then return end

  entity.insert_fluid{
    name = juice_name,
    amount = entity.fluidbox.get_capacity(1)
  }
end)

-- Dust beacons are handled specially
local COMPOUNDS = {
  -- ["platform-fuel-tank"] = {"platform-juice-tank-secret-pump"},
  -- ["platform-oxidizer-tank"] = {"platform-juice-tank-secret-pump"},
}
local kill_all_compounds = putil.on_any_removed(function(evt)
  local entity = evt.entity
  local killtypes = COMPOUNDS[entity.name]
  if not killtypes then return end
  local found = entity.surface.find_entities_filtered{
    area = entity.bounding_box,
    name = killtypes
  }
  for _,compound in ipairs(found) do
    if compound and compound.valid then
      compound.die()
    end
  end
end)

local tmp_you_win = function(evt)
  if evt.research.name ~= "space-platform" then return end
  game.set_win_ending_info{
    title="You win!",
    message="This is all the content I have so far",
    bullet_points={
      "You rock",
      "Wow they give you a lot of parameters here",
      "Congration"
    },
    final_message = "A winner is you yay"
  }
  game.set_game_state{
    can_continue=true,
    game_finished=true,
    player_won=true,
  }
end

script.on_configuration_changed(function(_)
  for _,force in pairs(game.forces) do
    add_qai_techs(force)
  end
end)

return {
  events = putil.smash_events{
    fill_up_rocket_juice,
    kill_all_compounds,
    {
      [defines.events.on_force_created] = function(evt) 
        add_qai_techs(evt.force)
      end,
      [defines.events.on_research_finished] = tmp_you_win,
      [defines.events.on_surface_created] = function(evt)
        local surface = game.surfaces[evt.surface_index]
        if surface.name == "aquilo" then
          surface.freeze_daytime = true
          -- 0 is midday for some reason
          -- 0.5 is the middle of the night i guess
          surface.daytime = 0.5
        end
      end,
    }
  },
  on_init = function()
    for _,force in pairs(game.forces) do
      add_qai_techs(force)
    end
  end
}
