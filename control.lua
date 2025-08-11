local veh = require "__core__/lualib/event_handler"
veh.add_libraries({
  require("control/freeplay"),
  require("control/dust-pollution"),
  require("control/ore-inclusions"),
  require("control/rockets"),
  require("control/rockets/lrs-gui"),
  require("control/demolisher-crafting"),
  require("control/misc"),
})
