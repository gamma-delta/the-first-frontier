local util = require "__core__/lualib/util"
local putil = require("__petraspace__/control/utils")

return {
  events = {
    [defines.events.on_entity_died] = function(evt)
      if evt.cause == nil or not evt.cause.name:find("demolisher") then
        return
      end
      
    end
  }
}
