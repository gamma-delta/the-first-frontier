local misc_tnt = require("prototypes/simulations/misc-tipsntricks")
local viate_tnt = require("prototypes/simulations/viate-tipsntricks")
local rocket_juice = require("prototypes/simulations/rocket-juice")

data:extend{
  {
    type = "tips-and-tricks-item",
    name = "pktff-viate-welcome",
    category = "space-age",
    tag = "[planet=pktff-viate]",
    order = "![before-fulgora]-a",
    trigger = {type="research", technology="pktff-discover-viate"},
    simulation = viate_tnt.welcome,
  },
  {
    type = "tips-and-tricks-item",
    name = "pktff-viate-dust",
    category = "space-age",
    order = "![before-fulgora]-b",
    indent = 1,
    tag = "[fluid=steam]",
    trigger = {type="change-surface", surface="pktff-viate"},
    simulation = viate_tnt.dust,
  },

  {
    type = "tips-and-tricks-item-category",
    name = "pktff-tff",
    order = "zzz",
  },
  {
    type = "tips-and-tricks-item",
    name = "pktff-tff",
    category = "pktff-tff",
    is_title = true,
    order = "!first",
    indent = 0,
    starting_status = "unlocked",
  },
  {
    type = "tips-and-tricks-item",
    name = "pktff-rocket-juice-intro",
    category = "pktff-tff",
    is_title = true,
    order = "a[rocket-juice]-a",
    indent = 1,
    tag = "[item=thruster]",
    trigger = {type="research", technology="rocket-silo"},
    simulation = rocket_juice.intro,
  },
  {
    type = "tips-and-tricks-item",
    name = "pktff-rocket-juice-many-kinds",
    category = "pktff-tff",
    is_title = false,
    order = "a[rocket-juice]-b",
    indent = 2,
    tag = "[item=rocket-fuel]",
    trigger = {type="research", technology="rocket-silo"},
    simulation = rocket_juice.many_kinds
  },
  {
    type = "tips-and-tricks-item",
    name = "pktff-rocket-weight",
    tag = "[item=rocket-part]",
    category = "pktff-tff",
    is_title = false,
    order = "a[rocket-juice]-c",
    indent = 1,
    trigger = {type="build-entity", entity="rocket-silo"},
  },

  {
    type = "tips-and-tricks-item",
    name = "pktff-dirty-steel",
    tag = "[item=steel-plate]",
    simulation = misc_tnt.dirty_steel,
    category = "pktff-tff",
    is_title = false,
    order = "b[balance]-a",
    indent = 1,
    trigger = {type="research", technology="steel-processing"},
  },
  {
    type = "tips-and-tricks-item",
    name = "pktff-flamethrower-suckening",
    tag = "[item=flamethrower-turret]",
    category = "pktff-tff",
    is_title = false,
    order = "b[balance]-b",
    indent = 1,
    trigger = {type="research", technology="flamethrower"},
  },
}
