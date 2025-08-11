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
    mods = {"petraspace"},
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
    mods = {"petraspace"},
  },
  {
    type = "tips-and-tricks-item-category",
    name = "rocket-juice",
    order = "jz[after-quality]"
  },
  {
    type = "tips-and-tricks-item",
    name = "rocket-juice-intro",
    category = "rocket-juice",
    is_title = true,
    order = "!first",
    indent = 0,
    trigger = {type="research", technology="rocket-propellants"},
    simulation = rocket_juice.intro,
  },
  {
    type = "tips-and-tricks-item",
    name = "rocket-juice-many-kinds",
    category = "rocket-juice",
    is_title = false,
    order = "a",
    indent = 1,
    tag = "[item=rocket-fuel]",
    trigger = {type="research", technology="rocket-propellants"},
    simulation = rocket_juice.many_kinds
  },

  {
    type = "tips-and-tricks-item-category",
    name = "ps-misc",
    order = "zzz",
  },
  {
    type = "tips-and-tricks-item",
    name = "misc-intro",
    category = "ps-misc",
    is_title = true,
    order = "!first",
    indent = 0,
    starting_status = "unlocked",
  },
  {
    type = "tips-and-tricks-item",
    name = "dirty-steel",
    tag = "[item=steel-plate]",
    simulation = misc_tnt.dirty_steel,
    category = "ps-misc",
    is_title = false,
    order = "a",
    indent = 1,
    trigger = {type="research", technology="steel-processing"},
  },
  {
    type = "tips-and-tricks-item",
    name = "flamethrower-suckening",
    tag = "[item=flamethrower-turret]",
    category = "ps-misc",
    is_title = false,
    order = "b",
    indent = 1,
    trigger = {type="research", technology="flamethrower"},
  },
  {
    type = "tips-and-tricks-item",
    name = "ps-rocket-weight",
    tag = "[item=rocket-part]",
    category = "ps-misc",
    is_title = false,
    order = "c",
    indent = 1,
    trigger = {type="build-entity", entity="lunar-rocket-silo"},
  },
}
