local veh = require "__core__/lualib/event_handler"
veh.add_libraries({
  require("control/freeplay"),
  require("control/dust-pollution"),
  require("control/ore-inclusions"),
  require("control/rockets"),
  require("control/demolisher-crafting"),
  require("control/misc"),
})

require("control/compat")
