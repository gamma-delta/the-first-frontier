local misc_tnt = require("prototypes/simulations/misc-tipsntricks")
local viate_tnt = require("prototypes/simulations/viate-tipsntricks")
local rocket_juice = require("prototypes/simulations/rocket-juice")

data:extend{
  {
    type = "tips-and-tricks-item",
    name = "viate-welcome",
    category = "space-age",
    tag = "[planet=viate]",
    order = "![before-fulgora]-a",
    trigger = {type="research", technology="discover-viate"},
    simulation = viate_tnt.welcome,
  },
  {
    type = "tips-and-tricks-item",
    name = "viate-dust",
    category = "space-age",
    order = "![before-fulgora]-b",
    indent = 1,
    tag = "[fluid=steam]",
    trigger = {type="change-surface", surface="viate"},
    simulation = viate_tnt.dust,
  },

  {
    type = "tips-and-tricks-item-category",
    name = "ps-tff",
    order = "zzz",
  },
  {
    type = "tips-and-tricks-item",
    name = "ps-tff-intro",
    category = "ps-tff",
    is_title = true,
    order = "!first",
    indent = 0,
    starting_status = "unlocked",
  },
  {
    type = "tips-and-tricks-item",
    name = "rocket-juice-intro",
    category = "ps-tff",
    is_title = true,
    order = "a[rocket-juice]-a",
    indent = 1,
    tag = "[item=thruster]",
    trigger = {type="research", technology="rocket-silo"},
    simulation = rocket_juice.intro,
  },
  {
    type = "tips-and-tricks-item",
    name = "rocket-juice-many-kinds",
    category = "ps-tff",
    is_title = false,
    order = "a[rocket-juice]-b",
    indent = 2,
    tag = "[item=rocket-fuel]",
    trigger = {type="research", technology="rocket-silo"},
    simulation = rocket_juice.many_kinds
  },
  {
    type = "tips-and-tricks-item",
    name = "ps-rocket-weight",
    tag = "[item=rocket-part]",
    category = "ps-tff",
    is_title = false,
    order = "a[rocket-juice]-c",
    indent = 1,
    trigger = {type="build-entity", entity="rocket-silo"},
  },

  {
    type = "tips-and-tricks-item",
    name = "dirty-steel",
    tag = "[item=steel-plate]",
    simulation = misc_tnt.dirty_steel,
    category = "ps-tff",
    is_title = false,
    order = "b[balance]-a",
    indent = 1,
    trigger = {type="research", technology="steel-processing"},
  },
  {
    type = "tips-and-tricks-item",
    name = "flamethrower-suckening",
    tag = "[item=flamethrower-turret]",
    category = "ps-tff",
    is_title = false,
    order = "b[balance]-b",
    indent = 1,
    trigger = {type="research", technology="flamethrower"},
  },
}
