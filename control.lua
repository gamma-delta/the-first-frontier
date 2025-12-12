local veh = require "__core__/lualib/event_handler"
local augh = {
  require("control/freeplay"),
  require("control/dust-pollution"),
  require("control/ore-inclusions"),
  require("control/rockets"),
  require("control/demolisher-crafting"),
  require("control/misc"),
}
log(serpent.block(augh))
veh.add_libraries(augh)

require("control/compat")
